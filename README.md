# blockchain-developer-bootcamp-final-project

Project Idea: 
Create a NFT DAO.

Use Case:
- A deadline is established for members of the DAO to stake ETH.
- If the threshold ETH amount is not collected by the deadline, members will be allowed to withdraw funds that they put in.
- If a certain threshold value of ETH is reached by the deadline, staking will be considered complete and the full balance of ETH is sent to a "safe".
- Members will be allowed to propse purchasing a NFT (from OpenSea for example).
- If consensus is reached, the purchase is made.
- The DAO will have the option to sell the NFT and then distribute the proceeds of the sale back to the members.

Prerequisites: [Node](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

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

> in a third terminal window, deploy the contract:

```bash
cd blockchain-developer-bootcamp-final-project
yarn deploy
```



