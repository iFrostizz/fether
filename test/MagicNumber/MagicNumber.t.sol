// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {LevelFactory} from "../utils/LevelFactory.sol";
import {MagicNum} from "../../src/MagicNumber/MagicNumber.sol";

interface IMagicNumber {
  function solver() external view returns (address);
}

interface ITiny {
  function whatIsTheMeaningOfLife() external view returns (uint);
}

contract MagicNumTest is LevelFactory {
  MagicNum magicNum;

  function setUp() public {
    vm.startPrank(deployer, deployer);
    magicNum = new MagicNum();
    vm.stopPrank();
  }

  function testAttack() public {
    submitLevel("MagicNumTest");
    vm.deal(attacker, 1 ether);
  }

  function _performTest() internal override {
    // 1. copy runtime opcodes into memory using calldatacopy(t, f, s)
    // copy s bytes from calldata at position f to mem at position t
    // 2. return the runtime memory

    // 1. s = 10 bytes, f = end bytes t = 0
    // 
    // PUSH1 0x0a PUSH1 0x?? PUSH1 0x00 CODECOPY
    // 0x60 0x0a 0x60 0x?? 0x60 0x00 0x39
    //
    // 2. get s and return it
    //
    // PUSH1 0x0a PUSH1 0x00 RETURN 
    // 0x60 0x0a 0x60 0x00 0xf3
    //
    // Now, let's count the bytes to determine f
    // f = 12 = 0x0c 
    //
    // Wrapping up:
    // 600a 600c 6000 39 600a 6000 f3
    //
    // Now, we must store and return 42

    // 42 (base 10) = 2a (base 16)
    // PUSH1 0x2a PUSH1 0x80 MSTORE PUSH1 0x20 PUSH1 0x80 RETURN
    // 0x60 0x2a 0x60 0x80 0x52 0x60 0x20 0x60 0x80 0xf3
    //
    // 602a 6080 5260 2060 80f3

    bytes memory bytecode = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
    address tinyMachine = _deployBytecode(bytecode);
    (bool success, ) = address(magicNum).call(abi.encodeWithSignature("setSolver(address)", address(tinyMachine)));
    assert(success);
  }

  function _deployBytecode(bytes memory bytecode) public returns (address) {
    address retval;
    assembly{
      retval := create(0, add(bytecode, 0x20), mload(bytecode))
      if iszero(extcodesize(retval)) {
        revert(0, 0)
      }
    }
    return retval;
  }

  function _setupTest() internal override {
    super._setupTest();
  }

  function _checkTest() internal override returns(bool) {
    address solver = IMagicNumber(address(magicNum)).solver();
    assertEq(ITiny(solver).whatIsTheMeaningOfLife(), 42);

    uint size;
    assembly {
      size := extcodesize(solver)
    }
    assertLe(size, 10);

    return (ITiny(solver).whatIsTheMeaningOfLife() == 42 && size <= 10);
  }
}
