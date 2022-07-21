// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;

contract MyContract{
    enum State {Waiting, Ready, Active}
    State public state;

    constructor() {
        state = State.Waiting;

    }

    function activate() public {
        state = State.Active;
    }

    function isActive() public view returns(bool){
        return state == State.Active;
    }

}


