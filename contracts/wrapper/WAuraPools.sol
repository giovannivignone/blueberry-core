// SPDX-License-Identifier: MIT
/*
██████╗ ██╗     ██╗   ██╗███████╗██████╗ ███████╗██████╗ ██████╗ ██╗   ██╗
██╔══██╗██║     ██║   ██║██╔════╝██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
██████╔╝██║     ██║   ██║█████╗  ██████╔╝█████╗  ██████╔╝██████╔╝ ╚████╔╝
██╔══██╗██║     ██║   ██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██╗██╔══██╗  ╚██╔╝
██████╔╝███████╗╚██████╔╝███████╗██████╔╝███████╗██║  ██║██║  ██║   ██║
╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
*/

pragma solidity 0.8.22;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {FixedPointMathLib} from "../libraries/FixedPointMathLib.sol";

import "../utils/BlueBerryErrors.sol" as Errors;
import "../interfaces/IWAuraPools.sol";
import "../interfaces/IERC20Wrapper.sol";
import "../interfaces/aura/IAuraBooster.sol";
import "../interfaces/aura/IAuraRewarder.sol";
import "../interfaces/aura/IAura.sol";
import "../interfaces/aura/IAuraStashToken.sol";
import "../interfaces/aura/IAuraRewardPool.sol";
import "../interfaces/aura/IAuraExtraRewarder.sol";

import {IPoolEscrowFactory} from "./escrow/interfaces/IPoolEscrowFactory.sol";
import {IPoolEscrow} from "./escrow/interfaces/IPoolEscrow.sol";
import "hardhat/console.sol";
/**
 * @title WauraPools
 * @author BlueberryProtocol
 * @notice Wrapped Aura Pools is the wrapper of LP positions
 * @dev Leveraged LP Tokens will be wrapped here and be held in BlueberryBank
 *      and do not generate yields. LP Tokens are identified by tokenIds
 *      encoded from lp token address.
 */
contract WAuraPools is
    ERC1155Upgradeable,
    ReentrancyGuardUpgradeable,
    OwnableUpgradeable,
    IERC20Wrapper,
    IWAuraPools
{
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using FixedPointMathLib for uint256;

    event Minted(uint256 pid, uint256 amount, address indexed user);

    event Burned(uint256 id, uint256 amount, address indexed user);

    /*//////////////////////////////////////////////////////////////////////////
                                   PUBLIC STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Address to AURA token
    IAura public AURA;
    /// @dev Address of the Aura Booster contract
    IAuraBooster public auraBooster;
    /// @dev Address of the escrow factory
    IPoolEscrowFactory public escrowFactory;
    /// @dev Mapping from token id to accExtPerShare
    mapping(uint256 => mapping(address => uint256)) public accExtPerShare;
    /// @dev Aura extra rewards addresses
    address[] public extraRewards;
    /// @dev The index of extra rewards
    mapping(address => uint256) public extraRewardsIndex;
    /// @dev AURA reward per share by pid
    mapping(uint256 => uint256) public auraPerShareByPid;
    /// token id => auraPerShareDebt;
    mapping(uint256 => uint256) public auraPerShareDebt;
    /// @dev pid => last bal reward per token
    mapping(uint256 => uint256) public lastBalPerTokenByPid;
    /// @dev pid => escrow contract address
    mapping(uint256 => address) public escrows;
    /// @dev pid => total amount of AURA paid out
    mapping(uint256 => uint256) public auraPaid;
    /// @dev pid => current reward per token
    mapping(uint256 => uint256) public currentRewardPerToken;

    /// @dev pid => stash token data
    mapping(uint256 => StashTokenInfo) public stashTokenInfo;

    struct StashTokenInfo {
        address stashToken;
        address rewarder;
        uint256 lastStashRewardPerToken;
        uint256 stashAuraReceived;
    }

    uint256 public REWARD_MULTIPLIER_DENOMINATOR;

    /*//////////////////////////////////////////////////////////////////////////
                                      FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Initializes contract with dependencies
    /// @param aura_ The AURA token address
    /// @param auraBooster_ The auraBooster contract address
    /// @param escrowFactory_ The escrow factory contract address
    function initialize(
        address aura_,
        address auraBooster_,
        address escrowFactory_
    ) external initializer {
        if (
            aura_ == address(0) ||
            auraBooster_ == address(0) ||
            escrowFactory_ == address(0)
        ) {
            revert Errors.ZERO_ADDRESS();
        }
        __ReentrancyGuard_init();
        __ERC1155_init("WauraBooster");
        AURA = IAura(aura_);
        escrowFactory = IPoolEscrowFactory(escrowFactory_);
        auraBooster = IAuraBooster(auraBooster_);
        REWARD_MULTIPLIER_DENOMINATOR = auraBooster
            .REWARD_MULTIPLIER_DENOMINATOR();
    }

    /// @notice Encodes pool id and BAL per share into an ERC1155 token id
    /// @param pid The pool id (The first 16-bits)
    /// @param balPerShare Amount of BAL per share, multiplied by 1e18 (The last 240-bits)
    /// @return id The resulting ERC1155 token id
    function encodeId(
        uint256 pid,
        uint256 balPerShare
    ) public pure returns (uint256 id) {
        // Ensure the pool id and auraPerShare are within expected bounds
        if (pid >= (1 << 16)) revert Errors.BAD_PID(pid);
        if (balPerShare >= (1 << 240))
            revert Errors.BAD_REWARD_PER_SHARE(balPerShare);
        return (pid << 240) | balPerShare;
    }

    /// @notice Decodes ERC1155 token id to pool id and BAL per share
    /// @param id The ERC1155 token id
    /// @return gid The decoded pool id
    /// @return balPerShare The decoded amount of BAL per share
    function decodeId(
        uint256 id
    ) public pure returns (uint256 gid, uint256 balPerShare) {
        gid = id >> 240; // Extracting the first 16 bits
        balPerShare = id & ((1 << 240) - 1); // Extracting the last 240 bits
    }

    /// @notice Retrieves the underlying ERC20 token of the specified ERC1155 token id
    /// @param id The ERC1155 token id
    /// @return uToken Address of the underlying ERC20 token
    function getUnderlyingToken(
        uint256 id
    ) external view override returns (address uToken) {
        (uint256 pid, ) = decodeId(id);
        (uToken, , , , , ) = getPoolInfoFromPoolId(pid);
    }

    /// @notice Gets the Balancer vault for a given BPT token
    /// @param bpt Address of the BPT token
    /// @return Vault associated with the provided BPT token
    function getVault(address bpt) public view returns (IBalancerVault) {
        return IBalancerVault(IBalancerPool(bpt).getVault());
    }

    /// @notice Gets the escrow contract address for a given PID
    /// @param pid The pool ID
    /// @return escrowAddress Escrow associated with the given PID
    function getEscrow(
        uint256 pid
    ) public view returns (address escrowAddress) {
        return escrows[pid];
    }

    /// @notice Retrieves pool tokens from a given BPT address
    /// @param bpt Address of the BPT token
    /// @return tokens Array of token addresses in the pool
    /// @return balances Corresponding balances of the tokens in the pool
    /// @return lastChangedBlock The last block when the pool composition changed
    function getPoolTokens(
        address bpt
    )
        external
        view
        returns (
            address[] memory tokens,
            uint256[] memory balances,
            uint256 lastChangedBlock
        )
    {
        return getVault(bpt).getPoolTokens(IBalancerPool(bpt).getPoolId());
    }

    /// @notice Retrieves pool id from a BPT token
    /// @param bpt Address of the BPT token
    /// @return Pool id associated with the BPT token
    function getBPTPoolId(address bpt) public view returns (bytes32) {
        return IBalancerPool(bpt).getPoolId();
    }

    /// @notice Fetches pool information using a provided aura finance pool id
    /// @param pid The aura finance pool id
    /// @return lptoken Address of the LP token
    /// @return token Address of the associated token
    /// @return gauge Address of the gauge
    /// @return auraRewards Address for AURA rewards
    /// @return stash Address of the stash
    /// @return shutdown Boolean indicating if the pool is shut down
    function getPoolInfoFromPoolId(
        uint256 pid
    )
        public
        view
        returns (
            address lptoken,
            address token,
            address gauge,
            address auraRewards,
            address stash,
            bool shutdown
        )
    {
        return auraBooster.poolInfo(pid);
    }

    /// @notice Retrieve pending rewards for a given tokenId and amount.
    /// @dev The rewards can be split among multiple tokens.
    /// @param tokenId The ID of the token.
    /// @param amount The amount of the token.
    /// @return tokens Array of token addresses.
    /// @return rewards Array of corresponding reward amounts.
    function pendingRewards(
        uint256 tokenId,
        uint256 amount
    )
        public
        view
        override
        returns (address[] memory tokens, uint256[] memory rewards)
    {
        (uint256 pid, uint256 originalBalPerShare) = decodeId(tokenId);
        (address lpToken, , , address auraRewarder, , ) = getPoolInfoFromPoolId(
            pid
        );
        uint256 lpDecimals = IERC20MetadataUpgradeable(lpToken).decimals();
        uint256 extraRewardsCount = extraRewards.length;
        tokens = new address[](extraRewardsCount + 2);
        rewards = new uint256[](extraRewardsCount + 2);

        /// BAL reward
        tokens[0] = IAuraRewarder(auraRewarder).rewardToken();
        rewards[0] = _getPendingReward(
            originalBalPerShare,
            auraRewarder,
            amount,
            lpDecimals
        );
        /// AURA reward
        tokens[1] = address(AURA);
        rewards[1] = _getAllocatedAURA(pid, originalBalPerShare, amount);

        /// Additional rewards
        for (uint256 i; i < extraRewardsCount; ++i) {
            address rewarder = extraRewards[i];
            uint256 tokenRewardPerShare = accExtPerShare[tokenId][rewarder];
            tokens[i + 2] = IAuraRewarder(rewarder).rewardToken();
            if (tokenRewardPerShare == 0) {
                rewards[i + 2] = 0;
            } else {
                rewards[i + 2] = _getPendingReward(
                    tokenRewardPerShare == type(uint).max ? 0 : tokenRewardPerShare,
                    rewarder,
                    amount,
                    lpDecimals
                );
            }
        }
    }

    /// @notice Mint an ERC1155 token corresponding to the provided LP token amount.
    /// @param pid The ID of the AURA pool.
    /// @param amount The amount of the LP token to be wrapped.
    /// @return id The minted ERC1155 token's ID.
    function mint(
        uint256 pid,
        uint256 amount
    ) external nonReentrant returns (uint256 id) {
        (address lpToken, , , address auraRewarder, , ) = getPoolInfoFromPoolId(
            pid
        );

        /// Escrow deployment/get logic
        address escrow;

        if (escrows[pid] == address(0)) {
            escrow = escrowFactory.createEscrow(pid, auraRewarder, lpToken);
            escrows[pid] = escrow;
        } else {
            escrow = escrows[pid];
        }

        IERC20Upgradeable(lpToken).safeTransferFrom(
            msg.sender,
            escrow,
            amount
        );
        
        /// Deposit LP from escrow contract
        IPoolEscrow(escrow).deposit(amount);

        _updateAuraReward(pid);

        /// BAL reward handle logic
        uint256 balRewardPerToken = IAuraRewarder(auraRewarder)
            .rewardPerToken();
        id = encodeId(pid, balRewardPerToken);

        _mint(msg.sender, id, amount, "");
        /// Store extra rewards info
        uint256 extraRewardsCount = IAuraRewarder(auraRewarder)
            .extraRewardsLength();
        for (uint256 i; i != extraRewardsCount; ++i) {
            address extraRewarder = IAuraRewarder(auraRewarder).extraRewards(i);
            uint256 rewardPerToken = IAuraRewarder(extraRewarder)
                .rewardPerToken();
            accExtPerShare[id][extraRewarder] = rewardPerToken == 0
                ? type(uint).max
                : rewardPerToken;

            _syncExtraReward(extraRewarder);
        }

        emit Minted(pid, amount, msg.sender);

        auraPerShareDebt[id] += auraPerShareByPid[pid];
    }

    /// @notice Burn the provided ERC1155 token and redeem its underlying ERC20 token.
    /// @param id The ID of the ERC1155 token to burn.
    /// @param amount The amount of the ERC1155 token to burn.
    /// @return rewardTokens An array of reward tokens that the user is eligible to receive.
    /// @return rewards The corresponding amounts of reward tokens.
    function burn(
        uint256 id,
        uint256 amount
    )
        external
        nonReentrant
        returns (address[] memory rewardTokens, uint256[] memory rewards, address stashToken)
    {
        (uint256 pid, ) = decodeId(id);
        address escrow = escrows[pid];
        console.log("Aura balance: %s", AURA.balanceOf(escrow));

        // @dev sanity check
        assert(escrow != address(0));

        if (amount == type(uint256).max) {
            amount = balanceOf(msg.sender, id);
        }
        
        (rewardTokens, rewards) = pendingRewards(id, amount);

        _updateAuraReward(pid);

        StashTokenInfo storage _stashTokenInfo = stashTokenInfo[pid];
        stashToken = _stashTokenInfo.stashToken;

        _burn(msg.sender, id, amount);

        /// Claim and withdraw LP from escrow contract
        IPoolEscrow(escrow).claimAndWithdraw(amount, msg.sender);

        uint256 rewardTokensLength = rewardTokens.length;
        for (uint256 i; i < rewardTokensLength; ++i) {
            address _rewardToken = rewardTokens[i];
            /// If the reward token is AURA
            if (_rewardToken == stashToken) {
                _rewardToken = address(AURA);
            }
            console.log("rewardToken: %s", _rewardToken);
            console.log("rewards: %s", rewards[i]);
            console.log("balance: %s", IERC20Upgradeable(_rewardToken).balanceOf(escrow));

            IPoolEscrow(escrow).transferToken(
                _rewardToken,
                msg.sender,
                rewards[i]
            );
        }
        emit Burned(id, amount, msg.sender);
    }

    /// @notice Get the full set of extra rewards.
    /// @return An array containing the addresses of extra reward tokens.
    function extraRewardsLength() external view returns (uint256) {
        return extraRewards.length;
    }

    /// @notice Calculate the amount of pending reward for a given LP amount.
    /// @param originalRewardPerShare The cached value of BAL per share at the time of opening the position.
    /// @param rewarder The address of the rewarder contract.
    /// @param amount The amount of LP for which reward is being calculated.
    /// @param lpDecimals The number of decimals of the LP token.
    /// @return rewards The calculated reward amount.
    function _getPendingReward(
        uint256 originalRewardPerShare,
        address rewarder,
        uint256 amount,
        uint256 lpDecimals
    ) internal view returns (uint256 rewards) {
        /// Retrieve current reward per token from rewarder
        uint256 currentRewardPerShare = IAuraRewarder(rewarder).rewardPerToken();
        /// Calculatethe difference in reward per share
        uint256 share = currentRewardPerShare > originalRewardPerShare
            ? currentRewardPerShare - originalRewardPerShare
            : 0;
        /// Calculate the total rewards base on share and amount.
        rewards = share * amount / 10 ** lpDecimals;
    }

    /// @notice  Calculate the pending AURA reward amount.
    /// @dev AuraMinter can mint additional tokens after `inflationProtectionTime` has passed
    /// And its value is `1749120350`  ==> Thursday 5 June 2025 12:32:30 PM GMT+07:00
    /// @param auraRewarder Address of Aura rewarder contract
    /// @param balAmount The amount of BAL reward for AURA calculation.
    /// @dev AURA token is minted in booster contract following the mint logic in the below
    function _getAuraPendingReward(
        address auraRewarder,
        uint256 balAmount
    ) internal view returns (uint256 mintAmount) {
        if (balAmount == 0) return 0;
        /// AURA mint request amount = amount * reward_multiplier / reward_multiplier_denominator
        uint256 mintRequestAmount = balAmount * auraBooster.getRewardMultipliers(auraRewarder) / REWARD_MULTIPLIER_DENOMINATOR;

        /// AURA token mint logic
        /// e.g. emissionsMinted = 6e25 - 5e25 - 0 = 1e25;
        uint256 totalSupply = AURA.totalSupply();
        uint256 initAmount = AURA.INIT_MINT_AMOUNT();
        uint256 minterMinted;
        uint256 reductionPerCliff = AURA.reductionPerCliff();
        uint256 totalCliffs = AURA.totalCliffs();
        uint256 emissionMaxSupply = AURA.EMISSIONS_MAX_SUPPLY();

        uint256 emissionsMinted = totalSupply - initAmount - minterMinted;
        /// e.g. reductionPerCliff = 5e25 / 500 = 1e23
        /// e.g. cliff = 1e25 / 1e23 = 100
        uint256 cliff = emissionsMinted / reductionPerCliff;

        /// e.g. 100 < 500
        if (cliff < totalCliffs) {
            /// e.g. (new) reduction = (500 - 100) * 2.5 + 700 = 1700;
            /// e.g. (new) reduction = (500 - 250) * 2.5 + 700 = 1325;
            /// e.g. (new) reduction = (500 - 400) * 2.5 + 700 = 950;
            uint256 reduction = ((totalCliffs - cliff) * 5) / 2 + 700;
            /// e.g. (new) amount = 1e19 * 1700 / 500 =  34e18;
            /// e.g. (new) amount = 1e19 * 1325 / 500 =  26.5e18;
            /// e.g. (new) amount = 1e19 * 950 / 500  =  19e17;
            mintAmount = (mintRequestAmount * reduction) / totalCliffs;

            /// e.g. amtTillMax = 5e25 - 1e25 = 4e25
            uint256 amtTillMax = emissionMaxSupply - emissionsMinted;
            if (mintAmount > amtTillMax) {
                mintAmount = amtTillMax;
            }
        }
    }

    function _getAllocatedAURA(
        uint256 pid,
        uint256 originalBalPerShare,
        uint256 amount
    ) internal view returns (uint256 mintAmount) {
        address escrow = escrows[pid];

        (address lpToken, , , address auraRewarder, , ) = getPoolInfoFromPoolId(
            pid
        );
        uint256 currentDeposits = IAuraRewarder(auraRewarder).balanceOf(
            escrow
        );

        if (currentDeposits == 0) {
            return 0;
        }

        uint256 auraPerShare = auraPerShareByPid[pid] -
            auraPerShareDebt[encodeId(pid, originalBalPerShare)];

        uint256 lastBalPerToken = lastBalPerTokenByPid[pid];

        uint256 lpDecimals = IERC20MetadataUpgradeable(lpToken).decimals();
        uint256 earned = _getPendingReward(
            lastBalPerToken,
            auraRewarder,
            currentDeposits,
            lpDecimals
        );

        if (earned > 0) {
            uint256 auraReward = _getAuraPendingReward(auraRewarder, earned);

            auraPerShare += auraReward.divWadDown(currentDeposits);
        }

        return auraPerShare.mulWadDown(amount);
    }

    /// @notice Private function to update aura rewards
    /// @param pid The ID of the AURA pool.
    /// @dev Claims rewards and updates auraPerShareByPid accordingly
    function _updateAuraReward(uint256 pid) private {
        StashTokenInfo storage _stashTokenInfo = stashTokenInfo[pid];
        address escrow = escrows[pid];
        address stashToken = _stashTokenInfo.stashToken;

        // _auraRewarder rewards users in AURA
        (, , , address _auraRewarder, address stashAura, ) = getPoolInfoFromPoolId(pid);

        uint256 lastBalPerToken = IAuraRewarder(_auraRewarder).rewardPerToken();

        lastBalPerTokenByPid[pid] = lastBalPerToken;

        if (stashToken == address(0)) {
            _setAuraStashToken(_stashTokenInfo, _auraRewarder, stashAura);
        }

        uint256 currentDeposits = IAuraRewarder(_auraRewarder).balanceOf(
            escrow
        );

        if (currentDeposits == 0) {
            return;
        }

        uint256 auraPreBalance = AURA.balanceOf(escrow);

        IAuraRewarder(_auraRewarder).getReward(escrow, false);

        uint256 auraReceived = AURA.balanceOf(escrow) - auraPreBalance;

        _getExtraRewards(escrow, stashToken);

        if (auraReceived > 0) {
            auraPerShareByPid[pid] += auraReceived.divWadDown(currentDeposits);
        }
    }

    function _getExtraRewards(address escrow, address stashToken) internal {
        uint256 extraRewardsCount = extraRewards.length;
        for (uint256 i; i < extraRewardsCount; ++i) {
            address extraRewarder = extraRewards[i];
            address rewardToken = IAuraExtraRewarder(extraRewarder).rewardToken();

            if (rewardToken == stashToken) {
                IAuraExtraRewarder(extraRewarder).getReward(escrow);
            }
        }
    }

    /**
     * @notice Sets the Aura Stash token
     * @param auraRewarder Address of the Aura Rewarder
     * @param stashAura Address of the stash Aura
     */
    function _setAuraStashToken(StashTokenInfo storage stashTokenData, address auraRewarder, address stashAura) internal {
        uint256 length = IAuraRewarder(auraRewarder).extraRewardsLength();
        for (uint256 i; i < length; ++i) {
            address _extraRewarder = IAuraRewarder(auraRewarder)
                .extraRewards(i);

            address _rewardToken = IAuraRewarder(_extraRewarder)
                .rewardToken();
            // Initialize the stashToken if it is not initialized
            if (_isAuraStashToken(_rewardToken, stashAura)) {
                stashTokenData.stashToken = _rewardToken;
                stashTokenData.rewarder = _extraRewarder;
                break;
            }
        }
    }
    
    /**
     * 
     * @param auraRewarder Address of the Aura Rewarder
     * @return rewardMismatch True if the extra rewards length has changed
     */
    function _rewardMismatch(address auraRewarder) internal returns (bool rewardMismatch) {
        uint256 prevRewardLength = extraRewards.length;
        uint256 extraRewardsCount = IAuraRewarder(auraRewarder)
            .extraRewardsLength();
        
        for (uint256 i; i != extraRewardsCount; ++i) {
            _syncExtraReward(IAuraRewarder(auraRewarder).extraRewards(i));
        }

        rewardMismatch = prevRewardLength != extraRewardsCount;
    }

    /**
     * @notice Internal function to sync any extra rewards with the contract.
     * @param extraReward The address of the extra reward token.
     * @dev Adds the extra reward to the internal list if not already present.
     */
    function _syncExtraReward(address extraReward) private {
        if (extraRewardsIndex[extraReward] == 0) {
            extraRewards.push(extraReward);
            extraRewardsIndex[extraReward] = extraRewards.length;
        }
    }

    /**
     * @notice Checks if a token is an Aura Stash token
     * @param token Address of the token to check
     * @param auraStash Address of the Aura Stash
     */
    function _isAuraStashToken(address token, address auraStash) internal view returns (bool) {
        try IAuraStashToken(token).stash() returns (address stash) {
            return stash == auraStash;
        } catch  {
            return false;
        }
    }
}

