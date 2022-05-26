// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "forge-std/console.sol";

contract GateProxy {
    function enter(address _gate, bytes8 _gateKey) external {
        (bool entered,) = _gate.call(abi.encodeWithSignature("enter(bytes8)", _gateKey));
        require(entered, "nope...");
    }
}
