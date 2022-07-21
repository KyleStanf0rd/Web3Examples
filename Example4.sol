// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;

//2 contracts talking to each other

contract ERC20Token{
    string public name;
    mapping(address => uint256) public balances;

    function mint() public {
        //The tx. origin global variable refers to the original external 
        //account that started the transaction while msg. 
        //sender refers to the immediate account
        balances[tx.origin]++;
    }

}

contract MyContract{
    address payable wallet;
    address public token;

    // event Purchase(
    //     //indexed allows you to filter events from certain buyers
    //     address indexed _buyer,
    //     uint256 _amount
    // );

    constructor(address payable _wallet, address _token) {
        wallet = _wallet;
        token = _token;
    }

    fallback() external payable{
        buyToken();
    }


    function buyToken() public payable{
        //instantiate contract
        // ERC20Token _token = ERC20Token(address(token));
        // _token.mint();
        //COULD DO THIS EITHER WAY, THIS IS SHORTHAND
        ERC20Token(address(token)).mint();
        wallet.transfer(msg.value);
    }
}
