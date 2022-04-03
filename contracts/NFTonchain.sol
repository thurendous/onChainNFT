// SPDX-License-Identifier: MIT

// Amended by HashLips
/**
    !Disclaimer!
    These contracts have been used to create tutorials,
    and was created for the purpose to teach people
    how to create smart contracts on the blockchain.
    please review this code on your own before using any of
    the following code for production.
    HashLips will not be liable in any way if for the use 
    of the code. That being said, the code has been tested 
    to the best of the developers' knowledge to work as intended.
*/

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract NFTonchain is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseExtension = ".json";
  uint256 public cost = 0.001 ether;
  uint256 public maxSupply = 100;
//   uint256 public maxMintAmount = 10;
//   bool public paused = false;
//   bool public revealed = false;

  constructor() ERC721("OnChain NFT","CTN OCN"){}

  // public
  function mint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    // require(!paused);
    require(_mintAmount > 0);
    // require(_mintAmount <= maxMintAmount);
    require(supply + _mintAmount <= maxSupply);

    if (msg.sender != owner()) {
      require(msg.value >= cost * _mintAmount);
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
      require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
      return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
            '{"name": "OnChainTest',
            '", "description": "First test'
            '", "image": "data:image/svg+xml;base64,',
            buildImage(),
            '"}'
          )))));
  }

  //only owner
//   function reveal() public onlyOwner {
//       revealed = true;
//   }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

//   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
//     maxMintAmount = _newmaxMintAmount;
//   }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

//   function pause(bool _state) public onlyOwner {
//     paused = _state;
//   }
 
  function withdraw() public payable onlyOwner {    
    // This will payout the owner 95% of the contract balance.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }

  function buildImage() public pure returns(string memory) {
      return Base64.encode(bytes(string(abi.encodePacked(
    '<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">',
    '<ellipse ry="119.5" rx="255.5" cy="230.5" cx="403.5" stroke="#000" fill="#fff"/>',
    '<text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="30" id="svg_2" y="240" x="309" fill="#000000">HELLO SON</text>',
        '</svg>'
      ))));
  }
}