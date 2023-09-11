const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Deploy the NativeToken contract
  const NativeToken = await hre.ethers.getContractFactory("Trikon");
  const nativeToken = await NativeToken.deploy();
  await nativeToken.deployed();
  console.log("NativeToken deployed to:", nativeToken.address);  

  // Deploy the TrikonNFT contract
  const TrikonNFT = await hre.ethers.getContractFactory("TrikonNFT");
  const baseURI = "ipfs://bafybeihjtxzh23b7i3lgfqeslas5zbwsfgacv7pu3ebuxkoesffhf4pjai/"; // base URI
  const nftMintingPrice = ethers.utils.parseUnits('1', 18);
  const trikonNFT = await TrikonNFT.deploy(nativeToken.address, nftMintingPrice , baseURI); 
  await trikonNFT.deployed();
  console.log("TrikonNFT deployed to:", trikonNFT.address);  

  // Deploy the NFTSellContract
  const NFTSellContract = await hre.ethers.getContractFactory("NFTSellContract");
  const nftSellContract = await NFTSellContract.deploy(trikonNFT.address);  
  await nftSellContract.deployed();
  console.log("NFTSellContract deployed to:", nftSellContract.address);  

  // Deploy the NFTBuyContract
  const NFTBuyContract = await hre.ethers.getContractFactory("NFTBuyContract");
  const nftBuyContract = await NFTBuyContract.deploy(trikonNFT.address, nativeToken.address, nftSellContract.address);  
  await nftBuyContract.deployed();
  console.log("NFTBuyContract deployed to:", nftBuyContract.address);  
}

main()
  .then(() => process.exit(0))
  .catch(error => {
      console.error(error);
      process.exit(1);
  });
