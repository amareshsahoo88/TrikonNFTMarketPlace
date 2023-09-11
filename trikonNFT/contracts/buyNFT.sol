// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./sellNFT.sol";  // importing sellNFT contract

contract NFTBuyContract {
    
    IERC20 private _token; 
    IERC721 private _nftContract;
    NFTSellContract private _sellContract;

    constructor(address tokenAddress, address nftAddress, address sellContractAddress) {
        _token = IERC20(tokenAddress);
        _nftContract = IERC721(nftAddress);
        _sellContract = NFTSellContract(sellContractAddress);
    }

    // Buy NFT Function
    function buyNFT(uint256 tokenId) external {
        (address seller, uint256 price, bool isForSale) = _sellContract.getListing(tokenId);
        require(isForSale, "This NFT is not for sale");
        require(_token.allowance(msg.sender, address(this)) >= price, "Token allowance not sufficient");
        require(_token.transferFrom(msg.sender, seller, price), "Token transfer failed");
        _nftContract.transferFrom(seller, msg.sender, tokenId);
        _sellContract.delistNFT(tokenId);
    }
}
