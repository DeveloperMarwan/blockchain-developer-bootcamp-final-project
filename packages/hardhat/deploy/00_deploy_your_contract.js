// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  await deploy("Staker", {
    from: deployer,
    args: [ethers.utils.parseEther("1"), 60],
    log: true,
  });
};
module.exports.tags = ["Staker"];
