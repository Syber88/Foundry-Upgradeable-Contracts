// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(100);
    }

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); //points to boxV1
    }

    function testUpgrades() public {
        BoxV2 box2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(box2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(100);
        assertEq(100, BoxV2(proxy).getNumber());
    }
}
