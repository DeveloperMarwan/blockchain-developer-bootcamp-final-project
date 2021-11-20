# blockchain-developer-bootcamp-final-project

## Project Idea: 
Create a NFT DAO.

## Use Case:
- A deadline is established for members of the DAO to stake ETH.
- If the threshold ETH amount is not collected by the deadline, members will be allowed to withdraw funds that they put in.
- If a certain threshold value of ETH is reached by the deadline, staking will be considered complete and the full balance of ETH is sent to a "safe".
- Members will be allowed to propse purchasing a NFT (from OpenSea for example).
- If consensus is reached, the purchase is made.
- The DAO will have the option to sell the NFT and then distribute the proceeds of the sale back to the members.

## Installation and Setup:
> Prerequisites: [Node](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

> clone the final project repository:

```bash
git clone https://github.com/DeveloperMarwan/blockchain-developer-bootcamp-final-project.git
cd blockchain-developer-bootcamp-final-project
git checkout main
```

> install and start the‍ Hardhat chain:

```bash
yarn install
yarn chain
```

> in a second terminal window, start the frontend:

```bash
cd blockchain-developer-bootcamp-final-project
yarn start
```

> in a third terminal window, deploy the contract: (this will deploy to the local hardhat network)

```bash
cd blockchain-developer-bootcamp-final-project
yarn deploy
```

> to run the tests:

```bash
cd blockchain-developer-bootcamp-final-project
yarn test
```
## Deployig to a test network (eg. Ropsten, Rinkeby, etc.):
> 1. Create the .env file in the /packages/hardhat folder. You can use the example.env file as a starting point.
> 2. Enter the relevant information for the target test network .env
> 3. Update the /packages/hardhat/hardhat-config.js and change the defaultNetwork to the name of the target network.
> 4. Run the command: yarn deploy in a terminal window. 

## Uodating the front-end to point to the test network:
> 1. Create the .env file in the /packages/react-app folder. You can use the .sample.env file as a starting point.
> 2. Enter the relevant information for the target test netowrk in .env

## Frontend Project:
(put the URL of the fronend here)

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







