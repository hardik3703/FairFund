// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {FairFund} from "../../../src/v1/FairFund.sol";
import {FundingVault} from "../../../src/v1/FundingVault.sol";
import {VotingPowerToken} from "../../../src/v1/VotingPowerToken.sol";
import {DeployFairFund} from "../../../script/v1/DeployFairFund.s.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";

contract FairFundTest is Test {
    HelperConfig helperConfig;
    FairFund fairFund;

    function setUp() external {
        DeployFairFund deployFairFund = new DeployFairFund();
        (fairFund, helperConfig) = deployFairFund.run();
    }

    function testFuzzDeployFundingVault(
        address _fundingToken,
        address _votingToken,
        uint256 _minRequestableAmount,
        uint256 _maxRequestableAmount,
        uint256 _tallyDate,
        address _owner
    ) public {
        vm.assume(_fundingToken != address(0));
        vm.assume(_votingToken != address(0));
        vm.assume(_owner != address(0));
        vm.assume(_tallyDate > block.timestamp);
        vm.assume(_maxRequestableAmount > 0);
        vm.assume(_minRequestableAmount <= _maxRequestableAmount);

        fairFund.deployFundingVault(
            _fundingToken, _votingToken, _minRequestableAmount, _maxRequestableAmount, _tallyDate, _owner
        );

        uint256 totalVaults = fairFund.getTotalNumberOfFundingVaults();
        address fundingVaultAddress = fairFund.getFundingVault(totalVaults);
        assertEq(totalVaults, 1);
        assertTrue(fundingVaultAddress != address(0));
    }
}
