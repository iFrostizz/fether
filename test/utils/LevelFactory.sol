pragma solidity ^0.6.0;

import "./FetherTestSuite.sol";

contract LevelFactory is FetherTestSuite {
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
  }

  function _setupTest() internal virtual {}

  function _performTest() internal virtual {}

  function _checkTest() internal virtual returns (bool) {
    return false;
  }
}
