// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockFairFund} from "../../../src/v1/mocks/MockFairFund.sol";
import {HelperConfig} from "../../HelperConfig.s.sol";

contract DeployMockFairFund is Script {
    function run() external returns (MockFairFund mockFairFund, HelperConfig helperConfig) {
        helperConfig = new HelperConfig();
        (uint256 deployerKey) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        mockFairFund = new MockFairFund();
        vm.stopBroadcast();
        string memory deploymentInfo = string.concat('{"mockFairFund":"', vm.toString(address(mockFairFund)), '"}');
        vm.writeFile("../web-app/src/blockchain/deployments/anvil/fairFund_deployment.json", deploymentInfo);
    }
}
