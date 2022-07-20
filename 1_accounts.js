const { ethers } = require("ethers");
require("dotenv").config();

const INFURA_ID = process.env.INFURAID;
const provider = new ethers.providers.JsonRpcProvider(
  `https://mainnet.infura.io/v3/${INFURA_ID}`
);

const address = "0xEF84E5C029aF74d7D0DD4778d5acd14D83BC3dA9";

const main = async () => {
  const balance = await provider.getBalance(address);
  console.log(
    `\nETH Balance of ${address} --> ${ethers.utils.formatEther(
      balance
    )} ETH \n`
  );
};

main();
