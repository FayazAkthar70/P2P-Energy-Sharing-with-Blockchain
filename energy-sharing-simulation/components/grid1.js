import { useState, useEffect } from "react";
import Image from "next/image";
import Grid from "./utils";

console.log(Grid);
export default function Grid1() {
  const [hydrated, setHydrated] = useState(false);
  const [energyToGrid, setEnergyToGrid] = useState(0);
  const [countUpdate, setCountUpdate] = useState(0);
  const [houseNodes, setHouseNodes] = useState(Grid);

  useEffect(() => {
    setHydrated(true);
    for (let y = 0; y < totalRows; y++) {
      for (let x = 0; x < totalColumns; x++) {
        houseNodes[y][x].state = calculateState(
          houseNodes[y][x].NetLoad,
          houseNodes[y][x].SoC,
          y,
          x
        );
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const SoCmax = 10; // State of charge of battery ranging from 0 - 10.
  const SoCmin = 2; // minimum allowable state of charge of battery.
  const SoCsufficient = 8;
  const totalRows = 4;
  const totalColumns = 4;

  function calculateState(NL, SoC, row, column) {
    // State 1 : Demand satisfied +
    // State 2 : Demand satisfied −
    // State 3 : Surplus power
    // State 4 : Power deficit
    // State 5 : Grid connexion
    if (NL >= 0 && SoC > SoCmin) {
      return 1;
    } else if ((NL <= 0 && SoC > SoCmin) || (NL > 0 && SoC <= SoCmin)) {
      return 2;
    } else if (NL >= 0 && SoC > SoCsufficient) {
      return 3;
    } else if (NL <= 0 && SoC <= SoCmin) {
      const [Xhouse, Yhouse] = checkSurplusPower(row, column);
      if (Xhouse === 999 && Yhouse === 999) {
        return 5;
      } else {
        return 4;
      }
    }
    return 6;
  }

  function checkSurplusPower(row, column) {
    if (row > 0 && houseNodes[row - 1][column].state === 3) {
      return [row - 1, column];
    }
    if (row < totalRows - 1 && houseNodes[row + 1][column].state === 3) {
      return [row + 1, column];
    }
    if (column > 0 && houseNodes[row][column - 1].state === 3) {
      return [row, column - 1];
    }
    if (column < totalColumns - 1 && houseNodes[row][column + 1].state === 3) {
      return [row, column + 1];
    }
    if (
      row - 1 > 0 &&
      column - 1 > 0 &&
      houseNodes[row - 1][column - 1].state === 3
    ) {
      return [row - 1, column - 1];
    }
    if (
      row > 0 &&
      column < totalColumns - 1 &&
      houseNodes[row - 1][column + 1].state === 3
    ) {
      return [row - 1, column + 1];
    }
    if (
      row < totalRows - 1 &&
      column > 0 &&
      houseNodes[row + 1][column - 1].state === 3
    ) {
      return [row + 1, column - 1];
    }
    if (
      row < totalRows - 1 &&
      column < totalColumns - 1 &&
      houseNodes[row + 1][column + 1].state === 3
    ) {
      return [row + 1, column + 1];
    }
    return [999, 999];
  }

  function sendEnergy(updatedHouseNodes, iFrom, jFrom, iTo, jTo) {
    console.log(
      `sending energy from house ${iFrom}, ${jFrom} at soc value ${updatedHouseNodes[iFrom][jFrom].SoC} to ${iTo}, ${jTo} at soc value ${updatedHouseNodes[iTo][jTo].SoC}`
    );
    updatedHouseNodes[iFrom][jFrom].SoC -= 2;
    updatedHouseNodes[iTo][jTo].SoC += 2;
  }

  function sellEnergyToGrid(updatedHouseNodes, i, j) {
    let newEnergyToGrid = updatedHouseNodes[i][j].SoC % 10;
    updatedHouseNodes[i][j].SoC -= newEnergyToGrid;
    return newEnergyToGrid;
  }

  function getEnergyGrid(updatedHouseNodes, i, j) {
    updatedHouseNodes[i][j].SoC += 4;
    return 4;
  }

  const updateBoard = () => {
    let newEnergyToGrid = 0;
    console.log("aslkfjasl;kfjxalskjflaksjflaksjflaksdflaskjf;alskdj");
    let updatedHouseNodes = houseNodes.map((row) =>
      row.map((houseNode) => {
        return { ...houseNode };
      })
    );

    for (let y = 0; y < totalRows; y++) {
      for (let x = 0; x < totalColumns; x++) {
        if (houseNodes[y][x].state == 4) {
          console.log(`housenode ${y},${x} is state 4`);
          let [ySurplus, xSurplus] = checkSurplusPower(y, x);
          if (ySurplus != 999) {
            sendEnergy(updatedHouseNodes, ySurplus, xSurplus, y, x);
          }
        } else if (houseNodes[y][x].state == 5) {
          newEnergyToGrid += getEnergyGrid(updatedHouseNodes, y, x);
        }

        if (houseNodes[y][x].SoC == SoCmax && houseNodes[y][x].NetLoad > 0) {
          console.log(updatedHouseNodes);
        }

        updatedHouseNodes[y][x].SoC += updatedHouseNodes[y][x].NetLoad;

        if (updatedHouseNodes[y][x].SoC > SoCmax) {
          newEnergyToGrid += sellEnergyToGrid(updatedHouseNodes, y, x);
        }
        if (updatedHouseNodes[y][x].SoC < 0) {
          newEnergyToGrid += getEnergyGrid(updatedHouseNodes, y, x);
        }
        updatedHouseNodes[y][x].state = calculateState(
          updatedHouseNodes[y][x].NetLoad,
          updatedHouseNodes[y][x].SoC,
          y,
          x
        );
      }
    }

    setEnergyToGrid((previousState) => previousState + newEnergyToGrid);
    setHouseNodes(updatedHouseNodes);
    setCountUpdate((previousState) => previousState + 1);
  };

  const rows = houseNodes.map((row, rowIndex) => {
    const cells = row.map((houseNode, cellIndex) => (
      <td key={`${rowIndex}-${cellIndex}`} className="text-center align-middle">
        <div className="d-flex flex-column align-items-center">
          <div className="mb-2">
            <Image
              src="/../public/home.png"
              alt="Home"
              height="100"
              width="100"
            />
          </div>
          <div>
            <p className="mb-0 text-center">{`NL: ${houseNode.NetLoad}, SoC: ${houseNode.SoC}`}</p>
            {(houseNode.state == 1 || houseNode.state == 2) && (
              <p className="mb-0 text-center fw-bold text-warning">
                State: {houseNode.state}
              </p>
            )}{" "}
            {houseNode.state == 3 && (
              <p className="mb-0 text-center fw-bold text-success">
                State: {houseNode.state}
              </p>
            )}{" "}
            {(houseNode.state == 4 || houseNode.state == 5) && (
              <p className="mb-0 text-center fw-bold text-danger">
                State: {houseNode.state}
              </p>
            )}
          </div>
        </div>
      </td>
    ));
    return <tr key={rowIndex}>{cells}</tr>;
  });

  return (
    <>
      <table className="table table-bordered ">
        {hydrated && <tbody>{rows}</tbody>}
      </table>
      <div className="m-3">
        <button className="btn btn-primary" onClick={updateBoard}>
          Update Board
        </button>
        <div>Total energy sold and bought from Grid: {energyToGrid}</div>
        <div>Number of updates : {countUpdate}</div>
      </div>
    </>
  );
}
