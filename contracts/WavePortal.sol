// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// A smart contract = Kinda like our server's code with different functions people can hit.

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; // probably an int value
    uint256 private seed;
    
    /*
     * A little magic, Google what events are in Solidity!
    **/
    event NewWave(address indexed waver, uint256 timestamp, string message);

    event NewWaveCount(address indexed user, uint256 numberOfWaves);

    /*
     * State variable - permanently stored in contract storage. 
    **/
    struct WaveCount {
        address user;
        uint256 numberOfWaves;
    }
    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
    **/
    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
    **/
    Wave[] waves;
    
    /* 
     * Create a mapping to store the results 
    **/
    mapping (address => WaveCount) public results;

    /*
     *  This is an address => uint mapping, meaning I can associate an address with a number.
     *  In this case, I'll be storing the address with the last time the user waved at us.
    * */
    mapping(address => uint256) public lastWavedAt;

    /* 
     * Create an array to store the results 
    **/
    address[] public wave_results;

    
    // Like any other functions we will need to manually call the functions that we've created.

    /* 
     * When we run waveContractFactory.deploy() we are deploying our contract to the blockchain. 
    **/
    // constructor() {
    //     console.log("Hello World! I am a contract and I am smart");
    // }

    constructor() payable {
        console.log("I am a contract and I am smart");
        /*
         *  Set the initial seed 
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    /* 
     * Our functions become available to be called on the blockchain because we used that special "PUBLIC" keyword on our functions.
     * Can think of this as a public API endpoint. 
    **/
    function wave(string memory _message) public { 
        /*
         *  We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored.
         *  This is how we make sure the user waits 15-minutes before waving again.
         * */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
        **/
        lastWavedAt[msg.sender] = block.timestamp;

        /*
         * This is where I actually store the wave data in the array.
        **/
        waves.push(Wave(msg.sender, _message, block.timestamp));
        
        seed = (seed + block.timestamp + block.difficulty) % 100;
        console.log("Random # generated: %s", seed);

        /*
         *  Give a 50% chance that the user wins the prize. 
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            // We need to fund the smart contract to send money to the user.
            uint256 prizeAmount = 0.0001 ether;
            /*
            *  You'll see require which basically checks to see that some condition is true. 
            *  If it's not true, it will quit the function and cancel the transaction. 
            *  It's like a fancy if statement!
            **/
            // Check if the contract has enough money to send to the user.
            require(prizeAmount <= address(this).balance, 
                "Trying to withdraw more money than the contract has.");
            (bool success, ) = (msg.sender).call{value: prizeAmount}(""); // !Used to send money.
            // Check if the transaction was successful.
            require(success, "Failed to withdraw money from contract.");
        }

        /*
         * You're emitting an event. So people who're listening to any new waves know that a new wave has been produced.
         * The emitted event data is also stored on chain.
        **/
        emit NewWave(msg.sender, block.timestamp, _message);

        // Add the address to the results array
        if (results[msg.sender].user == address(0)) {
            wave_results.push(msg.sender);
        }

        // Convert to msg.sender to string
        results[msg.sender].user = msg.sender;
        results[msg.sender].numberOfWaves += 1;
        
        // Increment the wave count
        totalWaves += 1;
        console.log("%s have waved with the message %s!", msg.sender, _message);
    }

    function getTotalWaves() public view returns(uint256) {    
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getAllWaves() public view returns(Wave[] memory){
        return waves;
    }

    function getAllWaveCount() public view returns(address[] memory){
        for (uint256 i = 0; i < wave_results.length; i++) {
            console.log("Address: %s, Number of Waves: %d", results[wave_results[i]].user, results[wave_results[i]].numberOfWaves);
            // emit NewWaveCount(results[wave_results[i]].user, results[wave_results[i]].numberOfWaves);
        }
        return wave_results;
    }
}
