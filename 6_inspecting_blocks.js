const { ethers } = require("ethers");
require("dotenv").config();

const INFURA_ID = process.env.INFURAID;
const provider = new ethers.providers.JsonRpcProvider(
  `https://mainnet.infura.io/v3/${INFURA_ID}`
);

const main = async () => {
  const block = await provider.getBlockNumber();

  console.log(`\nBlock Number: ${block}\n`);

  const blockinfo = await provider.getBlock(block);
  console.log(blockinfo);

  //get specific information from the block you want (transaction for this case)
  const { transactions } = await provider.getBlockWithTransactions(block);
  console.log(transactions[0]);
};

main();

//RUN node ./examples/------
