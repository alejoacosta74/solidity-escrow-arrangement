module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*", // Match any network id
      gasPrice: 20,  // 20 gwei (in wei) (default: 100 gwei)
      gas: 10000000,
    },
  },
  compilers: {
    solc: {
      version: ">=0.4.24 <0.8.0",
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  }
}

