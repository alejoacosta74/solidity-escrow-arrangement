# Boson Protocol Escrow Arrangement

This repository contains the project source code and dependencies required to deploy a ESCROW ARRANGEMENT in Ethereum development network.

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## Description

### Project description
This project implements a simple escrow arrangement in Ethereum network.

The escrow is deployed with the following 2 Ethereum smart contracts written in solidity:

#### BossonCoin.sol
This contract defines the token ('bossonCoin') that is used used witin the escrow arrangement to fund account and execute transactions

BossonCoin.sol inherits the standard ERC20 from [OpenZeppelin/ERC20](https://docs.openzeppelin.com/contracts/3.x/erc20), and is initialy minted with 100 coins.

#### BossonEscrow.sol
This contract defines all the 'business logic' of the escrow arrangement.

BossonEscrow.sol inherits the Ownable interface from [OpenZeppelin/access/Ownable](https://docs.openzeppelin.com/contracts/3.x/api/access#Ownable) to ensure that only the escrow agent is allowed to perform changes to the contract state varables, such as balances. 

Functions | Description
--- | ---
`Credit()` | *Transfer BossonCoins from Buyer account to BossonEscrow account*
`Order()` | *Checks Buyer has enough funds on escrow and item availability. Updates internal escrow balances for Buyer and Seller according to item price*
`Offer()` | *Creates a new item for sale and adds it to the BossonScrow mapping of stock*
`Complete()` | *Transfer BossonCoins from BossonEscrow account to Seller account. Updates item ownership to Buyer*
`Complain()` | *Reverts internal escrow balances for Buyer and Seller account according to item price*




### Dependencies

  - Source code language: Solidity  - 
  - Development environment: Node.js / NPM / Truffle / Ganache
  - Testing: Truffle / Mocha / Chai

### Description of files
### How it all fits together

## Installation

Clone repository and install the dependencies and devDependencies:

```sh
$ npm install -g truffle
$ npm install -g ganache-cli
$ cd bossonEscrow
$ npm init
```


## Usage

Start ganache-cli development ethereum network:
```sh
$ ganache-cli -d 10000000 --allowUnlimitedContractSize --gasLimit=0x1FFFFFFFF
```
Compile and deploy solidity contracts to Ganache development network:

```sh
$ truffle compile
$ truffle migrate
```
# Test
Execute truffle test from command prompt:

```sh
$ truffle test
```

Expected output:

```bash
$:~/ethereum/bosson$ truffle test
Using network 'development'.


Compiling your contracts...
===========================
✔ Fetching solc version list from solc-bin. Attempt #1
> Everything is up to date, there is nothing to compile.



  Contract: bosson escrow contract
    BossonCoin deployment
      ✓ has a name (223ms)
      ✓ transfer 100 coins to buyer1 (296ms)
      ✓ updated balance of BossonCoin contract owner after funding buyer1 and buyer2 (81ms)
    BossoneScrow deployment
      ✓ has a name (90ms)
      ✓ Seller1 offers coffe for 3 coins (314ms)
      ✓ Escrow agent should not be able to transfer without buyer allowance (186ms)
      ✓ transfers BossonCoins from buyer1 to Escrow account (429ms)
      ✓ Buyer places order to buy coffee (401ms)
Item coffee: 3,coffee,0xd03ea8624C8C5987235048901fB614fDcA89b117,0x22d491Bde2303f2f43325b2108D26f1eAbA1e32b,,10,true
      ✓ Buyer confirms coffee payment (386ms)


  9 passing (3s)

```
## License
[MIT](https://choosealicense.com/licenses/mit/