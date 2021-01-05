const BossonCoin = artifacts.require("BossonCoin");
const BossonEscrow = artifacts.require("BossonEscrow");

require('chai')
.use(require('chai-as-promised'))
.should()

function tokens(n){
    return web3.utils.toWei(n, 'ether')
}

contract ('bosson escrow arrangement', (accounts) => {
    let _bossoncoin , _bossonescrow 
    let  coinDeployer = accounts[0]
    let escrowAgent = accounts[1]
    let buyer1 = accounts[2]
    let buyer2 = accounts[3]
    let seller1 = accounts[4]
    let seller2 = accounts[5]


    before (async () => {
        //load contracts
        _bossoncoin = await BossonCoin.new({from: coinDeployer})
        _bossonescrow = await BossonEscrow.new(_bossoncoin.address, {from: escrowAgent})
        
        //initialize buyer1 and buyer2 BossonCoin balance to 100
        _bossoncoin.transfer(buyer1, tokens('100'), {from: coinDeployer});
        _bossoncoin.transfer(buyer2, tokens('100'), {from: coinDeployer});

        //execute example input TXs
        await _bossoncoin.approve(_bossonescrow.address, tokens('20'), {from: buyer1})
        await _bossonescrow.credit(buyer1, tokens('20'), {from: escrowAgent})
        await _bossoncoin.approve(_bossonescrow.address, tokens('40'), {from: buyer2})
        await _bossonescrow.credit(buyer2, tokens('40'), {from: escrowAgent})
        await _bossonescrow.offer(seller1, "Coffee", tokens('3'), 10)
        await _bossonescrow.offer(seller2, "T-shirt", tokens('5'), 10)
        await _bossonescrow.offer(seller1, "Tea", tokens('2.5'), 10)
        await _bossonescrow.offer(seller1, "Cake", tokens('3.5'), 10)
        await _bossonescrow.offer(seller2, "Shorts", tokens('8'), 10)
        await _bossonescrow.offer(seller2, "Hoody", tokens('12'), 10)
        await _bossonescrow.order(buyer1, "T-shirt", {from: escrowAgent})
        await _bossoncoin.approve(_bossonescrow.address, tokens('10'), {from: buyer1})
        await _bossonescrow.credit(buyer1, tokens('10'), {from: escrowAgent})
        await _bossonescrow.order(buyer2, "Hoody", {from: escrowAgent})
        await _bossonescrow.complete(buyer1, "T-shirt", {from: escrowAgent})
        await _bossonescrow.order(buyer1, "Coffee", {from: escrowAgent})
        await _bossonescrow.order(buyer1, "Cake", {from: escrowAgent})
        await _bossonescrow.complain(buyer2, "Hoody", {from: escrowAgent})
        await _bossonescrow.order(buyer2, "Tea", {from: escrowAgent})
        await _bossonescrow.complete(buyer1, "Coffee", {from: escrowAgent})
    })

    describe ('Bosson escrow assigment', async () => {
        it ('Buyer1 balance is 18.5', async () => {
            balanceBuyer1 = await _bossonescrow.checkEscrowBalance(buyer1)
            assert.equal(balanceBuyer1.toString(), tokens('18.5'), "Buyer1 balance should be 18.5")
            console.log('\n')
            console.log('\t (test console output) Balance buyer1: ' + web3.utils.fromWei(balanceBuyer1.toString()))
        })
        it ('Seller2 balance is 5', async () => {
            balanceSeller2 = await _bossoncoin.balanceOf(seller2)
            assert.equal(balanceSeller2.toString(), tokens('5'), "Seller2 balance should be 5")
            console.log('\t (test console output) Balance Seller2: ' + web3.utils.fromWei(balanceSeller2.toString()))
            
        })
        it ('Escrow balance is 62', async () => {
            balanceEscrow = await _bossonescrow.checkEscrowBalance(_bossonescrow.address)
            console.log('\t (test console output) Escrow internal balance: ' + web3.utils.fromWei(balanceEscrow.toString()))
            assert.equal(balanceEscrow.toString(), tokens('62'), "Escrow balance should be 62")
            balanceEscrowBossonCoin = await _bossoncoin.balanceOf(_bossonescrow.address)
            assert.equal(balanceEscrowBossonCoin.toString(), tokens('62'), "Escrow balance should be 62")
            console.log('\t (test console output) BossonCoin Escrow account balance:' + web3.utils.fromWei(balanceEscrowBossonCoin.toString()))
        })


    })

})
