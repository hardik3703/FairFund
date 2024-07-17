// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockERC20} from "../../../src/v1/mocks/MockERC20.sol";
import {HelperConfig} from "../../HelperConfig.s.sol";

contract DeployMockERC20 is Script {
    function run() external returns (MockERC20 mockERC20, HelperConfig helperConfig) {
        helperConfig = new HelperConfig();
        (uint256 deployerKey) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        mockERC20 = new MockERC20("MockERC20", "MERC");
        mockERC20.mint(vm.addr(deployerKey), 1000000000000000000000000);
        vm.stopBroadcast();
        string memory deploymentInfo = string.concat('{"mockERC20":"', vm.toString(address(mockERC20)), '"}');
        vm.writeFile("../web-app/src/blockchain/deployments/anvil/erc20_deployment.json", deploymentInfo);
    }
}
