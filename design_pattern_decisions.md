The design patterns below were used:

1. **Inheritance and Interfaces:** The Staker contract imports the MultiSigSafe contract. Also, the MultiSigSafe contract imports the OpenZeppelin Ownable contract.
2. **Inter-Contract Execution:** The Staker contract instantiates the MultiSigSafe contract by calling its constructor and passing in a list of parameters to initialize the safe. It also sends ETH to the safe since the constructor is payable.
3. **Access Control Design Patterns:** The MUltiSigSafe contract extends the OpenZeppelin Ownable contract to restrict access.