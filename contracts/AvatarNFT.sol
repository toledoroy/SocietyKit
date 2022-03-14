// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";		//https://eips.ethereum.org/EIPS/eip-721
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";  //Individual Metadata URI Storage Functions
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//Interfaces
import "./interfaces/IConfig.sol";
//Libraries
import "./libraries/DataTypes.sol";

/**
 * Avatar as NFT
 * Version 0.0.1
 *  - [TODO] Contract is open for everyone to mint.
 *  - [TODO] Max of one NFT assigned for each account
 *  - [TODO] Can create un-assigned NFT (Kept on contract)
 *  - [TODO] Minted Tokens are updatable by Token holder
 *  - [TODO] Assets are non-transferable by owner
 *  - [TODO] Contract is Updatable
 */
contract AvatarNFT is ERC721URIStorage, Ownable {

    //--- Storage
    address internal _CONFIG;    //Configuration Contract
    address internal _HUB;    //Hub Contract
    

    //TODO: Rating: professional , personal and community + role + pos/neg
    // uint256 internal _rep;       //Reputation Tracking
    mapping(uint256 => mapping(DataTypes.Domain => mapping(DataTypes.Rating => uint256))) internal _rep;     //Reputation Trackin Per Domain
    //[Token][Domain][bool] => Rep

    // DataTypes.Domain public domain;

    /// @dev Fetch Avatar's Reputation 
    function getRepForDomain(uint256 tokenId, DataTypes.Domain domain, DataTypes.Rating rating) public view returns (uint256){
        return _rep[tokenId][domain][rating];
    }
    

    /// Constructor
    constructor(address config) ERC721("Avatar", "AVATAR") {
        //Set Protocol's Config Address
        _setConfig(config);
    }

    /// Get Configurations Contract Address
    function getConfig() public view returns (address) {
        return _CONFIG;
    }

    /// Expose Configurations Set to Current Owner
    function setConfig(address config) public onlyOwner {
        _setConfig(config);
    }

    /// Set Configurations Contract Address
    function _setConfig(address config) internal {
        //Validate Contract's Designation
        require(keccak256(abi.encodePacked(IConfig(config).role())) == keccak256(abi.encodePacked("YJConfig")), "Invalid Config Contract");
        //Set
        _CONFIG = config;
    }

    /// Inherit owner from Protocol's config
    function owner() public view override returns (address) {
        return IConfig(getConfig()).owner();
    }

    /// Mint (Create New Avatar for oneself)

    /// Add (Create New Avatar Without an Owner)

    /// Merge 

    /// Token Transfer Rules
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
        require(
            _msgSender() == owner()
            || from == address(0)   //Minting
            // || to == address(0)     //Burning
            ,
            "Sorry, Assets are non-transferable"
        );
    }

}
