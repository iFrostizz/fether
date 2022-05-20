// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface ITelephone2 {
    function changeOwner(address) external; 
}

contract TelProxy {
    function makeACall(address telephone, address owner) external {
        ITelephone2(telephone).changeOwner(owner);
    }
}
