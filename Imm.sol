pragma solidity ^0.8.0;

contract PatientRecords {
    struct Record {
        string data;
        uint256 timestamp;
    }

    mapping(address => Record[]) public patientRecords;

    function addRecord(string memory data) public {
        // new record with current timestamp
        Record memory newRecord = Record({
            data: data,
            timestamp: block.timestamp
        });

        // new record to the patient's records
        patientRecords[msg.sender].push(newRecord);
    }

    function getRecordsCount(address patient) public view returns (uint256) {
        return patientRecords[patient].length;
    }
}
