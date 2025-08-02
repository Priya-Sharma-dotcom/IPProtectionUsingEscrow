// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPContract {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    enum IpType { Patent, Copyright, Trademark }

    struct IP {
        string name;
        string description;
        IpType ipType;
        address currentOwner;
        address[] owners;
        bool registered;
        uint price;
    }

    modifier OnlyAdmin() {
        require(msg.sender == admin, "Not the admin");
        _;
    }

    modifier OnlyCurrentOwner(uint id) {
        require(IPs[id].registered, "IP not registered");
        require(msg.sender == IPs[id].currentOwner, "Not current owner");
        _;
    }

    event IpAdded(uint id, address indexed currentOwner);
    event BuyerPaid(uint amount, address indexed buyer);
    event OwnershipTransferred(uint id, address indexed newOwner);
    event RefundIssued(uint id, uint amount, address indexed buyer);

    mapping(uint => IP) public IPs;
    mapping(uint => address) public pendingBuyers;
    uint public ipCounter;

    function registerIP(
        string memory _name,
        string memory _description,
        IpType _ipType,
        uint _price
    ) public OnlyAdmin {
        IP storage prop = IPs[ipCounter];

        prop.name = _name;
        prop.description = _description;
        prop.ipType = _ipType;
        prop.currentOwner = admin;
        prop.owners.push(admin);
        prop.registered = true;
        prop.price = _price;

        emit IpAdded(ipCounter, admin);
        ipCounter++;
    }

    function buyIP(uint id) public payable {
        IP storage prop = IPs[id];
        require(prop.registered, "IP not registered");
        require(msg.sender != address(0), "Invalid buyer address");
        require(msg.sender != prop.currentOwner, "Already owner");
        require(prop.currentOwner != address(0), "Invalid seller");
        require(msg.value == prop.price, "Incorrect amount");

        pendingBuyers[id] = msg.sender;
        emit BuyerPaid(msg.value, msg.sender);
    }

    function refundToBuyer(uint id) public {
        require(pendingBuyers[id] == msg.sender, "Not the pending buyer");
        require(pendingBuyers[id] != address(0), "No buyer to refund");

        address buyer = pendingBuyers[id];
        uint refundAmount = IPs[id].price;

        delete pendingBuyers[id];
        payable(buyer).transfer(refundAmount);

        emit RefundIssued(id, refundAmount, buyer);
    }

    function transferIP(uint id) public OnlyCurrentOwner(id) {
        IP storage prop = IPs[id];
        address buyer = pendingBuyers[id];
        require(buyer != address(0), "No buyer available");

        payable(prop.currentOwner).transfer(prop.price);

        prop.currentOwner = buyer;
        prop.owners.push(buyer);
        prop.price += 0.5 ether;

        delete pendingBuyers[id];
        emit OwnershipTransferred(id, buyer);
    }

    function getIPInfo(uint id)
        public
        view
        returns (
            string memory,
            string memory,
            IpType,
            address,
            address[] memory,
            uint
        )
    {
        IP storage prop = IPs[id];
        return (
            prop.name,
            prop.description,
            prop.ipType,
            prop.currentOwner,
            prop.owners,
            prop.price
        );
    }

    function getCurrentOwner(uint id) public view returns (address) {
        return IPs[id].currentOwner;
    }
}
