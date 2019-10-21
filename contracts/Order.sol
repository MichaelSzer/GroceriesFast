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

    modifier onlyOwner(address addr){
        require(owner == addr, "Only the owner can call this function.");
        _;
    }

    constructor(string memory _name, uint256 _reward, uint256 _id, address _owner) public {
        name = _name;
        reward = _reward;
        id = _id;
        owner = _owner;
    }
}