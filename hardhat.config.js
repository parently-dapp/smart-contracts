//require("hardhat-waffle");
require("hardhat-deploy");
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {

  // contracts_directory: "./contracts", // Adjust this path as needed
  // contracts_build_directory: "./build/contracts",

  networks: {
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${process.env.INFURA_API_KEY}`, // Polygon Mumbai Testnet RPC URL
      accounts: [process.env.PRIVATE_KEY], // Add your private key for deployment
    },
  },

  solidity: {
    version: "0.8.20", // Specify the desired Solidity version here
  },

  paths: {
    sources: "./contracts", // Directory where your contract source files are located
    artifacts: "./artifacts", // Directory where Hardhat stores compiled contracts
    cache: "./cache", // Directory for the contract cache files
    tests: "./test", // Directory where your tests are located
  },

  mocha: {
    timeout: 20000, // Increase timeout for tests (if needed)
  },

  namedAccounts: {
    deployer: {
      default: 0, // Set the default account index (e.g., the first account) for deploying contracts
    },
  },
  // ...
};
