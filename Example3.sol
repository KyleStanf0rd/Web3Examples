// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;

contract Example2{
    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;
    address owner;
    uint256 openingTime = 1658361617;
    uint256 closingTime = 1658707217;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier onlyWhileOpen(){
        require(block.timestamp >= openingTime && block.timestamp <= closingTime);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    struct Person{
        uint _id;
        string _firstName;
        string _lastName;
    }

    //add person method with onlyOwner modifier
    function addPerson(string memory _firstName, string memory _lastName) public onlyOwner onlyWhileOpen{
        incrementCount();
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
    }

    function incrementCount() internal {
        peopleCount += 1;
    }

}
