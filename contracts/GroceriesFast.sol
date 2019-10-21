pragma solidity ^0.5.0;

import "./DateTime.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";
import "./Order.sol";

contract GroceriesFast {

    using SafeMath for uint256;

    DateTime dateTime = new DateTime();

    uint256 MIN_REWARD = 0.01 ether;

    uint256 numOrders;
    mapping(uint256 => address) orders;

    event OrderCreated(string _name, uint256 indexed _id);
    event ItemAdded(uint256 indexed _id, string _product, uint16 _price);

    modifier checkReward(uint256 _reward) {
        require(MIN_REWARD <= _reward, "Reward must be at least 0.01 ether.");
        _;
    }

    function createOrder(string memory name, uint256 reward) public checkReward(reward) returns (uint256 _id) {
        Order newOrder = new Order(name, reward, numOrders, msg.sender);
        orders[numOrders] = address(newOrder);
        _id = numOrders;

        numOrders = numOrders.add(1);

        emit OrderCreated(name, _id);
    }

    function addItem(uint256 id, string memory product, uint16 price) public {
        require(bytes(product).length > 0, "Product must have a name.");
        require(price > 0, 'Price must be greater than 0.');

        Order order = Order(orders[id]);
        order.addItem(product, price, msg.sender);

        emit ItemAdded(id, product, price);
    }

    function getOrderAddress(uint256 id) public view returns (address) {
        return orders[id];
    }
}