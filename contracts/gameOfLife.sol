// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GameOfLife {
    // Define the size of the game board
    uint256 public rows = 16;
    uint256 public columns = 16;

    // Define the state of each cell on the game board
    mapping (uint256 => mapping (uint256 => bool)) public board;
    mapping (uint256 => mapping (uint256 => address)) public houseAddressBoard;

    // Define a variable to store the next state of each cell on the game board
    mapping (uint256 => mapping (uint256 => bool)) private nextBoard;

    function resetBoard() public {
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                board[i][j] = false;
            }
        }
    }

    function toggleCell(uint256 row, uint256 column) public {
    board[row][column] = !board[row][column];
    }

    // Function to calculate the number of alive neighbors for a given cell
    function countAliveNeighbors(uint256 row, uint256 column) private view returns (uint256) {
        uint256 count = 0;

        if (row > 0 && board[row - 1][column]) count++;
        if (row < rows - 1 && board[row + 1][column]) count++;
        if (column > 0 && board[row][column - 1]) count++;
        if (column < columns - 1 && board[row][column + 1]) count++;
        if (row > 0 && column > 0 && board[row - 1][column - 1]) count++;
        if (row > 0 && column < columns - 1 && board[row - 1][column + 1]) count++;
        if (row < rows - 1 && column > 0 && board[row + 1][column - 1]) count++;
        if (row < rows - 1 && column < columns - 1 && board[row + 1][column + 1]) count++;

        return count;
    }

    // Function to update the state of each cell on the game board
    function updateBoard() public {
        // Iterate over all cells on the game board
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                uint256 count = countAliveNeighbors(i, j);

                // Apply the rules of the Game of Life
                // Rules of Game of Life are:
                // Any live cell with fewer than two live neighbours dies (referred to as underpopulation).
                // Any live cell with more than three live neighbours dies (referred to as overpopulation).
                // Any live cell with two or three live neighbours lives, unchanged, to the next generation.
                // Any dead cell with exactly three live neighbours comes to life.
                if (board[i][j]) {
                    if (count < 2 || count > 3) {
                        nextBoard[i][j] = false;
                    } else {
                        nextBoard[i][j] = true;
                    }
                } else {
                    if (count == 3) {
                        nextBoard[i][j] = true;
                    } else {
                        nextBoard[i][j] = false;
                    }
                }
            }
        }

        // Update the state of the game board
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                board[i][j] = nextBoard[i][j];
            }
        }
        
    }
}