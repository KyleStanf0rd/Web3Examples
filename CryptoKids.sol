// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;

contract CryptoKids{

    //owner DAD
    address owner;


    //Can recieve this event on the front end !
    event LogKidFundingReceived(address addr, uint amount, uint contractBalance);

    constructor(){
        owner = msg.sender;
        //msg.sender is address of sender
    }

    //define kid
    struct Kid{
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    //array of type 'Kid'
    Kid[] public kids;


    //add modifers at the end of functions to modify the function so you don't have to 'reinvent the wheel' 
    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner has this permission!");
        //this specifies to allow the rest of the function to execute.
        _;    
    }

    //add kid to contract
    function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner{
        kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    //view saves gas as it does not interact with the blockchain at all
    function balanceOf() public view returns(uint){
        return address(this).balance;
    }
    
    //deposit funds to contract, specifically to kids account
    function deposit(address walletAddress) payable public {
        addToKidsBalance(walletAddress);
    }

    //be careful with using loops in contracts, can really use up gas!
    function addToKidsBalance(address walletAddress) private{
        for(uint i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                //msg.value is the amount of money we are sending to the contract
                kids[i].amount += msg.value;
                emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
            }
        }
    }

    //view saves gas as it does not interact with the blockchain at all
    function getIndex(address walletAddress) view private returns(uint){
        for(uint i = 0; i < kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
        }
        //just a quick fix
        return 999;
    }

    //kid check if able to withdraw
    function availableToWithdraw(address walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        require(block.timestamp > kids[i].releaseTime, "You cannot withdraw yet!");
        //miner could possibly manipulate this
        if(block.timestamp > kids[i].releaseTime){
            kids[i].canWithdraw = true;
            return true;
        }else{
            return false;
        }
    }

    //withdraw money
    function withdraw(address walletAddress) payable public {
        uint i = getIndex(walletAddress);
        //checks
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw!");
        require(kids[i].canWithdraw == true, "You are not able to withdraw at this time!");
        kids[i].walletAddress.transfer(kids[i].amount);
    }

}
