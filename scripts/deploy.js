const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;

  const metadataURL = METADATA_URL;

  const GSPContract = await ethers.getContractFactory("GlorySound");
  const deployedGSPContract = await GSPContract.deploy(
    metadataURL,
    whitelistContract
  );
  await deployedGSPContract.deployed();
  console.log("GlorySound", deployedGSPContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
