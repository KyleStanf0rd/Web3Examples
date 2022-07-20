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

const main = async () => {
  //Show account 1 balance before transaction
  const senderBalanceBef = await provider.getBalance(account1);
  //Show account2 balance before transaction
  const recBalancebef = await provider.getBalance(account2);

  console.log(
    `\nSender balance before : ${ethers.utils.formatEther(senderBalanceBef)}`
  );
  console.log(
    `reciever balance before : ${ethers.utils.formatEther(recBalancebef)}\n`
  );

  //Send ether
  const tx = await wallet.sendTransaction({
    to: account2,
    value: ethers.utils.parseEther("0.025"),
  });

  //Wait for transaction to be mined
  await tx.wait();
  console.log(tx);

  //Show account1 balance after transaction
  const senderBalanceAfter = await provider.getBalance(account1);
  //Show account2 balance after transaction
  const recBalanceAfter = await provider.getBalance(account2);

  console.log(
    `Sender Balance after : ${ethers.utils.formatEther(senderBalanceAfter)}`
  );
  console.log(
    `Reciever Balance after : ${ethers.utils.formatEther(recBalanceAfter)}`
  );
};

main();
