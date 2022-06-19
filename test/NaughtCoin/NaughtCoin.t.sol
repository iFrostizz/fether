// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {NaughtCoin} from "../../src/NaughtCoin/NaughtCoin.sol";

contract NaughtCoinTest is LevelFactory {
  NaughtCoin nc;

  function setUp() public {
    vm.startPrank(deployer);
    nc = new NaughtCoin(attacker);
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("NaughtCoin");
  }

  function _performTest() internal override {
    address malicious = address(102);
    assert(nc.approve(malicious, uint(-1)));
    vm.stopPrank();
    vm.startPrank(malicious);
    assert(nc.allowance(attacker, malicious) > 0);
    assert(nc.transferFrom(attacker, malicious, nc.balanceOf(attacker)));
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    assertNull(nc.balanceOf(attacker));
    return nc.balanceOf(attacker) == 0;
  }
}
