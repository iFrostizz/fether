// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {IForta} from "../../src/DoubleEntryPoint/Level.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {Bytes} from "solidity-examples/bytes/Bytes.sol";
import {Test} from "forge-std/Test.sol";

contract DetectionBot is Ownable, Test {
    // using Bytes.Bytes for bytes;

    address lgt;
    address det;
    address forta;

    constructor(address _lgt, address _det, address _forta) public {
        lgt = _lgt;
        det = _det;
        forta = _forta;
        // transferOwnership(forta);
        emit log_named_address("f", forta);
    }

    function handleTransaction(address user, bytes memory msgData) public /*onlyOwner*/ {
        bytes memory maliciousData = abi.encodeWithSignature("sweepToken(address)", lgt);
        emit log_named_bytes("data", msgData);
        emit log_named_bytes("mal", maliciousData);
        emit log_bytes(msgData);
        //if (msgData.equals(maliciousData)) {
            IForta(forta).raiseAlert(user);
        //}
    }
}
