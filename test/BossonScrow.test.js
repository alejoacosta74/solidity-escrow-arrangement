const BossonCoin = artifacts.require("BossonCoin");
const BossonScrow = artifacts.require("BossonScrow");

require('chai')
.use(require('chai-as-promised'))
.should()

function tokens(n){
    return web3.utils.toWei(n, 'ether')
}

contract ('bosson scrow contract', (accounts) => {
    let _bossoncoin , _bossonscrow 
    let  coinDeployer = accounts[0]
    let scrowDeployer = accounts[1]
    let buyer1 = accounts[2]
    let buyer2 = accounts[3]
    let seller1 = accounts[4]
    let seller2 = accounts[5]

    before (async () => {
        //load contracts
        _bossoncoin = await BossonCoin.new({from: coinDeployer})
        _bossonscrow = await BossonScrow.new(_bossonCoin.address, {from: scrowDeployer})    
    })

})