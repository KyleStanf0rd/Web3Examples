// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;

//Inheritance

contract ERC20Token{
    string public name;
    mapping(address => uint256) public balances;

    constructor(string memory _name) public {
        name = _name;
    }

    //function in the parent contract needs to be declared with the keyword virtual 
    // to indicate that it can be overridden in the deriving contract.
    function mint() public virtual {
        balances[tx.origin]++;
    }

}

//inheriting from first contract
contract MyToken is ERC20Token{
    string public symbol;
    address[] public owners;
    uint256 ownerCount;

    //Over-riding constructor
    constructor(string memory _name, string memory _symbol) ERC20Token(_name){
        symbol = _symbol;
    }

    //when you override a function, you must declare it as being over-'rided'
    function mint() public override{
        super.mint();
        ownerCount++;
        owners.push(msg.sender);
    }
}
