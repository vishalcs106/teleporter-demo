# Teleporter Demo Project

This project demonstrates a basic example or teleporter implementation. It comes with 3 contracts and deployment scripts.

MyNft.sol - Simple ERC721 contract
Staking.sol - Contract used to stake ERC721 tokens, this contarct sends the message
Rewards.sol - Contract used to reward stakers on C-Chain, this receives the messsage

MyNft.sol and Staking.sol should be deployed on a subnet, preferrably Dispatch subnet. Dispatch subnet was created especially for teleporter, it contains the necessary contracts and registry deployed.

Rewards.sol has to be deployed on C-Chain on fuji network.

Staking.sol expects the address of MyNft.sol. After deploying Staking.sol, call setDestinationContractAddress() and pass the deployed address of Rewards.sol.

0x7fc93d85c6d62c5b2ac0b519c87010ea5294012d1e407030d6acd0021cac10d5 is the blockchain id of C-Chain on fuji network.
0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf is the deployed address of ITeleporterMessenger on all chains and on all networks.
