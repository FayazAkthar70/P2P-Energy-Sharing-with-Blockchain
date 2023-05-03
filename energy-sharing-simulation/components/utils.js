class HouseNode {
  constructor(NetLoad, SoC) {
    this.NetLoad = NetLoad; // net energy load of the house node
    this.SoC = SoC;
    this.state = 0;
    this.isConnected = true; // boolean value indicating if the house node is connected to the energy grid
  }
}

function CreateGrid(totalColumns, totalRows) {
  const nodes = [];
  for (let y = 0; y < totalRows; y++) {
    const row = [];
    for (let x = 0; x < totalColumns; x++) {
      let soc = Math.floor(Math.random() * 10);
      let netload = Math.floor(Math.random() * 5 - 2);

      const node = new HouseNode(netload, soc, 0);
      row.push(node);
    }
    nodes.push(row);
  }

  return nodes;
}

let Grid = CreateGrid(4, 4);

export default Grid;
