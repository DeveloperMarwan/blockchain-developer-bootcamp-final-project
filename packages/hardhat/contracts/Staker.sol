// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
import "./MultiSigSafe.sol";

/** @title A Staking Contract
    @notice This contract allows a group of users to stake ETH within a specific period of time. If a predetermined threshold amount
    is reached, the contract will be executed and the staked balace will be transfered to a multi sig safe. If the threshold amount 
    is not reached, the users can withdrw the ETH they staked.
*/
contract Staker {
    /// @notice The instance of the multi sig safe. It will be initialized if the staking threshold amount is reached.
    MultiSigSafe public multiSigSafe;
    /// @notice A mapping of the user's address to the balance of ETH they staked.
    mapping ( address => uint256 ) public balances;
    
    address[] private stakersList;
    
    /// @notice The deadline to reach the staking ETH threshold. The execute method can't be called before the deadline passes.
    uint256 public deadline;
    
    /// @notice A flag that is set to true if the deadline passes and the staking threshold is not reached. 
    bool public openForWithdraw;
    
    /// @notice The staking threshold amount
     uint256 public threshold;
    
    /// @notice A flag that is set to true when the execute method is called. It is used to preven calling the execute mehtod more that one time.
    bool public stakingCompleted;
    
    /// @notice A falg that is set to true after the mutli sig safe is initialized. 
    bool public multiSigSafeInit;

    /// @notice An event that is emitted every time a user stakes ETH.
    /// @param _stakeAddress The address of the staking user
    /// @param _stakeAmount The amount staked byt the user
    event Stake(address _stakeAddress, uint256 _stakeAmount);

    /// @notice An event that is emitted when the multi sig safe is instantiated.
    /// @param _multiSigSafeAddress The address of the multi sig safe contract.
    event MultiSigSafeCreated(address _multiSigSafeAddress);

    modifier deadlinePassed() {
        require(block.timestamp >= deadline, 'Deadline has not passed yet');
        _;
    }

    modifier notCompleted() {
        require(stakingCompleted == false, 'Contract completed');
        _;
    }

    /** @notice The contract's constructor.
        @param _threshold The amount of ETH that needs to be staked to execute the contract. The amount must be passed in WEI.
        @param _duration How long will the staking be open. Must be passed in seconds.
    */
    constructor(uint256 _threshold, uint256 _duration) {
        require(_threshold > 0, "Threshold value must be greater than zero");
        require(_duration > 0, "Duration value must be greater than zero");
        threshold = _threshold;
        deadline = block.timestamp + _duration;
    }
    
    /// @notice Stake ETH. The amount staked will be added to the user's balance. Also, the user will be added to the stakers list. This method 
    /// can be called as long as the execute has not been called yet.
    function stake() public payable notCompleted {
        if (balances[msg.sender] == 0) {
            stakersList.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    /// @notice Execute the staking contract. If the deadline has passed, check the balance. If it is greater than or equal to the threshold, it will 
    /// instantiate the multi sig safe. Otherwise, it will allow the users to withdraw the ETH they staked. This method can only be called once.
    function execute() public deadlinePassed notCompleted {
        stakingCompleted = true;
        if (address(this).balance >= threshold) {
            multiSigSafe = (new MultiSigSafe){value : address(this).balance}(stakersList, stakersList.length > 1 ? stakersList.length - 1 : 1);
            multiSigSafeInit = true;
            emit MultiSigSafeCreated(address(multiSigSafe));
        } else {
            openForWithdraw = true;
        }
    }

    /// @notice The user can withdraw the amount they staked if the threshold amount was not reached before the deadline.
    /// @param payToAddress The address to send the withdrawn funds to. It must match the address of the staker.
    function withdraw(address payToAddress) public deadlinePassed {
        require(msg.sender == payToAddress, 'Not allowed to withdraw balance that does not belong to you');
        require(openForWithdraw, 'Not allowed to withdraw funds.');
        uint256 theBalance = balances[payToAddress];
        require(theBalance > 0, 'The balance is zero, nothing to withdraw');
        balances[payToAddress] = 0;
        (bool sent, ) = payToAddress.call{value: theBalance}("");
        require(sent, "Failed to send balance to the withdrawal address");
    }

    /// @notice Return the amount of time left beofre the deadline is reached.
    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}
