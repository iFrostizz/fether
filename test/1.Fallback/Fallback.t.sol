// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "tests/Test.sol";
import "../../src/1.Fallback/Level.sol";
import "../../interface/IFallback.sol";

interface IFallback {
    function owner() external view returns(address);

    function contributions(address) external view returns(uint256);
}

contract FallbackTest is Test {
    address immutable deployer;
    address immutable attacker;
    IFallback immutable fallbhack;

    constructor(address _deployer, IFallback _fallbhack) {
        deployer = 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266;
        attacker = 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266;
        fallbhack = IFallback(0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0);
    }

    function setUp() public {

    }

    function testAttack() public {
        console.log(address(this).balance);
        assertEq(fallbhack.owner(), attacker);
        assertEq(contributions[attacker], 0);
    }
}
