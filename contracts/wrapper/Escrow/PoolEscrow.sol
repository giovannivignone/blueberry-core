// SPDX-License-Identifier: MIT
/*
██████╗ ██╗     ██╗   ██╗███████╗██████╗ ███████╗██████╗ ██████╗ ██╗   ██╗
██╔══██╗██║     ██║   ██║██╔════╝██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
██████╔╝██║     ██║   ██║█████╗  ██████╔╝█████╗  ██████╔╝██████╔╝ ╚████╔╝
██╔══██╗██║     ██║   ██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██╗██╔══██╗  ╚██╔╝
██████╔╝███████╗╚██████╔╝███████╗██████╔╝███████╗██║  ██║██║  ██║   ██║
╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
*/
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract PoolEscrow {
    using SafeERC20 for IERC20;

    /// @dev The caller is not authorized to call the function.
    error Unauthorized();

    /// @dev Address of the wrapper contract.
    address public wrapper;

    /// @dev PID of this escrow contract.
    uint256 public PID;

    /// @dev Ensures caller is the wrapper contract.
    modifier onlyWrapper() {
        if (msg.sender != wrapper) {
            revert Unauthorized();
        }
        _;
    }

    struct Pool {
        uint256 PID;
        /// ...
    }

    /// @dev Initializes the pool escrow with the given PID.
    function initialize(uint256 pid, address _wrapper) public payable virtual {
        _initializeEscrow(pid, _wrapper);
    }

    /**
     * @notice Transfers tokens to a specified address
     * @param _token The address of the token to be transferred
     * @param _to The address to which the tokens will be transferred
     * @param _amount The amount of tokens to be transferred
     */
    function transferFrom(
        address _token,
        address _to,
        uint256 _amount
    ) external virtual onlyWrapper {
        if (_amount > 0) {
            IERC20(_token).safeTransfer(_to, _amount);
        }
    }

    /// @dev Withdraws rewards from wrapper

    /// @dev Distributes rewards

    function _initializeEscrow(
        uint256 _pid,
        address _wrapper
    ) internal virtual {
        wrapper = _wrapper;
        PID = _pid;
    }
}
