// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC1155GUID {

    //--- Functions 
    
    /// Check if account is assigned to role
    function GUIDHas(address account, bytes32 guid) external view returns (bool);
    
    //--- Events

    /// New GUID Created
    event GUIDCreated(uint256 indexed id, bytes32 guid);
   
}
