// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameOfLife {

    // Defines a struct for house in grid
    struct Node{
    bool is_connected; // see if house connected to grid 
    int NL; //Net Load
    uint256 SoC; //State of Charge (battery)
    uint256 nodeState;
    }

    // State of charge of battery ranging from 0 - 1. 
    uint256 public SoCmax = 5;
    uint256 public SoCmin = 1;

    // Define the size of the game board
    uint256 public rows = 3;
    uint256 public columns = 3;

    // Define the state of each cell on the game board
    mapping (uint256 => mapping (uint256 => Node)) public board;

    // Define a variable to store the next state of each cell on the game board
    mapping (uint256 => mapping (uint256 => Node)) private nextBoard;

    // function resetBoard() public {
    //     for (uint256 i = 0; i < rows; i++) {
    //         for (uint256 j = 0; j < columns; j++) {
    //             board[i][j] = false;
    //         }
    //     }
    // }

    function setState(uint256 row, uint256 column, uint256 state) public {
        board[row][column].nodeState = state;
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

    // Function to update states

        function updateBoard() public {
            // Iterate over all nodes
            for (uint256 i = 0; i < rows; i++) {
                for (uint256 j = 0; j < columns; j++) {
                    // Apply the rules

                    // State 1 : Demand satisfied + 
                    // State 2 : Demand satisfied − 
                    // State 3 : Surplus power
                    // State 4 : Power deficit
                    // State 5 : Grid connexion

                    if (board[i][j].is_connected) {
                        if (board[i][j].NL>0 && board[i][j].SoC>SoCmin && board[i][j].SoC<SoCmax) {
                            nextBoard[i][j].nodeState = 1;
                        }
                        else if (board[i][j].NL<0 && board[i][j].SoC>SoCmin && board[i][j].SoC<SoCmax) {
                            nextBoard[i][j].nodeState = 2;
                        }
                        else if (board[i][j].NL>0 && board[i][j].SoC==SoCmax) {
                            nextBoard[i][j].nodeState = 3;
                        }
                        else if (board[i][j].NL<0 && board[i][j].SoC==SoCmin) {

                            (uint256 Xhouse, uint256 Yhouse) = checkSurplusPower(i,j); 
                            if((Xhouse == uint256(999) &&  Yhouse == uint256(999)))
                            {
                                nextBoard[i][j].nodeState = 4;
                            }
                            else
                            {
                                nextBoard[i][j].nodeState = 5;
                            }
                        }
                    
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








