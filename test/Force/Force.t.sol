// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Force/Level.sol";
import "../utils/ForceProxy.sol";
import "forge-std/console.sol";

interface IForceProxy {
    function bruteForce(address payable _contract) external;
}

contract ForceTest is Test {
    address force;
    IForceProxy forceProxy;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        force = address(new Force());
        forceProxy = IForceProxy(address(new ForceProxy()));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        payable(address(forceProxy)).transfer(1 ether);
        forceProxy.bruteForce(payable(force));
        /* Write your code here */ 

        /* Validating the test */
        assertGt(payable(force).balance, 0);
    }
}

