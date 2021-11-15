const { expect } = require("chai");

describe("MultiSigSafe contract", function () {
    let MultiSigSafe;
    let multisigsafe;
    let owner;
    let staker_1;
    let staker_2;
    let staker_3;
    let addrs;
    let provider;

    beforeEach(async function() {
        [owner, staker_1, staker_2, staker_3, ...addrs] = await ethers.getSigners();
        MultiSigSafe = await ethers.getContractFactory("MultiSigSafe");
        multisigsafe = await MultiSigSafe.deploy([owner.address, staker_1.address, staker_2.address], 2, 
            {
                value: ethers.utils.parseEther("1.0")
            }
        );
        provider = waffle.provider;    
    });

    describe("Deployment", function() {
        it("Should set the right owner", async function () {
            expect(await multisigsafe.owner()).to.equal(owner.address);
        });

        it("Should set the correct number of sigs required", async function () {
            expect(await multisigsafe.getNumberOfSigsRequired()).to.equal(2);
        });

        it("Should receive the correct ETH", async function () {
            expect(await provider.getBalance(multisigsafe.address)).to.equal(ethers.utils.parseEther("1.0"));
        });
    });

    describe("Transactions", function() {
        it("Should create a new transaction when transferTo is called", async function () {
            await multisigsafe.transferTo(addrs[0].address, ethers.utils.parseEther("0.1"));
            const pendingTxns = await multisigsafe.getPendingTransactions();
            expect(pendingTxns.length).to.equal(1);
        });

        it("Should create multiple transactions", async function () {
            await expect(multisigsafe.transferTo(addrs[0].address, ethers.utils.parseEther("0.1")))
                    .to.emit(multisigsafe, 'TransactionCreated')
                    .withArgs(owner.address, addrs[0].address, ethers.utils.parseEther("0.1"), 0);
            await expect(multisigsafe.transferTo(addrs[1].address, ethers.utils.parseEther("0.2")))
                    .to.emit(multisigsafe, 'TransactionCreated')
                    .withArgs(owner.address, addrs[1].address, ethers.utils.parseEther("0.2"), 1);
            await expect(multisigsafe.transferTo(addrs[2].address, ethers.utils.parseEther("0.3")))
                    .to.emit(multisigsafe, 'TransactionCreated')
                    .withArgs(owner.address, addrs[2].address, ethers.utils.parseEther("0.3"), 2);
            const pendingTxns = await multisigsafe.getPendingTransactions();
            expect(pendingTxns.length).to.equal(3);
        });

        it("Should allow a valid safe owner to sign a transaction", async function () {
            await expect(multisigsafe.transferTo(addrs[0].address, ethers.utils.parseEther("0.1")))
                    .to.emit(multisigsafe, 'TransactionCreated')
                    .withArgs(owner.address, addrs[0].address, ethers.utils.parseEther("0.1"), 0);
            await expect(multisigsafe.connect(staker_1).signTransaction(0))
                    .to.emit(multisigsafe, 'TransactionSigned')
                    .withArgs(staker_1.address, 0);
        });

        it("Should fail to sign a transaction that does not exist" , async function () {
            await expect(multisigsafe.connect(staker_1).signTransaction(1))
                    .to.be.revertedWith('Transaction does not exit');
        });

        it("Should fail to sign a transaction when the signer is the same as the transaction creator", async function () {
            await expect(multisigsafe.connect(staker_1).transferTo(addrs[0].address, ethers.utils.parseEther("0.1")))
                    .to.emit(multisigsafe, 'TransactionCreated')
                    .withArgs(staker_1.address, addrs[0].address, ethers.utils.parseEther("0.1"), 0);
            await expect(multisigsafe.connect(staker_1).signTransaction(0))
                    .to.be.revertedWith('Transaction creator can not sign it');
        });

        it("Should fail to sign a transaction that is already signed", async function () {
            await expect(multisigsafe.transferTo(addrs[0].address, ethers.utils.parseEther("0.1")))
                    .to.emit(multisigsafe, 'TransactionCreated')
                    .withArgs(owner.address, addrs[0].address, ethers.utils.parseEther("0.1"), 0);
            await expect(multisigsafe.connect(staker_1).signTransaction(0))
                    .to.emit(multisigsafe, 'TransactionSigned')
                    .withArgs(staker_1.address, 0);
            await expect(multisigsafe.connect(staker_1).signTransaction(0))
                    .to.be.revertedWith('Transaction already signed');
        });

        it("Should allow one signer to create a transaction and other signers to sign it", async function () {
            //store the balance of the receiving address
            const receiverBalanceBeforeTransfer = await provider.getBalance(addrs[0].address);
            //create a transaction by calling transferTo() - note that txn will be created by the "owner" account
            await multisigsafe.transferTo(addrs[0].address, ethers.utils.parseEther("0.1"));
            //need to switch to another signer to sign the txn, will use staker_1 and staker_2
            await multisigsafe.connect(staker_1).signTransaction(0);
            //we will need another signature since the required number is 2, the call below should also execute the transaction.
            await multisigsafe.connect(staker_2).signTransaction(0);
            // get receiver balance after the transfer
            const receiverBalanceAfterTransfer = await provider.getBalance(addrs[0].address);
            //expect(await provider.getBalance(addrs[0].address)).to.equal(ethers.utils.parseEther("0.1"));
            expect(receiverBalanceAfterTransfer).to.gt(receiverBalanceBeforeTransfer);
        });
    });

});
