pragma solidity^0.6.1;

contract Item{
    string name;
    address payable public  owner;
    address payable bidder;
    uint Bid;

    constructor(string memory _name, uint price) public{
        owner = msg.sender;
        bidder = owner;
        Bid = price;
        name = _name;

    }

    function getBid() public view returns(uint){
        return Bid;
    }


    function setBid(uint _value) external{
        Bid = _value;
    }

    function setBidder(address payable newBidder) external{
        bidder = newBidder;
    }

    function getBidder() public view returns(address payable){
        return bidder;
    }

    function getOwner() public view returns(address payable){
        return owner;
    }

    function sell(address payable newOwner) public{
        owner = newOwner;
    }

}

contract Auction{
    Item internal itemOnSale;
    uint timeLimit;
    uint startTime;
    bool initialBid; // true when at least one bid was made
    bool selling;

    constructor() public{
        selling = false;
    }

    function putItemOnSale(Item _item, uint _timeLimit) public returns(bool){
        if(selling) return false;

        startTime = block.timestamp;
        itemOnSale = _item;
        selling = true;
        initialBid = false;
        timeLimit = _timeLimit;
        return true;

    }

    function whatsOnSale() public view returns(Item){
        if(selling) return itemOnSale;
    }



    function bid() public payable returns(bool){
        if(selling && msg.value > itemOnSale.getBid()){
            initialBid = true;
            itemOnSale.getBidder().transfer(itemOnSale.getBid()); // return money back to previous bidder
            // set new bidder
            itemOnSale.setBidder(msg.sender) ;
            itemOnSale.setBid(msg.value);
            return true;
        } else{
            msg.sender.transfer(msg.value); // return the money
            return false;
        }
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function endAuction() public returns(bool){ // Auction can be stopped by the owner anytime or by anyone when the limit is exceeded
        if( initialBid && (msg.sender == itemOnSale.getOwner() || block.timestamp > startTime + timeLimit)){
            itemOnSale.getOwner().transfer(address(this).balance);
            itemOnSale.sell(itemOnSale.getBidder());
            selling = false;
            return true;
        } selling = false;
        return false;
    }
}
