// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../../src/Vault/Level.sol";
import "tests/Test.sol";
import "forge-std/console.sol";

interface IVault {
    function unlock(bytes32 _password) external;

    function locked() external returns (bool);
}

contract VaultTest is Test {
    IVault vault;
    
    address deployer = address(100);
    address attacker = address(101);
    
    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        vault = IVault(address(new Vault(bytes32("1234567890")))); // don't copy paste this ;)
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        vault.unlock(bytes32("1234567890"));
        /* Write your code here */ 

        /* Validating the test */
        assertFalse(vault.locked());
    }
}
