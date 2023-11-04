/**
 * 1. Block number # 1 : It's the official 1st block in the block chain it's also called the Genesis Block or Block0 it's the very first block on which other additional blocks will be added.
 * 2. Transaction Hash or Transaction ID it's a unique string of characters that is given to every transaction that is verified and added to the blockchain.
 * 3. Gas : It refers to the fee required to conduct a transaction on Ethereum successfully. 
*/

const hre = require("hardhat");

const main = async () => {
    // const [deployer] = await hre.ethers.getSigners();
    // const accountBalance = await deployer.getBalance();

    // console.log("Deploying contracts with account: ", deployer.address);
    // console.log("Account balance: ", accountBalance.toString());

    // const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    // const waveContract = await waveContractFactory.deploy();
    // await waveContract.deployed();

    // console.log("WavePortal address: ", waveContract.address);
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.0001"),
    });

    await waveContract.deployed();
    console.log("WavePortal Address: ", waveContract.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();