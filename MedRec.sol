pragma solidity ^0.8.0;

contract MedRec {
    address public admin;
    mapping(address => Patient) public patients;

    enum Role {Admin, Doctor, Patient}
    mapping(address => Role) public userRoles;

    struct Patient {
        bool isPatient;
        string name;
        string[] records;
    }

    // only for registered admin 
    modifier onlyAdmin() {
        require(userRoles[msg.sender] == Role.Admin, "Not authorized");
        _;
    }

    modifier onlyPatient() {
        require(userRoles[msg.sender] == Role.Patient, "Not a registered patient");
        _;
    }

    // Circuit breaker for emergency stops
    bool public emergencyStop = false;

    modifier stopInEmergency() {
        require(!emergencyStop, "Contract is paused");
        _;
    }

    // Event to log medical record additions
    event RecordAdded(address indexed patient, string record);

    // Constructor sets the admin 
    constructor() {
        admin = msg.sender;
        userRoles[admin] = Role.Admin;
    }

    // Register a patient
    function registerPatient(string memory _name) public {
        require(!patients[msg.sender].isPatient, "Patient already registered");
        patients[msg.sender] = Patient(true, _name, new string[](0));
        userRoles[msg.sender] = Role.Patient;
    }

    // Add a medical record
    function addRecord(string memory _record) public onlyAdmin stopInEmergency {
        patients[msg.sender].records.push(_record);
        emit RecordAdded(msg.sender, _record);
    }

    // Get medical records
    function getRecords() public view onlyPatient returns (string[] memory) {
        return patients[msg.sender].records;
    }

    // Grant admin role
    function grantAdminRole(address _user) public onlyAdmin {
        userRoles[_user] = Role.Admin;
    }

    // Toggle emergency stop
    function toggleEmergencyStop() public onlyAdmin {
        emergencyStop = !emergencyStop;
    }
}
