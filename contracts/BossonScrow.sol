 pragma solidity >=0.6.0;
 import "@openzeppelin/contracts/access/Ownable.sol";
 
 
 contract BossonScrow {
     string public name = "Bosson scrow contract";
     BossonCoin public bossonCoin;
     address public owner; //owner of BossonScrow contract
     
    struct Item{
        uint256 price;
        string  name;
        address  seller;
        address  buyer;
        string imgurl;
        uint8  qty;
        bool  exists;
    }
    
    mapping (address => uint256) public scrowBalances; //holds scrow funds from each buyer/seller account
    mapping (string => Item) public stock; //keeps stock of offered items for sell 
     
     constructor (BossonCoin _bossonCoin) public {
         bossonCoin = _bossonCoin;
         owner = msg.sender;
     }
     
     //buyer transfer funds to scrow account
     function credit (address _buyer, uint256 _amount) public {
        require(bossonCoin.allowance(_buyer, address(this)) >= _amount,
            "BossonScrow not allowed to transferFrom this buyer"
        );
         bossonCoin.transferFrom(_buyer, address(this), _amount);
         scrowBalances[_buyer] = scrowBalances[_buyer] + _amount;
     }
     
     function checkScrowBalance (address buyer ) public view returns (uint256) {
         return scrowBalances[buyer];
     }
     
    function checkCoinBalance (address buyer ) public view returns (uint256) {
         return bossonCoin.balanceOf(buyer);
     }

     
     //buyer places order to buy item
     function order (address _buyer, string memory _itemName) public {
         Item memory item = stock[_itemName];
         require (msg.sender == owner, "Only BossonScrow allowed to transfer scrow balances");
         require (item.exists, "Items does not exists");
         require (item.qty >= 0, "Item is out of stock");
         require (scrowBalances[_buyer] >= item.price, "Buyer has no sufficient funds");
         address seller = item.seller;
         scrowBalances[_buyer] = scrowBalances[_buyer] - item.price;
         scrowBalances[seller] = scrowBalances[seller] + item.price;
     }
     
     //seller puts item for sale
     function offer (address _seller , string memory _itemName , uint256 _itemPrice, uint8 _qty) public {
         Item memory item;
         item.name = _itemName;
         item.price = _itemPrice;
         item.qty = _qty;
         item.seller = _seller;
         item.exists = true;
         stock[_itemName] = item;
     }
     
     //buyer confirms reception and purchase of item
     function complete (address _buyer, string memory _itemName) public{
        Item memory item = stock[_itemName];
        require (msg.sender == owner, "Only BossonScrow allowed to transfer scrow coins");
        address seller = item.seller;
        item.buyer = _buyer;
        bossonCoin.transfer(seller, item.price);
     }
     
     //buyer did not receive item and payment is refunded from scrow to buyer
     function complain (address _buyer ,string memory _itemName) public {
         Item memory item = stock[_itemName];
         require (msg.sender == owner, "Only BossonScrow allowed to transfer scrow balances");
         address seller = item.seller;
         scrowBalances[_buyer] = scrowBalances[_buyer] + item.price;
         scrowBalances[seller] = scrowBalances[seller] - item.price;         
         
     }
 }