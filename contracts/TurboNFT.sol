//SPDX-License-Identifier: MIT
pragma solidity 0.8.23;
import "./interface/ITurboNFT.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TurboNFT is ITurboNFT, ERC721Enumerable {
    address private immutable minter;
    uint256 public currentId;
    string public URIPrefix;
    string public URISuffix;
    address private uriEditor;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory _URIPrefix,
        string memory _URISuffix, 
        address _uriEditor
    ) ERC721(name_, symbol_) {
        URIPrefix = _URIPrefix;
        URISuffix = _URISuffix;
        minter = msg.sender;
        uriEditor = _uriEditor;
    }

    function drop(address receiver) external override {
        require(msg.sender == minter);
        _safeMint(receiver, currentId++);
    }

    function setTokenURIParts(
        string memory _URIPrefix,
        string memory _URISuffix
    ) public {
        require(msg.sender == uriEditor);    
        URIPrefix = _URIPrefix;
        URISuffix = _URISuffix;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        _requireOwned(_tokenId);
        return string.concat(URIPrefix, Strings.toString(_tokenId), URISuffix);
    }
}
