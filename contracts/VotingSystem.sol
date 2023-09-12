// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingSystem {
    
       struct Voter {
        uint weight; 
        bool voted;  
        uint vote;   
    }

    struct Candidate {
        string name;    
        uint voteCount; 
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Candidate[] public candidates;
    
    enum State { 
        Created, 
        Voting, 
        Ended }     
    State public state;

    constructor(string[] memory candidateNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        state = State.Created;
        
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }

    modifier onlyOwner() {
        require(
            msg.sender == chairperson,
            "Only chairperson can start and end the voting"
        );
        _;
    }

    function addCandidates(string[] memory candidateNames) 
        public
    {
        state = State.Created;
        for (uint i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            }));
        }
    }

    function startVote() 
        public
        onlyOwner
    {
        state = State.Voting;
    }

    function endVote() 
        public 
        onlyOwner
    {
        state = State.Ended;
    }

    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /**
     * @dev Give your vote (including votes delegated to you) to candidate 'candidates[candidate].name'.
     * @param candidate index of candidate in the candidates array
     */
    function vote(uint candidate) 
        public
        VotingState
    {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = candidate;

        // If 'candidate' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        candidates[candidate].voteCount += sender.weight;
    }

    function winningCandidate() 
        public
        EndedState
        view
        returns (string memory winnerName_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < candidates.length; p++) {
            if (candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = candidates[p].voteCount;
                winnerName_ = candidates[p].name;
            }
        }
    }

    
    




}