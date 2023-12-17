pragma solidity ^0.8.0;
import "./Access.sol";
import "./Imm.sol";
import "./MedRec.sol";

contract MedicationTraceability {
    address public manufacturer;
    address public distributor;
    address public pharmacy;

    mapping(address => bool) public isAuthorized;
    mapping(string => bool) public drugsShipped;
    mapping(string => bool) public drugsDispensed;

    event DrugAdded(string drugName);
    event DrugShipped(string drugName);
    event DrugDispensed(string drugName);

    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender], "Not authorized");
        _;
    }

    constructor(address _distributor, address _pharmacy) {
        manufacturer = msg.sender;
        distributor = _distributor;
        pharmacy = _pharmacy;
        isAuthorized[manufacturer] = true;
        isAuthorized[distributor] = true;
        isAuthorized[pharmacy] = true;
    }

    function authorize(address _entity) public {
        require(msg.sender == manufacturer, "Only manufacturer can authorize");
        isAuthorized[_entity] = true;
    }

    function addDrug(string memory _drugName) public onlyAuthorized {
        require(!drugsShipped[_drugName] && !drugsDispensed[_drugName], "Drug already in transit or dispensed");
        // Add drug 
        emit DrugAdded(_drugName);
    }

    function shipToDistributor(string memory _drugName) public onlyAuthorized {
        require(!drugsShipped[_drugName] && !drugsDispensed[_drugName], "Drug already in transit or dispensed");

        // manufacturer to distributor
        drugsShipped[_drugName] = true;

        emit DrugShipped(_drugName);
    }

    function dispenseToPharmacy(string memory _drugName) public onlyAuthorized {
        require(drugsShipped[_drugName] && !drugsDispensed[_drugName], "Drug not shipped or already dispensed");

        // distributor to pharmacy
        drugsShipped[_drugName] = false;
        drugsDispensed[_drugName] = true;

        emit DrugDispensed(_drugName);
    }
}
