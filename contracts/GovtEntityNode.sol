// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./myLibrary.sol";

interface houseNode {
    function showowner() external view returns (address);

    function sendMoneytoContract() external payable;

    function getbalance() external view returns (uint);

    function Socincrement(int val) external;

    function Socdecrement(int val) external;

    function returnstate() external view returns (uint256);

    function setstate(uint256 state) external;

    function getNL() external view returns (int);

    function getSoc() external view returns (int);

    function connection() external view returns (bool);

    function Socset(int val) external;

    function fund() external payable;

    function sendEnergy(address A) external;

    function getEnergyGrid() external;

    function sellEnergyToGrid() external;
}

contract governmentEntityNode {
    //houseNode public house;
    address public contractOwner;

    constructor() {
        contractOwner = payable(msg.sender);
    }

    function sendMoneytoContract() public payable {}

    function getbalance() public view returns (uint) {
        return address(this).balance;
    }

    uint256 public constant len = 2;

    uint256 public rows = 1;
    uint256 public columns = len;

    uint public amount;

    struct Node {
        bool is_connected;
        int NL; //Net Load ranging from -2 to 2
        int Soc; //State of Charge (battery) ranging from 0 to 10
        uint256 nodeState;
    }

    // Define the state of each cell on the game board
    //mapping (address => mapping (address => houseNode)) public board;
    address payable[][] public board;

    function setMatrixValues() public {
        board = [
            [
                payable(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC),
                payable(0x70997970C51812dc3A010C7d01b50e0d17dc79C8)
            ]
        ];
    }

    // Define a variable to store the next state of each cell on the game board
    mapping(uint256 => mapping(uint256 => Node)) public nextBoard;

    //function to set next board

    // alpha and beta are constants from the basepaper. alpha being the reasonable percentage of battery to be called demand satisfied and beta the lower
    // threshold below which grid connexion is needed.(range 0 - 10)
    // uint256 private alpha = 8;
    // uint256 private beta = 2;
    int private Socmax = 10; // State of charge of battery ranging from 0 - 10.
    int private Socmin = 2; // minimum allowable state of charge of battery.

    function checkSurplusPower(
        uint256 row,
        uint256 column
    ) public view returns (uint256, uint256) {
        if (row > 0) //1
        {
            //houseNode memory n1 = houseNode(board[row-1][column]);
            houseNode n1 = houseNode(board[row - 1][column]);
            if (n1.returnstate() == 3) return (row - 1, column);
        }
        if (row < rows - 1) //2
        {
            houseNode n2 = houseNode(board[row + 1][column]);
            if (n2.returnstate() == 3) return (row + 1, column);
        }
        if (column > 0) //3
        {
            houseNode n3 = houseNode(board[row][column - 1]);
            if (n3.returnstate() == 3) return (row, column - 1);
        }
        if (column < columns - 1) //4
        {
            houseNode n4 = houseNode(board[row][column + 1]);
            if (n4.returnstate() == 3) return (row, column + 1);
        }
        if (column > 0) //5
        {
            houseNode n5 = houseNode(board[row - 1][column - 1]);
            if (n5.returnstate() == 3) return (row - 1, column - 1);
        }
        if (column > 0) //6
        {
            houseNode n6 = houseNode(board[row - 1][column + 1]);
            if (n6.returnstate() == 3) return (row - 1, column + 1);
        }
        if (column > 0) //7
        {
            houseNode n7 = houseNode(board[row + 1][column - 1]);
            if (n7.returnstate() == 3) return (row + 1, column - 1);
        }
        if (column > 0) //8
        {
            houseNode n8 = houseNode(board[row + 1][column + 1]);
            if (n8.returnstate() == 3) return (row + 1, column + 1);
        }
        return (999, 999);
    }

    // function contracttocontract (address a, address b) public{

    //     houseNode A = houseNode(a);

    // }

    function calculateState(
        int NL,
        int SoC,
        uint256 row,
        uint256 column
    ) private view returns (uint256) {
        // State 1 : Demand satisfied +
        // State 2 : Demand satisfied −
        // State 3 : Surplus power
        // State 4 : Power deficit
        // State 5 : Grid connexion
        if (NL >= 0 && SoC > Socmin && SoC < Socmax) {
            return 1;
        } else if (NL <= 0 && SoC > Socmin && SoC < Socmax) {
            return 2;
        } else if (NL >= 0 && SoC == Socmax) {
            return 3;
        } else if (NL <= 0 && SoC <= Socmin) {
            (uint256 Xhouse, uint256 Yhouse) = checkSurplusPower(row, column);
            if ((Xhouse == uint256(999) && Yhouse == uint256(999))) {
                return 5;
            } else {
                return 4;
            }
        }
        return 6;
    }

    // function setState() public{
    //     for(uint256 i = 0; i < rows; i++)
    //     {
    //         for(uint256 j = 0; j < columns; j++)
    //         {
    //             houseNode h = houseNode(board[i][j]);
    //             h.setstate(1);
    //             //h.setstate(calculateState(h.getNL(), h.getSoc(), i, j));

    //         }
    //     }
    // }

    // Function to update Grid
    function updateBoard() public {
        // Iterate over all nodes
        for (uint256 i = 0; i < rows; i++) {
            for (uint256 j = 0; j < columns; j++) {
                houseNode house = houseNode(board[i][j]);
                if (house.connection()) {
                    uint256 state = house.returnstate();

                    if (state == 4) {
                        (
                            uint256 iSurplus,
                            uint256 jSurplus
                        ) = checkSurplusPower(i, j);
                        house.sendEnergy(board[iSurplus][jSurplus]);
                        houseNode A = houseNode(board[iSurplus][jSurplus]);
                        A.Socdecrement(2);
                        houseNode B = houseNode(board[i][j]);
                        B.Socincrement(2);
                    } else if (state == 5) {
                        house.getEnergyGrid();
                        house.Socincrement(4);
                    }

                    if (house.getSoc() == 10 && house.getNL() > 0) {
                        house.sellEnergyToGrid();
                        payable(board[i][j]).transfer(amount);
                        house.Socdecrement(2);
                    }

                    house.Socincrement(house.getNL());
                    if (house.getSoc() > 10) {
                        house.Socset(10);
                    }
                    house.setstate(
                        calculateState(house.getNL(), house.getSoc(), i, j)
                    );
                }
            }
        }
    }
}
