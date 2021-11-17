const { expect } = require("chai");

describe("Staker contract", function () {
    let Staker;
    let staker;
    let staker_1;
    let staker_2;
    let staker_3;
    let addrs;
    let provider;

    beforeEach(async function () {
        [staker_1, staker_2, staker_3, ...addrs] = await ethers.getSigners();
        Staker = await ethers.getContractFactory("Staker");
        //set the threshold to 1 ETH and duration to 30 seconds
        staker = await Staker.deploy(ethers.utils.parseEther("1.0"), 30);
        provider = waffle.provider;
    });

    describe("Deployment", function() {
        it("Should set the right initial parameters", async function () {
            expect(await staker.openForWithdraw()).to.false;
            expect(await staker.stakingCompleted()).to.false;
        });
    });

    describe("Transactions", function () {
        it("Should allow staking from different stakers", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("1.0") });
            expect(await provider.getBalance(staker.address)).to.equal(ethers.utils.parseEther("1.0"));
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("1.0") });
            expect(await provider.getBalance(staker.address)).to.equal(ethers.utils.parseEther("2.0"));
            await staker.connect(staker_3).stake({value: ethers.utils.parseEther("1.0") });
            expect(await provider.getBalance(staker.address)).to.equal(ethers.utils.parseEther("3.0"));
        });

        it("Should not allow execute() if deadline has not passed", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("1.0") });
            await expect(staker.execute()).to.be.revertedWith('Deadline has not passed yet');
        });

        it("Should run execute() and send the balance to the multi sig safe if threshold is reached and deadline is passed", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.5") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.5") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await expect(staker.connect(staker_1).execute()).to.emit(staker, "MultiSigSafeCreated");
            expect(await staker.stakingCompleted()).to.equal(true);
            expect(await staker.openForWithdraw()).to.equal(false);
        });

        it("Should fail to execute more than once", async function() {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.5") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.5") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await expect(staker.connect(staker_1).execute()).to.emit(staker, "MultiSigSafeCreated");
            expect(await staker.stakingCompleted()).to.equal(true);
            expect(await staker.openForWithdraw()).to.equal(false);
            await expect(staker.connect(staker_1).execute()).to.be.revertedWith('Contract completed');
        });

        it("Should faile to stake after execute is called", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.5") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.5") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await expect(staker.connect(staker_1).execute()).to.emit(staker, "MultiSigSafeCreated");
            expect(await staker.stakingCompleted()).to.equal(true);
            expect(await staker.openForWithdraw()).to.equal(false);
            await expect(staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.5") })).to.be.revertedWith('Contract completed');
        });

        it("Should run execute() and set openForWithdraw to true if threshold is not reached and deadline is passed", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.4") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.4") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await staker.connect(staker_1).execute();
            expect(await staker.stakingCompleted()).to.equal(true);
            expect(await staker.openForWithdraw()).to.equal(true);
        });

        it("Should fail to withdraw if the threshold is not reached and the deadline has not passed", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.4") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.4") });
            await expect(staker.connect(staker_1).withdraw(staker_1.address)).to.be.revertedWith('Deadline has not passed yet');
        });

        it("Should allow withdraw if the threshold is not reached and the deadline is passed", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.4") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.4") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await staker.connect(staker_1).execute();
            await expect(await staker.connect(staker_1).withdraw(staker_1.address)).to.changeEtherBalance(staker_1, ethers.utils.parseEther("0.4"));
        });

        it("Should fail to withdraw if the address does not match the message sender", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.4") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.4") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await staker.connect(staker_1).execute();
            await expect(staker.connect(staker_1).withdraw(staker_2.address)).to.be.
                    revertedWith('Not allowed to withdraw balance that does not belong to you');
        });

        it("Should fail to withdraw if funds have already been withdrawn", async function () {
            await staker.connect(staker_1).stake({value: ethers.utils.parseEther("0.4") });
            await staker.connect(staker_2).stake({value: ethers.utils.parseEther("0.4") });
            //move the EVM time ahead to pass the deadline
            await hre.ethers.provider.send('evm_increaseTime', [30]);
            await staker.connect(staker_1).execute();
            await expect(await staker.connect(staker_1).withdraw(staker_1.address)).to.changeEtherBalance(staker_1, ethers.utils.parseEther("0.4"));
            await expect(staker.connect(staker_1).withdraw(staker_1.address)).to.be.
                    revertedWith('The balance is zero, nothing to withdraw');
        });
    });
});