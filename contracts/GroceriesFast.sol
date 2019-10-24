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
    address owner;
    bool finished;

    event OrderCreated(string _name, uint256 indexed _id);

    modifier checkReward(uint256 _reward) {
        require(MIN_REWARD <= _reward, "Reward must be at least 0.01 ether.");
        _;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "This function can only be called by the owner of the contract");
        _;
    }

    modifier finishedContract {
        require(!finished, "Contract was finished.");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function createOrder(string memory name, uint256 reward) public finishedContract checkReward(reward) returns (uint256 _id) {
        Order newOrder = new Order(name, reward, numOrders, msg.sender);
        orders[numOrders] = address(newOrder);
        _id = numOrders;

        numOrders = numOrders.add(1);

        emit OrderCreated(name, _id);
    }

    function getOrderAddress(uint256 id) public view returns (address) {
        return orders[id];
    }

    function finishContract() public onlyOwner {
        finished = true;
    }
}