// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {LevelFactory} from "../utils/LevelFactory.sol";
import {Forta, IForta, CryptoVault, LegacyToken, DoubleEntryPoint, DelegateERC20} from "../../src/DoubleEntryPoint/Level.sol";
import {DetectionBot} from "../utils/DetectionBot.sol";

contract DoubleEntryPointTest is LevelFactory {
    Forta forta;
    CryptoVault vault;
    LegacyToken lgt;
    DoubleEntryPoint det;

    function setUp() public {
        vm.startPrank(deployer, deployer);
        forta = new Forta();
        vault = new CryptoVault(deployer);
        lgt = new LegacyToken();
        det = new DoubleEntryPoint(address(lgt), address(vault), address(forta), attacker);
        vm.stopPrank();
    }

    function testAttack() public {
        submitLevel("DoubleEntryPoint");
    }

    function _performTest() internal override {
        emit log_named_address("forta", address(forta));
        DetectionBot bot = new DetectionBot(address(lgt), address(det), address(forta));
        forta.setDetectionBot(address(bot));
    }

    function _setupTest() internal override {
        emit log_named_address("owner", lgt.owner());
        lgt.delegateToNewContract(DelegateERC20(address(det)));
        vault.setUnderlying(address(det));
    }

    function _checkTest() internal override returns (bool) {
        vm.expectRevert("Alert has been triggered, reverting");
        vault.sweepToken(IERC20(address(lgt)));
        return true;
    }
}
