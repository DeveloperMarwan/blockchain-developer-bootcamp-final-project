// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";

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

    event SafeUserAdded(address indexed user);
    //event SafeUserRemoved(address indexed user);
    event DepositFunds(address from, uint256 amount, uint256 balance);
    event WithdrawFunds(address from, uint256 amount);
    event TransferFunds(address from, address to, uint256 amount);
    event TransactionCreated(address by, address to, uint256 amount, uint256 transactionId);
    event TransactionSigned(address by, uint256 transactionId);
    event TransactionCompleted(address from, address to, uint256 amount, uint256 transactionId);

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
    }

    function getNumberOfSigsRequired() validUser public view returns (uint256) {
        return minSigsRequired;
    }

    function getPendingTransactions() validUser public view returns (uint256[] memory) {
        return pendingTransactions;
    }

    receive() payable external {
        emit DepositFunds(msg.sender, msg.value, address(this).balance);
    }

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