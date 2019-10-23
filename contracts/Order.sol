pragma solidity ^0.5.0;

contract Order {

    address owner;

    struct Item {
        string product;
        uint16 price; // Price in U$D
    }

    uint256 public reward; // Reward in Wei
    uint256 public creation;
    uint256 public expiration;
    uint256 public id;
    string public name; // Order Request Name
    bool public completed;
    Item[] public items;

    event ItemAdded(string _product, uint16 _price);

    constructor(string memory _name, uint256 _reward, uint256 _id, address _owner) public {
        name = _name;
        reward = _reward;
        id = _id;
        owner = _owner;
        creation = now;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "Only the owner can call this function.");
        _;
    }

    function getNumberOfItems() public view returns (uint256) {
        return items.length;
    }

    function addItem(string memory product, uint16 price) public onlyOwner {
        require(bytes(product).length > 0, "Product must have a name.");
        require(price > 0, 'Price must be greater than 0.');

        items.push(Item(product, price));
        emit ItemAdded(product, price);
    }
}