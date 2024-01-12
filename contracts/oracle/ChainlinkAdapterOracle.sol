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

import { SafeCast } from "@openzeppelin/contracts/utils/math/SafeCast.sol";

import { BaseAdapter } from "./BaseAdapter.sol";

import "../utils/BlueberryConst.sol" as Constants;
import "../utils/BlueberryErrors.sol" as Errors;

import { IAnkrETH } from "../interfaces/IAnkrETH.sol";
import { IBaseOracle } from "../interfaces/IBaseOracle.sol";
import { IFeedRegistry } from "../interfaces/chainlink/IFeedRegistry.sol";
import { IWstETH } from "../interfaces/IWstETH.sol";

/// @title ChainlinkAdapterOracle for L1 Chains
/// @author BlueberryProtocol
/// @notice This Oracle Adapter leverages Chainlink's decentralized price feeds to provide accurate price data.
///         It also supports remapping of tokens to their canonical forms (e.g., WBTC to BTC).
contract ChainlinkAdapterOracle is IBaseOracle, BaseAdapter {
    using SafeCast for int256;

    /*//////////////////////////////////////////////////////////////////////////
                                      PUBLIC STORAGE 
    //////////////////////////////////////////////////////////////////////////*/

    /// Chainlink feed registry for accessing price feeds.
    /// (source: https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/Denominations.sol)
    IFeedRegistry public registry;
    /// Address representing USD in Chainlink's denominations.
    address public constant USD = address(840);

    /// @dev Maps tokens to their canonical form for price querying.
    ///      For example, WETH may be remapped to ETH, WBTC to BTC, etc.
    mapping(address => address) public remappedTokens;

    /// @dev WstETH address
    address public constant WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;

    /// @dev ankrETH address
    address public constant ANKRETH = 0xE95A203B1a91a908F9B9CE46459d101078c2c3cb;

    /*//////////////////////////////////////////////////////////////////////////
                                     EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Emitted when the Chainlink feed registry used by the adapter is updated.
    /// @param registry The new Chainlink feed registry address.
    event SetRegistry(address registry);

    /// @notice Emitted when a token is remapped to its canonical form.
    /// @param token The original token address that's being remapped.
    /// @param remappedToken The canonical form of the token to which the original is remapped.
    event SetTokenRemapping(address indexed token, address indexed remappedToken);

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTRUCTOR
    //////////////////////////////////////////////////////////////////////////*/

    /// @param registry_ Chainlink feed registry address.
    constructor(IFeedRegistry registry_) {
        if (address(registry_) == address(0)) revert Errors.ZERO_ADDRESS();

        registry = registry_;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Updates the Chainlink feed registry used by this adapter.
    /// @param registry_ The new Chainlink feed registry address.
    /// @dev Can only be called by the contract owner.
    function setFeedRegistry(IFeedRegistry registry_) external onlyOwner {
        if (address(registry_) == address(0)) revert Errors.ZERO_ADDRESS();
        registry = registry_;
        emit SetRegistry(address(registry_));
    }

    /// @notice Maps a list of tokens to their canonical form for price queries.
    /// @param tokens_ The list of tokens to be remapped.
    /// @param remappedTokens_ The list of tokens to remap to.
    /// @dev Both arrays should have the same length. Can only be called by the contract owner.
    function setTokenRemappings(address[] calldata tokens_, address[] calldata remappedTokens_) external onlyOwner {
        if (remappedTokens_.length != tokens_.length) revert Errors.INPUT_ARRAY_MISMATCH();
        for (uint256 i = 0; i < tokens_.length; ++i) {
            if (tokens_[i] == address(0)) revert Errors.ZERO_ADDRESS();

            remappedTokens[tokens_[i]] = remappedTokens_[i];
            emit SetTokenRemapping(tokens_[i], remappedTokens_[i]);
        }
    }

    /// @notice Fetches the USD price of the specified token from Chainlink's feed.
    ///         If the token has been remapped, it uses the canonical form for price querying.
    /// @param token_ Address of the token for which to fetch the price.
    /// @return price The USD price of the token, represented with 18 decimals.
    function getPrice(address token_) external view override returns (uint256) {
        /// remap token if possible
        address token = remappedTokens[token_];
        if (token == address(0)) token = token_;

        uint256 maxDelayTime = timeGaps[token];
        if (maxDelayTime == 0) revert Errors.NO_MAX_DELAY(token_);

        /// Get token-USD price
        uint256 decimals = registry.decimals(token, USD);
        (uint80 roundID, int256 answer, , uint256 updatedAt, uint80 answeredInRound) = registry.latestRoundData(
            token,
            USD
        );

        if (updatedAt < block.timestamp - maxDelayTime) revert Errors.PRICE_OUTDATED(token_);
        if (answer <= 0) revert Errors.PRICE_NEGATIVE(token_);
        if (answeredInRound < roundID) revert Errors.PRICE_OUTDATED(token_);

        if (token_ == WSTETH) {
            return
                ((answer.toUint256() * Constants.PRICE_PRECISION) * IWstETH(WSTETH).stEthPerToken()) /
                10 ** (18 + decimals);
        } else if (token_ == ANKRETH) {
            return
                ((answer.toUint256() * Constants.PRICE_PRECISION) *
                    IAnkrETH(ANKRETH).sharesToBonds(Constants.PRICE_PRECISION)) / 10 ** (18 + decimals);
        }

        return (answer.toUint256() * Constants.PRICE_PRECISION) / 10 ** decimals;
    }
}
