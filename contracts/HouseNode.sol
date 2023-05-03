// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myLibrary.sol";

contract houseNode {

    uint public amount;
    address public Govtaddress;
    uint _seed;
    // Defines a struct for house in grid
    struct Node{
    bool is_connected;
    int NL;             //Net Load ranging from -2 to 2
    int Soc;            //State of Charge (battery) ranging from 0 to 10
    uint256 nodeState;
    }
    Node public myNode;
    address public contractowner;
    constructor()
    {
        contractowner = msg.sender;
        amount = 1;
        _seed =1;
    //Node public myNode;
    int randomNL = (int(RandomGenerator.getRandomNumber(_seed)) % 5) - 2;
    int randomSoc = int(RandomGenerator.getRandomNumber(_seed)%10);
        //uint256 state = calculateState(randomNL, randomSoc, i, j);
    myNode= Node({
                    is_connected: true,
                    NL: randomNL,
                    Soc: randomSoc,
                    nodeState: 0
                });
    }

    function showowner () public view returns(address) {
        return contractowner;
    }

    function sendMoneytoContract () public payable {}

    function getbalance() public view returns(uint){
        return address(this).balance;
    }
            
    function Socincrement(int val) public{
        myNode.Soc+=val;
    }
    function Socdecrement(int val) public{
        myNode.Soc-=val;
    }
    function returnstate() public view returns (uint256) {
        return myNode.nodeState;
    }
    function setstate(uint256 state) public {
        myNode.nodeState = state;
    }
    function getNL() public view returns (int) {
        return myNode.NL;
    }
    function getSoc() public view returns (int) {
        return myNode.Soc;
    }
    function connection() public view returns (bool) {
        return myNode.is_connected;
    }
    function Socset(int val) public {
        myNode.Soc = val;
    }
    
    



    // dummy function to send energy from one house to another
    function sendEnergy(address A) public{
        //houseNode houseA = houseNode(A);
        //houseNode houseB = houseNode(B);
        require(amount <= address(this).balance, "House has insufficient balance");
        payable(A).transfer(amount);
        //houseA.myNode.Soc -= 2;
        myNode.Soc += 2;
    }

    // dummy function to get energy from the grid
    function getEnergyGrid() public{
        //houseNode houseA = houseNode(A);
        require(amount <= address(this).balance, "House has insufficient balance");
        payable(Govtaddress).transfer(amount);
        //houseA.Node.Soc += 4;
    }

    // dummy function to sell energy back to grid
    function sellEnergyToGrid() public{
        //require(amount <= address(this).balance, "House has insufficient balance");
        //Node.Soc -= 2;
    }

    //keeping max renewable energy generated to 5
    // function RenewableEnergy(uint256 i, uint256 j) public{

    //     nextBoard[i][j].Soc += (int(myLibrary.getRandomNumber(i+j)) % 6);
    //     if(nextBoard[i][j].Soc > 10)
    //     {
    //         nextBoard[i][j].Soc = 10;
    //     }
    // }
    // //keeping max energy consumed to 5
    // function EnergyConsumed(uint256 i, uint256 j) public{
    //     nextBoard[i][j].Soc -= (int(myLibrary.getRandomNumber(i+j)) % 6);
    //     if(nextBoard[i][j].Soc < 0)
    //     {
    //         nextBoard[i][j].Soc = 0;
    //     }
    // }
}
