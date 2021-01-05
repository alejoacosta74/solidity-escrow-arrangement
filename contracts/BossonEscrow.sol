 pragma solidity >=0.6.0;
 pragma experimental ABIEncoderV2;

 import "@openzeppelin/contracts/access/Ownable.sol";
 import "./BossonCoin.sol";
 
contract BossonEscrow is Ownable {
     string public name = "Bosson escrow contract";
     BossonCoin public bossonCoin;  //Reference to BossoinCoin contract   

     enum ItemState { OFFERED, AWAITING_DELIVERY, COMPLETE }
     
     struct Item{
        uint256 price;
        string  name;
        address  seller;
        address  buyer;        
        uint8  qty;
        bool exists;  
        ItemState state;
              
    } //item published for sale in escrow arragement
    
    mapping (address => uint256) public escrowBalances; //balances from each buyer/seller and escrow account

    mapping (string => Item) public stock; // whole stock of offered items for sell in escrow arragement

    //@dev: constructor for BossonEscrow
    //@params: takes in the address of the BossonCoin contract 
    constructor (BossonCoin _bossonCoin) public Ownable() {
         bossonCoin = _bossonCoin;         
    }
     
     //@dev:  buyer funds are transfered to escrow account (in BossonCoin contract)
     // Buyer balance is incremented in escrow internal balance
     // Escrow balance is incremented in escrow internal balance
     //@params: takes in buyer address and amount to be credited
     function credit (address _buyer, uint256 _amount) public {
        require(bossonCoin.allowance(_buyer, address(this)) >= _amount,
            "Bossonescrow not allowed to transferFrom this buyer"
        ); //Buyer must allow BossonEscrow contract to transfer _amount of bossonCoins to bossonEscrow account
         bossonCoin.transferFrom(_buyer, address(this), _amount);
         escrowBalances[_buyer] = escrowBalances[_buyer] + _amount;
         escrowBalances[address(this)] = escrowBalances[address(this)] + _amount;
     }
     
     //helper function
     function checkEscrowBalance (address buyer ) public view returns (uint256) {
         return escrowBalances[buyer];
     }
     
     //helper function
     function checkCoinBalance (address buyer ) public view returns (uint256) {
         return bossonCoin.balanceOf(buyer);
     }

     //helper function
     function getItem (string memory _itemName) public view returns (Item memory) {
         return stock[_itemName];
     }

     //@dev: buyer places order to buy item. 
     //Item is marked as state AWAITING_DELIVERY 
     //Escrow internal balance for buyer and seller is updated
     //@params: takes in buyer address and name of the item to buy
     function order (address _buyer, string memory _itemName) public onlyOwner {         
         require (stock[_itemName].exists, "Items does not exists");
         require (stock[_itemName].qty >= 0, "Item is out of stock");
         require (escrowBalances[_buyer] >= stock[_itemName].price, "Buyer has no sufficient funds");
         address seller = stock[_itemName].seller;
         escrowBalances[_buyer] = escrowBalances[_buyer] - stock[_itemName].price;
         escrowBalances[seller] = escrowBalances[seller] + stock[_itemName].price;
         stock[_itemName].state = ItemState.AWAITING_DELIVERY;
     }
     
     //@dev: seller puts item for sale. 
     //Item is marked as state OFFERED 
     //Item is added to escrow stock mapping
     //@params: takes in seller address, name of the item, price and quantities to put for sale
     function offer (address _seller , string memory _itemName , uint256 _itemPrice, uint8 _qty) public {
         Item memory item;
         item.name = _itemName;
         item.price = _itemPrice;
         item.qty = _qty;
         item.seller = _seller;
         item.exists = true;
         item.state = ItemState.OFFERED;
         stock[_itemName] = item;
     }
     
     //@dev: buyer confirms reception of item
     // payment is transfered from escrow BossonCoin account to seller BossonCoin account. 
     // Item is marked as state COMPLETE     
     // Escrow balance is decremented in escrow internal balance
     //@params: takes in buyer address and name of the item to buy
     function complete (address _buyer, string memory _itemName) public onlyOwner {        
        address seller = stock[_itemName].seller;
        stock[_itemName].buyer = _buyer;
        stock[_itemName].state = ItemState.COMPLETE;
        bossonCoin.transfer(seller, stock[_itemName].price);
        escrowBalances[address(this)] = escrowBalances[address(this)] - stock[_itemName].price ;
        escrowBalances[seller] = escrowBalances[seller] - stock[_itemName].price ;
     }
     
     //@dev: buyer did not receive item and 
     //Escrow internal balance for buyer and seller is updated
     // Item is reverted back to state OFFERED
     //@params: takes in buyer address and name of the item to buy
     function complain (address _buyer ,string memory _itemName) public onlyOwner {         
         address seller = stock[_itemName].seller;
         stock[_itemName].buyer = address(0);
         stock[_itemName].state = ItemState.OFFERED;
         escrowBalances[_buyer] = escrowBalances[_buyer] + stock[_itemName].price;
         escrowBalances[seller] = escrowBalances[seller] - stock[_itemName].price;         
         
     }
 }