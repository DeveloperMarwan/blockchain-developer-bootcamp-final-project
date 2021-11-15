// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";
import "./MultiSigSafe.sol";

contract Staker {
    MultiSigSafe public multiSigSafe;
    mapping ( address => uint256 ) public balances;
    address[] private stakersList;
    uint256 public deadline = block.timestamp + 30 seconds;
    bool public openForWithdraw;
    uint256 public constant threshold = 1 ether;
    bool public stakingCompleted;
    bool public multiSigSafeInit;

    event Stake(address _stakeAddress, uint256 _stakeAmount);
    event MultiSigSafeCreated(address _multiSigSafeAddress);

    modifier deadlinePassed() {
        require(block.timestamp >= deadline, 'Deadline has not passed yet');
        _;
    }

    modifier notCompleted() {
        require(stakingCompleted == false, 'Contract completed');
        _;
    }

    function stake() public payable notCompleted {
        if (balances[msg.sender] == 0) {
            stakersList.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function execute() public deadlinePassed notCompleted {
        stakingCompleted = true;
        if (address(this).balance >= threshold) {
            multiSigSafe = (new MultiSigSafe){value : address(this).balance}(stakersList, stakersList.length);
            multiSigSafeInit = true;
            emit MultiSigSafeCreated(address(multiSigSafe));
        } else {
            openForWithdraw = true;
        }
    }

    function withdraw(address payToAddress) public deadlinePassed {
        require(msg.sender == payToAddress, 'Not allowed to withdraw balance that does not belong to you');
        require(openForWithdraw, 'Not allowed to withdraw funds.');
        uint256 theBalance = balances[payToAddress];
        require(theBalance > 0, 'The balance is zero, nothing to withdraw');
        balances[payToAddress] = 0;
        (bool sent, ) = payToAddress.call{value: theBalance}("");
        require(sent, "Failed to send balance to the withdrawal address");
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}
