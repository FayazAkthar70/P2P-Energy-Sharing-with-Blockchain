// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;



library RandomGenerator {
    function getRandomNumber(uint256 _upper) public view returns (uint256) {
        uint256 randomHash = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
        return randomHash % _upper;
    }
}