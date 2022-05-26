// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract FetherTestSuite is Test {
  function assertNull(uint a) public {
    assertEq(a, 0);
  }
}
