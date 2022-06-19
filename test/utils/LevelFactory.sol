pragma solidity ^0.6.0;

import {FetherTestSuite} from "./FetherTestSuite.sol";

contract LevelFactory is FetherTestSuite {
  address deployer = address(100);
  address attacker = address(101);

  bool defaultVal = false;

  function submitLevel(string memory level) public {
    vm.stopPrank();
    emit log_named_string("LevelFactory::Starting to test", level);

    vm.startPrank(deployer, deployer);
    _setupTest();
    vm.stopPrank();

    vm.startPrank(attacker, attacker);
    _performTest();

    bool completed = _checkTest();
    vm.stopPrank();
    if (completed) {
      emit log("LevelFactory::Completed test ✓");
      return;
    }
    emit log("LevelFactory::Failed test ✘");
    fail();
  }

  function _setupTest() internal virtual {}

  function _performTest() internal virtual {}

  function _checkTest() internal virtual returns (bool) {
    defaultVal = false;
    return defaultVal;
  }
}
