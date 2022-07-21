// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;
//import library
import "./Math.sol";
import "./SafeMath.sol";

//so we don't "DRY" or repeat ourselves
contract Example6{
    //Shorthand for importing library
    using SafeMath for uint256;
    uint256 public value;
    
    function calculate (uint _value1, uint _value2) public{
        // value = Math.divide(_value1, _value2);
        value = _value1.div(_value2);

    }
}
