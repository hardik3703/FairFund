// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/**
 * @title IFundingStrategy
 * @notice Interface for different funding strategies
 */
interface IFundingStrategy {
    function calculateFunding(uint256 proposalId, uint256 totalVotes, uint256 proposalVotes, uint256 totalFunds)
        external
        view
        returns (uint256);
}
