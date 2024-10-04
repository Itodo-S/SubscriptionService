// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionService {
    address public owner;
    uint public subscriptionFee;
    uint public subscriptionDuration;

    struct Subscriber {
        uint expiry;
    }

    mapping(address => Subscriber) public subscribers;

    event SubscriptionPurchased(address indexed user, uint expiry);
    event SubscriptionRenewed(address indexed user, uint newExpiry);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    constructor(uint _fee, uint _duration) {
        owner = msg.sender;
        subscriptionFee = _fee;  // Fee in wei
        subscriptionDuration = _duration;  // Duration in seconds
    }

    // Purchase a new subscription
    function purchaseSubscription() public payable {
        require(msg.value == subscriptionFee, "Incorrect payment");
        require(subscribers[msg.sender].expiry < block.timestamp, "Already subscribed");

        subscribers[msg.sender].expiry = block.timestamp + subscriptionDuration;
        emit SubscriptionPurchased(msg.sender, subscribers[msg.sender].expiry);
    }

    // Renew an existing subscription
    function renewSubscription() public payable {
        require(msg.value == subscriptionFee, "Incorrect payment");
        require(subscribers[msg.sender].expiry >= block.timestamp, "Subscription has expired");

        subscribers[msg.sender].expiry += subscriptionDuration;
        emit SubscriptionRenewed(msg.sender, subscribers[msg.sender].expiry);
    }

    // Check if a user has an active subscription
    function hasActiveSubscription(address _user) public view returns (bool) {
        return subscribers[_user].expiry >= block.timestamp;
    }

    // Owner can withdraw funds
    function withdrawFunds() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Change subscription fee
    function setSubscriptionFee(uint _fee) public onlyOwner {
        subscriptionFee = _fee;
    }

    // Change subscription duration
    function setSubscriptionDuration(uint _duration) public onlyOwner {
        subscriptionDuration = _duration;
    }
}
