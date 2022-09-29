// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "./IWhitelist.sol";


contract GlorySound is ERC721Enumerable, Ownable {
    string _baseTokenURI;
    IWhitelist whitelist;
    bool public wlSaleStarted;
    uint256 public wlSaleEnded;
    uint256 public maxIDs = 1000;
    uint256 public tokenIDs;
    uint256 public _publicPrice = 0.01 ether;
    uint256 public _wlPrice = 0.005 ether;
    bool public _paused;

    modifier onlyWhenNotPaused{
        require(!_paused, "Contract currently paused");
        _;
    }

    constructor(string memory baseURI, address whitelistContract) ERC721("Glory Sound Prep", "GSP"){
      _baseTokenURI = baseURI;
      whitelist = IWhitelist(whitelistContract);
      
    }
    function startWLSale() public onlyOwner {
        wlSaleStarted = true;
        wlSaleEnded = block.timestamp + 120 minutes;
    }

    function wLMint() public payable onlyWhenNotPaused {
        require(wlSaleStarted && block.timestamp < wlSaleEnded, "WL Sale ended");
        require(whitelist.whitelisted(msg.sender), "Not A WListed MF");
        require(tokenIDs < maxIDs, "Private Sale Over");
        require(msg.value >= _wlPrice, "Not enough funds");
        tokenIDs += 1;
        _safeMint(msg.sender, tokenIDs);
    }


    function mint() public payable onlyWhenNotPaused{
         require(wlSaleStarted && block.timestamp >= wlSaleEnded, "WL Sale ended");
        require(tokenIDs < maxIDs, "Private Sale Over");
        require(msg.value >= _publicPrice, "Not enough funds");
        tokenIDs += 1;
        _safeMint(msg.sender, tokenIDs);
    }

    function _baseURI() internal view override returns (string memory){
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner{
        _paused = val;
    } 

    function withdraw() public onlyOwner{
        address owner = owner();
        uint256 amount = address(this).balance;
        (bool sent,) = owner.call{value: amount}("");
        require(sent, "Failed to send");
    }
    receive () external payable{}
    fallback() external payable{}
}

