// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./ITeleporterMessenger.sol";
import "./Actions.sol";
contract Staking {
    struct StakedToken {
        address staker;
        uint256 timestamp;
    }

    ITeleporterMessenger public immutable teleporterMessenger =
        ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);
    IERC721 public immutable nftToken;
    mapping(uint256 => StakedToken) public stakedTokens;
    address public destinationContractAddress;

    event Staked(address indexed user, uint256 tokenId, uint256 timestamp);
    event Unstaked(address indexed user, uint256 tokenId, uint256 timestamp);

    constructor(IERC721 _nftToken) {
        nftToken = _nftToken;
    }

    function setDestinationContractAddress(
        address _destinationAddress
    ) external {
        destinationContractAddress = _destinationAddress;
    }

    function encodeData(
        uint256 tokenId,
        Action action
    ) public view returns (bytes memory) {
        bytes memory paramsData = abi.encode(tokenId, msg.sender);
        return abi.encode(action, paramsData);
    }

    function callFunctionOnReceiver(uint256 tokenId, Action action) internal {
        bytes memory message = encodeData(tokenId, action);

        TeleporterFeeInfo memory feeInfo = TeleporterFeeInfo({
            feeTokenAddress: address(0),
            amount: 0
        });

        teleporterMessenger.sendCrossChainMessage(
            TeleporterMessageInput({
                destinationBlockchainID: 0x7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5,
                destinationAddress: destinationContractAddress,
                feeInfo: feeInfo,
                requiredGasLimit: 100000,
                allowedRelayerAddresses: new address[](0),
                message: message
            })
        );
    }

    function stake(uint256 tokenId) external {
        require(
            nftToken.ownerOf(tokenId) == msg.sender,
            "You do not own this token."
        );
        nftToken.transferFrom(msg.sender, address(this), tokenId);

        stakedTokens[tokenId] = StakedToken({
            staker: msg.sender,
            timestamp: block.timestamp
        });
        callFunctionOnReceiver(tokenId, Action.Stake);
        emit Staked(msg.sender, tokenId, block.timestamp);
    }

    function unstake(uint256 tokenId) external {
        require(
            stakedTokens[tokenId].staker == msg.sender,
            "You do not own this staked token."
        );
        nftToken.transferFrom(address(this), msg.sender, tokenId);
        delete stakedTokens[tokenId];
        callFunctionOnReceiver(tokenId, Action.Unstake);
        emit Unstaked(msg.sender, tokenId, block.timestamp);
    }
}
