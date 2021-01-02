 pragma solidity >=0.6.0;
 pragma experimental ABIEncoderV2;

 import "@openzeppelin/contracts/access/Ownable.sol";
 import "./BossonCoin.sol";
 
contract BossonEscrow is Ownable {
     string public name = "Bosson escrow contract";
     BossonCoin public bossonCoin;     
     
    struct Item{
        uint256 price;
        string  name;
        address  seller;
        address  buyer;
        string imgurl;
        uint8  qty;
        bool  exists;
    } //items published for sale
    
    mapping (address => uint256) public escrowBalances; //escrow funds from each buyer/seller account

    mapping (string => Item) public stock; //stock of offered items for sell 
     
     constructor (BossonCoin _bossonCoin) public Ownable() {
         bossonCoin = _bossonCoin;         
     }
     
     //buyer allows funds to be transfered to escrow account
     function credit (address _buyer, uint256 _amount) public {
        require(bossonCoin.allowance(_buyer, address(this)) >= _amount,
            "Bossonescrow not allowed to transferFrom this buyer"
        );
         bossonCoin.transferFrom(_buyer, address(this), _amount);
         escrowBalances[_buyer] = escrowBalances[_buyer] + _amount;
     }
     
     function checkescrowBalance (address buyer ) public view returns (uint256) {
         return escrowBalances[buyer];
     }
     
    function checkCoinBalance (address buyer ) public view returns (uint256) {
         return bossonCoin.balanceOf(buyer);
     }

     function getItem (string memory _itemName) public view returns (Item memory) {
         return stock[_itemName];
     }

     
     //buyer places order to buy item
     function order (address _buyer, string memory _itemName) public onlyOwner {
         Item memory item = stock[_itemName];         
         require (item.exists, "Items does not exists");
         require (item.qty >= 0, "Item is out of stock");
         require (escrowBalances[_buyer] >= item.price, "Buyer has no sufficient funds");
         address seller = item.seller;
         escrowBalances[_buyer] = escrowBalances[_buyer] - item.price;
         escrowBalances[seller] = escrowBalances[seller] + item.price;
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
     
     //buyer confirms reception of item and payment to seller
     function complete (address _buyer, string memory _itemName) public onlyOwner {        
        address seller = stock[_itemName].seller;
        stock[_itemName].buyer = _buyer;
        bossonCoin.transfer(seller, stock[_itemName].price);
     }
     
     //buyer did not receive item and payment is refunded from escrow to buyer
     function complain (address _buyer ,string memory _itemName) public onlyOwner {         
         address seller = stock[_itemName].seller;
         stock[_itemName].buyer = address(0);
         escrowBalances[_buyer] = escrowBalances[_buyer] + stock[_itemName].price;
         escrowBalances[seller] = escrowBalances[seller] - stock[_itemName].price;         
         
     }
 }