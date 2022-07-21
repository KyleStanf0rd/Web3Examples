// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;
//Libraries
//CHECK OUT OPENZEPPELIN OPEN-SOURCE MATH LIBRARY

library Math{
    //a function that doesn't read or modify the variables of the state is called a pure function. 
    function divide(uint256 a, uint256 b) internal pure returns(uint256){
        require(b > 0);
        uint256 c = a/b;
        return c;
    }
}
