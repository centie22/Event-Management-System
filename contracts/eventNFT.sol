// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EventToken is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint public mintCost = 0.02 ether;

    constructor() ERC721("EventNFT", "eNFT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmYjPdp18sr4pb97BmQt8teVGi9Gjc5yeaySPWmHYZi4nP";
    }

    function safeMint(address to) public payable {
        payMintCost();
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function payMintCost () internal {
        require(msg.value == mintCost, "Not enough ether to mint NFT");
    }

    function withdraw () public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
