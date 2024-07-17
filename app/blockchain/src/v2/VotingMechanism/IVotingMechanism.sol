// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/**
 * @title IVotingMechanism
 * @notice Interface for different voting mechanisms
 */
interface IVotingMechanism {
    function vote(address voter, uint256 proposalId, uint256 amount) external;
    function getVotes(uint256 proposalId) external view returns (uint256);
}
