const { expect } = require("chai");

describe("TrikonNFT ecosystem", function() {

  let owner, user1, user2;
  let nativeToken, trikonNFT, nftSellContract, nftBuyContract;

  beforeEach(async function() {
    [owner, user1, user2] = await ethers.getSigners();

    const NativeToken = await ethers.getContractFactory("Trikon");
    nativeToken = await NativeToken.deploy();
    await nativeToken.deployed();

    const TrikonNFT = await ethers.getContractFactory("TrikonNFT");
    trikonNFT = await TrikonNFT.deploy(nativeToken.address);
    await trikonNFT.deployed();

    const NFTSellContract = await ethers.getContractFactory("NFTSellContract");
    nftSellContract = await NFTSellContract.deploy(trikonNFT.address);
    await nftSellContract.deployed();

    const NFTBuyContract = await ethers.getContractFactory("NFTBuyContract");
    nftBuyContract = await NFTBuyContract.deploy(trikonNFT.address, nativeToken.address, nftSellContract.address);
    await nftBuyContract.deployed();
  });


  // Additional test scenarios to consider:
  // 1. Buying an NFT using native tokens.
  // 2. Delisting an NFT.
  // 3. Ensure you can't buy an NFT that isn't for sale.
  // 4. Checking token transfers for both native tokens and NFTs.
  // 5. Edge cases and security considerations (e.g., reentrancy attacks).

});

