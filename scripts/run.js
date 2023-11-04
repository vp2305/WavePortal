// To start local network and keeping it alive run: npx hardhat node
const hre = require("hardhat");
const main = async () => {
  // HRE = Hardhat Runtime Environment
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  }); // deploying our contract to the blockchain.
  await waveContract.deployed();

  console.log("Contract deployed to: ", waveContract.address);
  console.log("Contract deployed by: ", owner.address);

  /*
   *  Check the account balance!
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  /*
   * Send Wave
   */
  // We are manually calling our functions! Just like we would any normal API.
  const waveTxn = await waveContract.wave("A message");
  await waveTxn.wait();

  // Simulating another user calling our wave function
  const secondWaveTxn = await waveContract
    .connect(randomPerson)
    .wave("Wow second message!");
  await secondWaveTxn.wait();

  const thirdWaveTxn = await waveContract
    .connect(randomPerson)
    .wave("Wow third message!");
  await thirdWaveTxn.wait();

  /*
   * Get the total wave!
   */
  await waveContract.getTotalWaves();
  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);

  /*
   *  All Wave Count
   */
  let allWaveCount = await waveContract.getAllWaveCount();
  console.log(allWaveCount);

  /*
   *  Check the account balance!
   */
  let contractBalanceCheck = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalanceCheck)
  );
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); // exit Node process without error
  } catch (error) {
    console.log(error);
    process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
  }
  // Read more about Node exit ('process.exit(num)') status code here: https://stackoverflow.com/a/47163396/7974948
};

/**
 *  npx hardhat run scripts/deploy.js --network goerli
    Deploying contracts with account:  0x27B4372f30831521fFBc9651e62e2c17B7E13034
    Account balance:  200000000000000000
    WavePortal address:  0x88c8469F62b1Fa375550E1E3B1cFdE7292A49957
 */

runMain();
