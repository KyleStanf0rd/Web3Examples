const { ethers } = require("ethers");
require("dotenv").config();

const INFURA_ID = process.env.INFURAID;
const provider = new ethers.providers.JsonRpcProvider(
  `https://kovan.infura.io/v3/${INFURA_ID}`
);

const account1 = process.env.BURNACCOUNT; //sender
const account2 = "0x8cf49686fabd9dad7a423234bc1d4b873a699f09"; //recipient

const privkey1 = process.env.PRIVATEKEY; //Sender private key
const wallet = new ethers.Wallet(privkey1, provider);

const ERC20_ABI = [
  "function balanceOf(address) view returns (uint)",
  "function transfer(address to, uint amount) returns (bool)",
];

const address = "0xa36085F69e2889c224210F603D836748e7dC0088";
const contract = new ethers.Contract(address, ERC20_ABI, provider);

const main = async () => {
  const balance = await contract.balanceOf(account1);

  console.log(`\nReading from ${address}\n`);
  console.log(`Balance of sender: ${balance}\n`);

  const contractWithWallet = contract.connect(wallet);

  const tx = await contractWithWallet.transfer(account2, balance);
  await tx.wait();

  console.log(tx);

  const balanceofSender = await contract.balanceOf(account1);
  const balanceofRec = await contract.balanceOf(account2);

  console.log(`\nBalance of sender: ${balanceofSender}`);
  console.log(`Balance of reciever: ${balanceofRec}\n`);
};

main();
