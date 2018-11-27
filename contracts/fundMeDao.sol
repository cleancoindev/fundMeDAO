pragma solidity ^0.5.0;

import "./Ownable.sol";

contract fundMeDao is Ownable {

    uint public minimumQuorum;
    uint public debatingPeiodInMinutes;
    int public majorityMargin;
    ///@notice list of proposals
    Proposal[] public proposals;
    ///@notice proposals counter
    uint public numProposals;
    ///@notice list of funders for a proposal
    mapping(address => mapping (bytes32 => bool)) funders;
    
    event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
    event Voted(uint proposalID, bool position, address voter, string justification);
    event ProposalTallied(uint proposalID, int result, uint quorum, bool active);
    event MembershipChanged(address member, bool isMember);
    event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, int newMajorityMargin);

    struct Proposal {
        address payable recipient;
        uint256 amount;
        string description;
        uint minExecutionDate;
        bool executed;
        bool proposalPassed;
        uint numberOfVotes;
        int currentResult;
        bytes32 proposalHash;
        Vote[] votes;
        mapping (address => bool) voted;
    }

    struct Vote {
        bool inSupport;
        address voter;
        string justification;
    }

    /**
     * @dev check if `msg.sender` funded a specific proposal
     * @param _proposalHash proposal hash
     */
    modifier isFunder(bytes32 _proposalHash) {
        require(funders[msg.sender][_proposalHash] == true);
        _;
    }

}