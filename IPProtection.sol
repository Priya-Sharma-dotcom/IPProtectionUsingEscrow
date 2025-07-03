// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPProtection {

    enum IPType { Patent, Copyright, Trademark }

    struct IP {
        string description;
        IPType ipType;
        address currentOwner;
        address[] ownershipHistory;
        bool registered;
    }

    uint public ipCounter;
    mapping(uint => IP) public properties;

    event IPRegistered(uint ipID, address owner);
    event OwnershipTransferred(uint ipID, address from, address to);

    modifier OnlyOwner(uint ipID) {
        require(properties[ipID].registered, "IP not registered");
        require(msg.sender == properties[ipID].currentOwner, "You must be the owner to do this action");
        _;
    }

    function registerIP(string memory _description, IPType _ipType) public {
        IP storage newip = properties[ipCounter];
        newip.description = _description;
        newip.ipType = _ipType;
        newip.currentOwner = msg.sender;
        newip.ownershipHistory.push(msg.sender);
        newip.registered = true;

        emit IPRegistered(ipCounter, msg.sender);
        ipCounter++;
    }

    function transferOwnership(uint ipId, address newOwner) public OnlyOwner(ipId) {
        IP storage ip = properties[ipId];
        ip.currentOwner = newOwner;
        ip.ownershipHistory.push(newOwner);

        emit OwnershipTransferred(ipId, msg.sender, newOwner);
    }

    function verifyIP(uint ipId) public view returns (string memory, IPType, address, address[] memory) {
        IP storage ip = properties[ipId];
        require(ip.registered, "IP not registered");
        return (ip.description, ip.ipType, ip.currentOwner, ip.ownershipHistory);
    }

    function getOwner(uint ipID) public view returns (address) {
        IP storage ip = properties[ipID];
        return ip.currentOwner;
    }
}
