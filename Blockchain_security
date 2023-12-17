pragma solidity ^0.8.0;

// PatientRecord contract
contract PatientRecord {
    mapping(address => bool) public authorizedUsers;

    modifier onlyAuthorized() {
        require(authorizedUsers[msg.sender], "Not authorized");
        _;
    }

    // grant access to a user
    function grantAccess(address user) public {
        authorizedUsers[user] = true;
    }

    // revoke access from a user
    function revokeAccess(address user) public {
        authorizedUsers[user] = false;
    }
}
