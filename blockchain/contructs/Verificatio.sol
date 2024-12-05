// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Verification {
    address public owner;
    uint16 public countExporters = 0;
    uint16 public countHashes = 0;
    
    constructor() {
        owner = msg.sender;
    }

    struct Record {
        uint blockNumber;
        uint timestamp;
        string info;
        string ipfsHash;
        uint version;
        uint exporterID;
    }
    
    struct Exporter {
        uint blockNumber;
        uint exporterID;
        string info;
    }

    mapping (bytes32 => Record) private docHashes;
    mapping (address => Exporter) private exporters;
    mapping (address => uint) private exporterIDs;

    event ExporterAdded(address indexed exporter, string info);
    event ExporterModified(address indexed exporter, string newInfo);
    event HashAdded(address indexed exporter, string ipfsHash, uint version);
    event HashUpdated(address indexed exporter, string ipfsHash, uint version);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    modifier onlyAuthorizedExporter(bytes32 _doc) {
        require(exporterIDs[msg.sender] == docHashes[_doc].exporterID, "Not authorized to modify this document");
        _;
    }

    modifier canAddHash() {
        require(exporters[msg.sender].blockNumber != 0, "Not authorized to add documents");
        _;
    }

    function addExporter(address _addr, string calldata _info) external onlyOwner validAddress(_addr) {
        require(exporters[_addr].blockNumber == 0, "Exporter already exists");
        uint newID = countExporters + 1;
        exporters[_addr] = Exporter(block.number, newID, _info);
        exporterIDs[_addr] = newID;
        countExporters++;
        emit ExporterAdded(_addr, _info);
    }

    function modifyExporter(address _addr, string calldata _newInfo) external onlyOwner validAddress(_addr) {
        require(exporters[_addr].blockNumber != 0, "Exporter does not exist");
        exporters[_addr].info = _newInfo;
        emit ExporterModified(_addr, _newInfo);
    }

    function addDocHash(bytes32 hash, string calldata _ipfs) external canAddHash {
        require(docHashes[hash].blockNumber == 0, "Document hash already exists");
        Record memory newRecord = Record(block.number, block.timestamp, exporters[msg.sender].info, _ipfs, 1, exporterIDs[msg.sender]);
        docHashes[hash] = newRecord;
        countHashes++;
        emit HashAdded(msg.sender, _ipfs, newRecord.version);
    }

    function updateDocHash(bytes32 hash, string calldata _ipfs) external onlyAuthorizedExporter(hash) {
        require(docHashes[hash].blockNumber != 0, "Document does not exist");
        docHashes[hash].version++;
        docHashes[hash].ipfsHash = _ipfs;
        emit HashUpdated(msg.sender, _ipfs, docHashes[hash].version);
    }

    function getDocHash(bytes32 hash) external view returns (uint, uint, string memory, string memory, uint) {
        Record storage record = docHashes[hash];
        return (record.blockNumber, record.timestamp, record.info, record.ipfsHash, record.version);
    }

    function getExporterInfo(address _addr) external view returns (string memory, uint) {
        return (exporters[_addr].info, exporterIDs[_addr]);
    }

    function changeOwner(address _newOwner) external onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
    }
}
