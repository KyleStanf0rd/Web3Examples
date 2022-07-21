// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;

contract coin{

    address public minter;

    //mapping the balances to unsigned integers so we can access it like an array
    //id -> record sorta
    mapping (address => uint) private balances;

    event sent(address from, address to, uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mint (address owner, uint amount) public {
        require(msg.sender==minter);
        balances [owner] += amount;
    }

    function send (address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient Funds");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit sent(msg.sender, receiver, amount);
    }

    function balanceOf(address tokenOwner) public view returns (uint balance){
        return balances [tokenOwner];
    }

}
