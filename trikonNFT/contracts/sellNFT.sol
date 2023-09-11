// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTSellContract {
    
    // Declaring the struct for setting up the parameters of the listed NFT
    struct Listing {
        address seller;
        uint256 price;
        bool isForSale;
    }

    IERC721 private _nftContract;
    mapping(uint256 => Listing) public listings;

    constructor(address nftAddress) {
        _nftContract = IERC721(nftAddress);
    }

    // Listing your NFT on the marketplace
    function listNFTForSale(uint256 tokenId, uint256 price) external {
        require(_nftContract.ownerOf(tokenId) == msg.sender, "You don't own this NFT");
        _nftContract.approve(address(this), tokenId);
        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            isForSale: true
        });
    }

    // Delisting the NFT from the marketplace
    function delistNFT(uint256 tokenId) external {
        require(listings[tokenId].seller == msg.sender, "You're not the seller");
        listings[tokenId].isForSale = false;
        _nftContract.approve(address(this), 0);
    }

    // Getter function to fetch listing details
    function getListing(uint256 tokenId) external view returns (address seller, uint256 price, bool isForSale) {
        Listing memory listing = listings[tokenId];
        return (listing.seller, listing.price, listing.isForSale);
    }
}
