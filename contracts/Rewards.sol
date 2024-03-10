// SPDX-License-Identifier: Ecosystem
pragma solidity 0.8.20;

import "./ITeleporterReceiver.sol";
import "./ITeleporterMessenger.sol";
import "./Actions.sol";

contract Rewards {
    ITeleporterMessenger public immutable teleporterMessenger =
        ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);
    mapping(uint256 => address) public tokenStake;

    event Staked(uint256 tokenId, address indexed staker);
    event UnStaked(uint256 tokenId, address indexed staker);

    function updateStake(uint256 tokenId, address holderAddress) internal {
        require(tokenStake[tokenId] == address(0), "Token already staked.");
        tokenStake[tokenId] = holderAddress;
        emit Staked(tokenId, holderAddress);
    }

    function updateUnstake(uint256 tokenId, address holderAddress) internal {
        require(tokenStake[tokenId] == holderAddress, "Not the staker.");
        tokenStake[tokenId] = address(0);
        emit UnStaked(tokenId, holderAddress);
    }

    function receiveTeleporterMessage(
        bytes32 originChainID,
        address originSenderAddress,
        bytes calldata message
    ) external {
        require(msg.sender == address(teleporterMessenger), "Unauthorized");
        (Action action, bytes memory paramsData) = abi.decode(
            message,
            (Action, bytes)
        );
        (uint256 tokenId, address holderAddress) = abi.decode(
            paramsData,
            (uint256, address)
        );
        if (action == Action.Stake) {
            updateStake(tokenId, holderAddress);
        } else if (action == Action.Unstake) {
            updateUnstake(tokenId, holderAddress);
        } else {
            revert("Receiver: invalid action");
        }
    }

    error Unauthorized();
}
