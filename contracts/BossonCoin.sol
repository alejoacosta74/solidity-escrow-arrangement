 pragma solidity >=0.6.0;
 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 //import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/ERC20.sol";
 contract BossonCoin is ERC20 {
     uint256 public constant INITIAL_SUPPLY = 10000000000000000000000;
     
     constructor () public ERC20("Bosson Coin", "BOSSON"){       
        _mint(msg.sender, INITIAL_SUPPLY);
     }
 }