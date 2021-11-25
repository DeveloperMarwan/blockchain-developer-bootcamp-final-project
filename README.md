# blockchain-developer-bootcamp-final-project

## Project Idea: 
Create a staking DAO.

## Use Case:
- A deadline is established for members of the DAO to stake ETH.
- A threshold ETH amount is set.
- If the threshold ETH amount is not collected by the deadline, members will be allowed to withdraw funds that they put in.
- If the threshold value of ETH is reached by the deadline, staking will be considered complete and the full balance of ETH is sent to a multi-sig safe. 
- The staking process is considered completed once the "execute" method on the "Staker" contract is called. This method can only be called after the deadline has passed. Please note that the time deadline is only used to allow/disallow calling the execute method. Prior to calling the execute method, users can still stake ETH even if the deadline has passed. After calling the execute method, staking will be complete.
- The multi-sig safe is created after the staking is completed. The safe is initialized with the balance staked and the staking accounts. The required number of signatures is set to the number of owners minus one.
- Members will be allowed to propose transactions to send ETH to an address.
- If the required number of signatures is achieved the ETH is transferred.

## Installation and Setup:
> Prerequisites: [Node](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

> clone the final project repository:

```bash
git clone https://github.com/DeveloperMarwan/blockchain-developer-bootcamp-final-project.git
cd blockchain-developer-bootcamp-final-project
git checkout main
```

> install and start the‍ Hardhat chain: (Please note that the chain runs on **locahost port 8545** and with **chain id: 1337**. Your MetaMask Network settings should match those values)

```bash
yarn install
yarn chain
```

> 1. Create the .env file in the /packages/react-app folder. You can use the .sample.env file as a starting point. 
> 2. Enter your INFURA ID in line 3 and uncomment it. Please leave line 1 commented out.
> 3. in a second terminal window, start the frontend:

```bash
cd blockchain-developer-bootcamp-final-project
yarn start
```

> in a third terminal window, deploy the contract: (this will deploy to the local hardhat network). 
> The Staker contract is setup so that you can pass in the threshold  ETH amount (in WEI) and the staking period length (in Seconds). Currently, the deployment is set to pass 1 ETH and 60 seconds as the parameter values. You can change those values by editing the /packages/hardhat/deploy/00_deploy_your_contract.js file (line #11).

```bash
cd blockchain-developer-bootcamp-final-project
yarn deploy
```

> to run the tests:

```bash
cd blockchain-developer-bootcamp-final-project
yarn test
```
## Deploynig to a test network (eg. Ropsten, Rinkeby, etc.):
> 1. Create the .env file in the /packages/hardhat folder. You can use the example.env file as a starting point.
> 2. Enter the relevant information for the target test network .env
> 3. Update the /packages/hardhat/hardhat-config.js and change the defaultNetwork to the name of the target network.
> 4. Run the command: yarn deploy in a terminal window. 

## Updating the front-end to point to the test network:
> 1. Update the .env file in the /packages/react-app folder by entering your INFURA ID in line 1 and uncommenting it.
> 2. Make sure that REACT_APP_PROVIDER is pointing to the same test network that was used to deploy the contract(s).

## Frontend Project:
https://developermarwan-bootcamp.surge.sh/ 

## Public Ethereum Account:
developermarwan.eth

## Directory Structure:
```
packages
 ┣ hardhat
 ┃ ┣ contracts
 ┃ ┃ ┣ MultiSigSafe.sol
 ┃ ┃ ┗ Staker.sol
 ┃ ┣ deploy
 ┃ ┃ ┗ 00_deploy_your_contract.js
 ┃ ┣ scripts
 ┃ ┃ ┣ deploy.js
 ┃ ┃ ┣ publish.js
 ┃ ┃ ┗ watch.js
 ┃ ┣ test
 ┃ ┃ ┣ testMultiSigSafe.js
 ┃ ┃ ┗ testStaker.js
 ┃ ┣ .eslintrc.js
 ┃ ┣ example.env
 ┃ ┣ hardhat.config.js
 ┃ ┗ package.json
 ┣ react-app
 ┃ ┣ public
 ┃ ┃ ┣ dark-theme.css
 ┃ ┃ ┣ favicon.ico
 ┃ ┃ ┣ index.html
 ┃ ┃ ┣ light-theme.css
 ┃ ┃ ┣ logo192.png
 ┃ ┃ ┣ logo512.png
 ┃ ┃ ┣ manifest.json
 ┃ ┃ ┣ robots.txt
 ┃ ┃ ┗ scaffold-eth.png
 ┃ ┣ scripts
 ┃ ┃ ┣ create_contracts.js
 ┃ ┃ ┣ ipfs.js
 ┃ ┃ ┣ s3.js
 ┃ ┃ ┗ watch.js
 ┃ ┣ src
 ┃ ┃ ┣ components
 ┃ ┃ ┃ ┣ Contract
 ┃ ┃ ┃ ┃ ┣ DisplayVariable.jsx
 ┃ ┃ ┃ ┃ ┣ FunctionForm.jsx
 ┃ ┃ ┃ ┃ ┣ index.jsx
 ┃ ┃ ┃ ┃ ┗ utils.js
 ┃ ┃ ┃ ┣ Account.jsx
 ┃ ┃ ┃ ┣ Address.jsx
 ┃ ┃ ┃ ┣ AddressInput.jsx
 ┃ ┃ ┃ ┣ Balance.jsx
 ┃ ┃ ┃ ┣ Blockie.jsx
 ┃ ┃ ┃ ┣ BytesStringInput.jsx
 ┃ ┃ ┃ ┣ EtherInput.jsx
 ┃ ┃ ┃ ┣ Events.jsx
 ┃ ┃ ┃ ┣ Faucet.jsx
 ┃ ┃ ┃ ┣ GasGauge.jsx
 ┃ ┃ ┃ ┣ Header.jsx
 ┃ ┃ ┃ ┣ L2Bridge.jsx
 ┃ ┃ ┃ ┣ Provider.jsx
 ┃ ┃ ┃ ┣ Ramp.jsx
 ┃ ┃ ┃ ┣ Swap.jsx
 ┃ ┃ ┃ ┣ ThemeSwitch.jsx
 ┃ ┃ ┃ ┣ Timeline.jsx
 ┃ ┃ ┃ ┣ TokenBalance.jsx
 ┃ ┃ ┃ ┣ Wallet.jsx
 ┃ ┃ ┃ ┗ index.js
 ┃ ┃ ┣ contracts
 ┃ ┃ ┃ ┗ external_contracts.js
 ┃ ┃ ┣ helpers
 ┃ ┃ ┃ ┣ Transactor.js
 ┃ ┃ ┃ ┣ index.js
 ┃ ┃ ┃ ┗ loadAppContracts.js
 ┃ ┃ ┣ hooks
 ┃ ┃ ┃ ┣ Debounce.js
 ┃ ┃ ┃ ┣ EventListener.js
 ┃ ┃ ┃ ┣ ExternalContractLoader.js
 ┃ ┃ ┃ ┣ GasPrice.js
 ┃ ┃ ┃ ┣ LocalStorage.js
 ┃ ┃ ┃ ┣ TokenList.js
 ┃ ┃ ┃ ┣ index.js
 ┃ ┃ ┃ ┗ useContractConfig.js
 ┃ ┃ ┣ themes
 ┃ ┃ ┃ ┣ dark-theme.less
 ┃ ┃ ┃ ┗ light-theme.less
 ┃ ┃ ┣ views
 ┃ ┃ ┃ ┣ ExampleUI.jsx
 ┃ ┃ ┃ ┣ Hints.jsx
 ┃ ┃ ┃ ┣ Subgraph.jsx
 ┃ ┃ ┃ ┗ index.js
 ┃ ┃ ┣ App.css
 ┃ ┃ ┣ App.jsx
 ┃ ┃ ┣ App.test.js
 ┃ ┃ ┣ constants.js
 ┃ ┃ ┣ ethereumLogo.png
 ┃ ┃ ┣ index.css
 ┃ ┃ ┣ index.jsx
 ┃ ┃ ┗ setupTests.js
 ┃ ┣ .eslintignore
 ┃ ┣ .eslintrc.js
 ┃ ┣ .prettierrc
 ┃ ┣ .sample.env
 ┃ ┣ gulpfile.js
 ┃ ┣ package-lock.json
 ┃ ┗ package.json
 ```







