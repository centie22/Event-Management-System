import { ethers } from "hardhat";

async function main() {

  const EventToken = await ethers.getContractFactory("EventToken");
  const token = await EventToken.deploy();

  await token.deployed();

  console.log(`Event token has been deployed to ${token.address}`);

  const MintNFT = await token.safeMint("0x049C780d7fa94AA70194eFC88ee109781eaeE1C2");
  await MintNFT;

  const checkBalance = await token.balanceOf("0x049C780d7fa94AA70194eFC88ee109781eaeE1C2")
  await checkBalance;

  console.log("This address has: ", checkBalance);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
