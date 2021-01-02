const BossonCoin = artifacts.require("BossonCoin");
const BossonScrow = artifacts.require("BossonScrow");

module.exports = async function (deployer){
    // get available accounts
    accounts = await web3.eth.getAccounts();
    coinDeployer = accounts[0];
    scrowDeployer = accounts[1];
    // Deploy BossonCoin contract
    await deployer.deploy(BossonCoin, {from: coinDeployer});
    const _bossonCoin = await BossonCoin.deployed();
    // Deploy BossonScrow contract
    await deployer.deploy(BossonScrow, _bossonCoin.address, {from: scrowDeployer});
};  