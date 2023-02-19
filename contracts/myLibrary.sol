// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library myLibrary {

    //generates random number between 0 and 10
    function getRandomNumber(uint256 seed) internal view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed))) % 11; 
    }




    

}
