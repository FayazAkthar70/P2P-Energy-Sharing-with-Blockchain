// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myLibrary.sol";


contract energySharingSimulation {

    // Defines a struct for house in grid
    struct Node{
    bool is_connected; // see if house connected to grid 
    int NL; //Net Load ranging from -2 to 2
    int SoC; //State of Charge (battery) ranging from 0 to 10
    uint256 nodeState;
    }

    // Define the size of the game board
    uint256 public rows = 3;
    uint256 public columns = 3;

    // Define the state of each cell on the game board
    mapping (uint256 => mapping (uint256 => Node)) public board;
    // Define a variable to store the next state of each cell on the game board
    mapping (uint256 => mapping (uint256 => Node)) public nextBoard;

    // variable needed to calculate random number
    uint256 private seed;

    constructor() {
        resetBoard();
    }

    Node private myNode;
    function resetBoard() public {
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                seed = i + j;
                int randomNL = (int(myLibrary.getRandomNumber(seed)) % 5) - 2;
                int randomSoC = int(myLibrary.getRandomNumber(seed));
                uint256 state = calculateState(randomNL, randomSoC, i, j);
                myNode = Node({
                    is_connected: true,
                    NL: randomNL,
                    SoC: randomSoC,
                    nodeState: state
                });
                board[i][j] = myNode;
                nextBoard[i][j] = myNode;
            }
        }
    }

    function setState(uint256 row, uint256 column, Node memory newNode) public {
        board[row][column] = newNode;
    }



    function checkSurplusPower(uint256 row, uint256 column) private view returns ( uint256, uint256)
    {
            if (row > 0 && board[row - 1][column].nodeState==3)
                return (row-1,column);
            if (row < rows - 1 && board[row + 1][column].nodeState==3)
                return (row+1,column);
            if (column > 0 && board[row][column - 1].nodeState==3)
                return (row,column-1);
            if (column < columns - 1 && board[row][column + 1].nodeState==3)
                return (row,column+1);
            if (row > 0 && column > 0 && board[row - 1][column - 1].nodeState==3)
                return (row-1,column-1);
            if (row > 0 && column < columns - 1 && board[row - 1][column + 1].nodeState==3)
                return (row-1,column-1);
            if (row < rows - 1 && column > 0 && board[row + 1][column - 1].nodeState==3)
                return (row+1,column-1);
            if (row < rows - 1 && column < columns - 1 && board[row + 1][column + 1].nodeState==3)
                return (row+1,column+1);
            return (999,999);
    }

    // alpha and beta are constants from the basepaper. alpha being the reasonable percentage of battery to be called demand satisfied and beta the lower
    // threshold below which grid connexion is needed.(range 0 - 10)
    // uint256 private alpha = 8;
    // uint256 private beta = 2;
    int private SoCmax = 10;  // State of charge of battery ranging from 0 - 10.
    int private SoCmin = 4;  // minimum allowable state of charge of battery.


    function calculateState(int NL, int SoC, uint256 row, uint256 column) private view returns(uint256){
        // State 1 : Demand satisfied + 
        // State 2 : Demand satisfied − 
        // State 3 : Surplus power
        // State 4 : Power deficit
        // State 5 : Grid connexion
        if (NL>0 && SoC>SoCmin && SoC<SoCmax) {
            return 1;
        }
        else if (NL<0 && SoC>SoCmin && SoC<SoCmax) {
            return 2;
        }
        else if (NL>0 && SoC==SoCmax) {
            return 3;
        }
        else if (NL<0 && SoC<=SoCmin) {
            (uint256 Xhouse, uint256 Yhouse) = checkSurplusPower(row, column); 
            if((Xhouse == uint256(999) &&  Yhouse == uint256(999)))
            {
                return 5;
            }
            else
            {
                return 4;
            }
        }
        return 6;
    }

    // dummy function to send energy from one house to another
    function sendEnergy(uint256 iFrom, uint256 jFrom, uint256 iTo, uint256 jTo) public{
        nextBoard[iFrom][jFrom].SoC -= 2;
        nextBoard[iTo][jTo].SoC += 2;
    }

    // dummy function to get energy from the grid
    function getEnergyGrid(uint256 i, uint256 j) public{
        nextBoard[i][j].SoC += 10;
    }

    // Function to update Grid
    function updateBoard() public {

        // Iterate over all nodes
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                if (board[i][j].is_connected) {
                    uint256 state = board[i][j].nodeState;

                    if (state == 4){
                        (uint256 iSurplus, uint256 jSurplus) = checkSurplusPower(i,j);
                        sendEnergy(iSurplus, jSurplus, i, j);
                    }
                    else if (state == 5){
                        getEnergyGrid(i, j);
                    }
                    nextBoard[i][j].SoC += nextBoard[i][j].NL;
                    nextBoard[i][j].nodeState = calculateState(nextBoard[i][j].NL, nextBoard[i][j].SoC, i, j);
                }
            }
        }

        // Update the state of the houses
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                board[i][j] = nextBoard[i][j];
            }
        }
    }
}








