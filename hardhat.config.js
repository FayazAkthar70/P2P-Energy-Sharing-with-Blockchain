require("@nomicfoundation/hardhat-toolbox");
require("dot-env")

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.8",
  networks:{
    hardhat:{},
    goerli:{
      url:"https://eth-goerli.g.alchemy.com/v2/0x4UcBIxDUD5lqVdszv-8aqClcihjVpe",
      accounts: ["4db5abcf1679959cc7f22599eec168a6900f97dcf0d6a08cd399f96ee62175cc"],
      chainId: 5,
    },
  }
};
