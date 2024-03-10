// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const stakingContract = await hre.ethers.deployContract("Staking", [
    "0xfec91a4ffbe5232b1cf778f226f1c0e2b0a9bf6e",
  ]);

  await stakingContract.waitForDeployment();

  console.log(`Staking deployed to ${stakingContract.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
