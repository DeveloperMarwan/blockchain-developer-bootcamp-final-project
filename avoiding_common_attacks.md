The following security measures were implemented to mitigate the attack vectors:
* Reentrancy ([SWC-107](https://swcregistry.io/docs/SWC-107))
* Floating Pragma ([SWC-103](https://swcregistry.io/docs/SWC-103))

1. **Proper Use of Require, Assert and Revert:** Both contracts make extensive use of "require" to validate input variables and to validate conditions before changing state.
2. **Use Modifiers Only for Validations:** Both contracts contain modifiers that only contain "require" statements.
3. **Pull Over Push:** The Staker contract has a "withdraw" method that allows the user to withdraw their staked funds if the threshold amount has not been reached. Please see Staker lines (77 - 85).
4. **Checks-Effects-Interactions:** The Staker contract implements this in the "withdraw" method in lines (81 - 83). Similarly, the MultiSigSafe contract implements this in "signTransaction" method in lines (134 - 136).
5. **Proper use of call, delegatecall instead of send, transfer:** Both contracts use call.value, please see Staker contract line 83 and MultiSigSafe line 136.
6. **Use Specific Compiler Pragma:** Both contracts use pragma solidity 0.8.4.