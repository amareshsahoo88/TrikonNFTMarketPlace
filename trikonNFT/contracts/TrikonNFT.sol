// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TrikonNFT is ERC721Enumerable, Ownable {
    IERC20 private _token; // NativeToken reference 
    uint256 public tokenPrice; // Price to mint an NFT in terms of NativeToken
    uint256 public constant MAX_SUPPLY = 10000; // NFT Max supply
    string public baseURI; // Base URI for metadata

    constructor(address nativeTokenAddress, uint256 _tokenPrice, string memory _initialbaseURI) ERC721("TrikonNFT", "TKNFT") {
        _token = IERC20(nativeTokenAddress);
        tokenPrice = _tokenPrice;
        baseURI = _initialbaseURI;
    }

    // NFT minting function
    function mint(address recipient) external {
        require(totalSupply() < MAX_SUPPLY, "All NFTs have been minted");
        require(_token.balanceOf(msg.sender) >= tokenPrice, "Not enough NativeTokens to mint NFT");
        require(_token.transferFrom(msg.sender, address(this), tokenPrice), "Token transfer failed");

        uint256 newTokenId = totalSupply() + 1;
        _safeMint(recipient, newTokenId);
    }

    // function to return Base URI
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // function for changing the price of the NFT that can only be used by the owner of the contract
    function setTokenPrice(uint256 newPrice) external onlyOwner {
        tokenPrice = newPrice;
    }
    
    // Function to update baseURI
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    // Withdraw the collected Native tokens to the owners address
    function withdraw() external onlyOwner {
        uint256 balance = _token.balanceOf(address(this));
        require(_token.transfer(owner(), balance), "Withdrawal failed");
    }
}
