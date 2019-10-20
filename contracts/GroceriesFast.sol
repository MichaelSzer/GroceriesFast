pragma solidity ^0.5.0;

import "./DateTime.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

contract GroceriesFast {

    using SafeMath for uint256;

    DateTime dateTime = new DateTime();

    struct Item {
        string product;
        uint16 price; // Price in U$D
    }

    struct Order {
        Item item;
        uint256 reward; // Reward in Wei
        string name; // Order Request Name
        uint256 creation;
        uint256 expiration;
    }
}