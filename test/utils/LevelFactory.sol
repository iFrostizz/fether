pragma solidity ^0.6.0;

import {FetherTestSuite} from "./FetherTestSuite.sol";

contract LevelFactory is FetherTestSuite {
  address deployer = address(100);
  address attacker = address(101);

  bool defaultVal = false;

  function submitLevel(string memory level) public {
    emit log_named_string("LevelFactory::Starting to test", level);
    _setupTest();
    _performTest();
    bool completed = _checkTest();
    if (completed) {
      emit log("LevelFactory::Completed test ✓");
      return;
    }
    emit log("LevelFactory::Failed test ✘");
    fail();
  }

  function _setupTest() internal virtual {
    vm.startPrank(attacker, attacker);
  }

  function _performTest() internal virtual {}

  function _checkTest() internal virtual returns (bool) {
    defaultVal = false;
    return defaultVal;
  }
}
