// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A Multi Sig Safe Contract
/// @notice Implements a multi signature safe. Users are added to the safe when it is initialized. The number of required signatures is also set at that time.
/// In order to send funds from the safe, a user must create a transaction which must by signed by the required number before it is executed. The user that 
/// created the trasnaction can't sign it. 
contract MultiSigSafe is Ownable {
    //mapping to determine if an address is an owner aker 1/0
    mapping(address => bool) private safeUsers;
    uint256 private minSigsRequired;
    uint256 private txnIndex;

    enum TxnState { Pending, Completed }
    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 signatureCount;
        TxnState txnState;
        mapping (address => uint8) signatures;
    }

    //mapping txnIndex => transaction
    mapping (uint256 => Transaction) private transactions;

    //list of current transactions
    uint256[] private pendingTransactions;

    modifier validUser() {
        require(msg.sender == owner() || safeUsers[msg.sender], "Must be a valid owner of the multi sig safe");
        _;
    }

    /// @notice An event that is emitted when a user is added to the safe.
    /// @param user The address of the added user.
    event SafeUserAdded(address indexed user);

    /// @notice An event that is emitted when funds are deposited into the safe.
    /// @param from The address of the . 
    /// @param amount The amount deposited.
    /// @param balance The safe's balance
    event DepositFunds(address from, uint256 amount, uint256 balance);

    /// @notice An event that is emitted when a transaction is created. 
    /// @param by The address of the user creating the transaction.
    /// @param to The address of the user who will receive the ETH if the transaction is completed.
    /// @param amount The amount of ETH that will be transfered from the safe to the recepient if the transaction is completed.
    /// @param transactionId The transaction Id.
    event TransactionCreated(address by, address to, uint256 amount, uint256 transactionId);

    /// @notice An event that us emitted when a trasnaction is sigend.
    /// @param by The address of the user who signed the transaction.
    /// @param transactionId The transaction Id.
    event TransactionSigned(address by, uint256 transactionId);

    /// @notice
    /// @param from The address of the user that created the transaction.
    /// @param to The address of the recepient.
    /// @param amount The amount sent to the recepient.
    /// @param transactionId The transaction Id.
    event TransactionCompleted(address from, address to, uint256 amount, uint256 transactionId);

    /// @notice Creates an instance of the multi sig safe. Assigns the users to the safe and sets the number of signatures required to complete a trasnaction. 
    /// The constructor is payable so ETH can be sent to fund the safe.
    /// @param _safeUsers A list of user addresses to be added to the safe. Those will be considered the ownders of the safe.
    /// @param _sigsRequired The number of signatures required to complete a trasnaction.
    constructor(address[] memory _safeUsers, uint _sigsRequired) payable {
        require(_sigsRequired > 0, "Number of signatures required must be > 0");
        require(_sigsRequired <= _safeUsers.length, "Number of signatures required must be less than or equal to the number of owners");
        minSigsRequired = _sigsRequired;
        for (uint i = 0; i < _safeUsers.length; i++) {
            address _newUser = _safeUsers[i];
            require(_newUser != address(0), "constructor - Zero address can not be a staker");
            require(!safeUsers[_newUser], "constructor - is already a staker");
            safeUsers[_newUser] = true;
            emit SafeUserAdded(_newUser);
        }
        emit DepositFunds(msg.sender, msg.value, address(this).balance);
    }

    /// @notice Returns the number of signatures required to complete a transaction. 
    function getNumberOfSigsRequired() validUser public view returns (uint256) {
        return minSigsRequired;
    }

    /// @notice Returns a list pending transaction Id's
    function getPendingTransactions() validUser public view returns (uint256[] memory) {
        return pendingTransactions;
    }

    /// @notice Receives ETH
    receive() payable external {
        emit DepositFunds(msg.sender, msg.value, address(this).balance);
    }

    /// @notice Creates a trasanction and populates its fields. The transaction will need to be signed by the required number of signatures for it to be completed.
    /// @param to The address of the recepient.
    /// @param amount The amoount of ETH to be sent to the recepient.
    function transferTo(address payable to, uint amount) validUser public {
        //make sure the balance is >= the amount of the transaction
        require(address(this).balance >= amount);
        uint txnId = txnIndex;
        Transaction storage transaction = transactions[txnId];
        txnIndex++;
        transaction.from = msg.sender;
        transaction.to = to;
        transaction.amount = amount;
        transaction.signatureCount = 0;
        transaction.txnState = TxnState.Pending;
        
        pendingTransactions.push(txnId);
        emit TransactionCreated(msg.sender, to, amount, txnId);
    }

    /// @notice Signs a trasanction. If the number of required signatures is reached, the trasanction is executed and marked as complete.
    /// @param txnId The Id of the transaction to be signed.
    function signTransaction(uint txnId) validUser public {
        Transaction storage txn = transactions[txnId];
        require(address(0) != txn.from, "Transaction does not exit");
        require(msg.sender != txn.from, "Transaction creator can not sign it");
        require(txn.signatures[msg.sender] != 1, "Transaction already signed");
        require(txn.txnState != TxnState.Completed, "Transaction already completed");
        txn.signatures[msg.sender] = 1;
        txn.signatureCount++;
        emit TransactionSigned(msg.sender, txnId);

        //if the transaction has a signature count >= the minimum signatures we can process the transaction
        //then we need to validate the transaction
        if (txn.signatureCount >= minSigsRequired) {
            //check balance
            require(address(this).balance >= txn.amount);
            txn.txnState = TxnState.Completed;
            (bool success, bytes memory result) = txn.to.call{value: txn.amount}("");
            require(success, "signTransaction: tx failed");
            //emit an event
            emit TransactionCompleted(txn.from, txn.to, txn.amount, txnId);
        }
    }
}