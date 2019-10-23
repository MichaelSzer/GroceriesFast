pragma solidity ^0.5.0;

import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

contract Order {

    using SafeMath for uint256;

    struct Item {
        string product;
        uint16 price; // Price in U$D
    }

    address owner;
    uint256 public reward; // Reward in Wei
    uint256 public creation;
    uint256 public expiration;
    uint256 public id;
    uint256 public cost;
    string public name; // Order Request Name
    bool public completed;
    bool public ongoing;
    bool public started;
    Item[] public items;

    event ItemAdded(string _product, uint16 _price);

    constructor(string memory _name, uint256 _reward, uint256 _id, address _owner) public {
        name = _name;
        reward = _reward;
        id = _id;
        owner = _owner;
        creation = now;
        ongoing = true;
        started = false;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "Only the owner can call this function.");
        _;
    }

    modifier orderReady {
        require(address(this).balance >= cost, "Owner has not send enough money to complete this order.");
        _;
    }

    modifier isOrderOngoing {
        require(ongoing, "This order is not ongoing.");
        _;
    }

    modifier orderNotStarted {
        require(!started, "Order has started.");
        _;
    }

    function getNumberOfItems() public view returns (uint256) {
        return items.length;
    }

    function addItem(string memory product, uint16 price) public onlyOwner isOrderOngoing {
        require(bytes(product).length > 0, "Product must have a name.");
        require(price > 0, 'Price must be greater than 0.');

        cost = cost.add(price);
        items.push(Item(product, price));

        emit ItemAdded(product, price);
    }

    function startOrder() public orderNotStarted orderReady {
        started = true;
    }

    function() external payable onlyOwner {
        require(msg.data.length == 0, "Invalid function was called."); // Prevent invalid calls
    }
}