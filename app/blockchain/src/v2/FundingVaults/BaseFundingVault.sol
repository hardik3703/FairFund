// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IFundingStrategy} from "../FundingStrategy/IFundingStrategy.sol";
import {IVotingMechanism} from "../VotingMechanism/IVotingMechanism.sol";

/**
 * @title BaseFundingVault
 * @author Aditya Bhattad
 * @notice This is an abstract contract that has all the common functions for necessary funding vaults.
 */
abstract contract BaseFundingVault is Ownable, ReentrancyGuard {
    error BaseFundingVault__TransferFailed();
    error BaseFundingVault__TallyDateNotPassed();

    IERC20 public fundingToken;
    IFundingStrategy public fundingStrategy;
    IVotingMechanism public votingMechanism;

    uint256 public proposalCounter;
    uint256 public tallyDate;
    uint256 public totalFunds;

    struct Proposal {
        string metadata;
        uint256 minimumAmount;
        uint256 maximumAmount;
        address recipient;
    }

    mapping(uint256 proposalId => Proposal proposal) public proposalsToProposalId;

    event ProposalSubmitted(uint256 indexed proposalId, address indexed proposer);
    event FundsDeposited(address indexed depositor, uint256 amount);
    event FundsDistributed(uint256 indexed proposalId, address indexed recipient, uint256 amount);

    modifier checkTallyDatePassed() {
        if (block.timestamp < tallyDate) {
            revert BaseFundingVault__TallyDateNotPassed();
        }
        _;
    }

    constructor(
        address _fundingToken,
        address _fundingStrategy,
        address _votingMechanism,
        uint256 _tallyDate,
        address _owner
    ) Ownable(_owner) {
        fundingToken = IERC20(_fundingToken);
        fundingStrategy = IFundingStrategy(_fundingStrategy);
        votingMechanism = IVotingMechanism(_votingMechanism);
        tallyDate = _tallyDate;
    }

    function _submitProposal(
        string memory _metadata,
        uint256 _minimumAmount,
        uint256 _maximumAmount,
        address _recipient
    ) internal {
        proposalCounter++;
        proposalsToProposalId[proposalCounter] = Proposal(_metadata, _minimumAmount, _maximumAmount, _recipient);
        emit ProposalSubmitted(proposalCounter, msg.sender);
    }

    function _depositFunds(uint256 _amount) internal {
        bool success = fundingToken.transferFrom(msg.sender, address(this), _amount);
        if (!success) {
            revert BaseFundingVault__TransferFailed();
        }
        totalFunds += _amount;
        emit FundsDeposited(msg.sender, _amount);
    }

    function distributeFunds() external checkTallyDatePassed {
        // TODO: Add checks
        for (uint256 i = 1; i <= proposalCounter; i++) {
            uint256 proposalVotes = votingMechanism.getVotes(i);
            uint256 fundingAmount =
                fundingStrategy.calculateFunding(i, votingMechanism.getVotes(0), proposalVotes, totalFunds);
            if (fundingAmount > 0) {
                bool success = fundingToken.transfer(proposalsToProposalId[i].recipient, fundingAmount);
                if (!success) {
                    revert BaseFundingVault__TransferFailed();
                }
                emit FundsDistributed(i, proposalsToProposalId[i].recipient, fundingAmount);
            }
        }
    }
}
