// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.19;

/**
 * Beam Authorization Smart Contract for Heliosphere
 *
 * Manages cryptographic beam authorization between MOR and GRN nodes.
 * Implements 2-of-3 consent requirement for beam activation.
 *
 * Deployed on Ethereum L2 (e.g., OP Stack) or Celestia DA for low-cost verification.
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract BeamAuth is Ownable {
    using ECDSA for bytes32;

    struct Node {
        address pubkey;
        uint256 registeredAt;
        bool isActive;
        uint8 nodeType; // 0: GRN, 1: MOR, 2: DAO
    }

    struct BeamSession {
        bytes32 sessionId;
        address grnId;
        address morId;
        uint256 startedAt;
        uint256 lastHeartbeat;
        bool isActive;
        uint256 powerAllocated; // in watts
    }

    mapping(address => Node) public nodes;
    mapping(bytes32 => BeamSession) public sessions;
    mapping(address => bytes32) public activeSessions; // GRN -> sessionId

    uint256 public constant HEARTBEAT_TIMEOUT = 100; // 100 seconds
    uint256 public constant MAX_POWER_DENSITY = 1000; // 1 kW/m²

    event NodeRegistered(address indexed nodeId, uint8 nodeType);
    event BeamActivated(bytes32 indexed sessionId, address grnId, address morId);
    event BeamDeactivated(bytes32 indexed sessionId, string reason);
    event HeartbeatReceived(bytes32 indexed sessionId);

    modifier onlyRegisteredNode() {
        require(nodes[msg.sender].isActive, "Node not registered");
        _;
    }

    modifier onlyMOR() {
        require(nodes[msg.sender].nodeType == 1, "Only MOR nodes allowed");
        _;
    }

    modifier onlyDAO() {
        require(nodes[msg.sender].nodeType == 2, "Only DAO nodes allowed");
        _;
    }

    /**
     * Register a new node (GRN, MOR, or DAO)
     */
    function registerNode(address nodeId, uint8 nodeType) external onlyOwner {
        require(nodeType <= 2, "Invalid node type");
        require(!nodes[nodeId].isActive, "Node already registered");

        nodes[nodeId] = Node({
            pubkey: nodeId,
            registeredAt: block.timestamp,
            isActive: true,
            nodeType: nodeType
        });

        emit NodeRegistered(nodeId, nodeType);
    }

    /**
     * Initiate beam authorization (Step 1: GRN broadcasts beacon)
     */
    function initiateBeamAuth(
        address grnId,
        bytes memory signature,
        uint256 timestamp,
        uint256 requestedPower
    ) external onlyRegisteredNode returns (bytes32) {
        require(nodes[grnId].nodeType == 0, "Must be GRN node");
        require(requestedPower <= MAX_POWER_DENSITY * 1000000, "Power exceeds safety limit"); // Assume 1 km² area

        // Verify signature
        bytes32 messageHash = keccak256(abi.encodePacked(grnId, timestamp));
        address recoveredSigner = messageHash.toEthSignedMessageHash().recover(signature);
        require(recoveredSigner == grnId, "Invalid signature");

        // Create session ID
        bytes32 sessionId = keccak256(abi.encodePacked(grnId, msg.sender, block.timestamp));

        sessions[sessionId] = BeamSession({
            sessionId: sessionId,
            grnId: grnId,
            morId: msg.sender,
            startedAt: block.timestamp,
            lastHeartbeat: block.timestamp,
            isActive: false, // Not yet activated
            powerAllocated: requestedPower
        });

        return sessionId;
    }

    /**
     * Complete beam authorization (Step 2-3: MOR + DAO approve)
     */
    function authorizeBeam(bytes32 sessionId, bytes memory morSig, bytes memory daoSig) external onlyDAO {
        BeamSession storage session = sessions[sessionId];
        require(!session.isActive, "Session already active");
        require(block.timestamp - session.startedAt < 300, "Auth request expired"); // 5 min timeout

        // Verify MOR signature
        bytes32 authHash = keccak256(abi.encodePacked(sessionId, "authorize"));
        address morSigner = authHash.toEthSignedMessageHash().recover(morSig);
        require(morSigner == session.morId, "Invalid MOR signature");

        // Verify DAO signature (this contract's owner or designated DAO)
        address daoSigner = authHash.toEthSignedMessageHash().recover(daoSig);
        require(daoSigner == owner(), "Invalid DAO signature");

        // Activate beam
        session.isActive = true;
        activeSessions[session.grnId] = sessionId;

        emit BeamActivated(sessionId, session.grnId, session.morId);
    }

    /**
     * Send heartbeat to maintain beam (GRN calls this every 50ms)
     */
    function sendHeartbeat(bytes32 sessionId) external {
        BeamSession storage session = sessions[sessionId];
        require(session.isActive, "Session not active");
        require(msg.sender == session.grnId, "Only GRN can send heartbeat");

        session.lastHeartbeat = block.timestamp;
        emit HeartbeatReceived(sessionId);
    }

    /**
     * Check if beam should be deactivated (MOR calls this periodically)
     */
    function checkBeamStatus(bytes32 sessionId) external view returns (bool shouldDeactivate, string memory reason) {
        BeamSession memory session = sessions[sessionId];
        if (!session.isActive) {
            return (false, "Session not active");
        }

        if (block.timestamp - session.lastHeartbeat > HEARTBEAT_TIMEOUT) {
            return (true, "Heartbeat timeout");
        }

        // Additional safety checks could be added here
        // e.g., verify power density, atmospheric conditions, etc.

        return (false, "");
    }

    /**
     * Emergency beam deactivation (any registered node can call)
     */
    function emergencyDeactivate(bytes32 sessionId, string memory reason) external onlyRegisteredNode {
        BeamSession storage session = sessions[sessionId];
        require(session.isActive, "Session not active");

        session.isActive = false;
        delete activeSessions[session.grnId];

        emit BeamDeactivated(sessionId, reason);
    }

    /**
     * Get active session for a GRN
     */
    function getActiveSession(address grnId) external view returns (bytes32) {
        return activeSessions[grnId];
    }

    /**
     * Get session details
     */
    function getSession(bytes32 sessionId) external view returns (
        address grnId,
        address morId,
        uint256 startedAt,
        uint256 lastHeartbeat,
        bool isActive,
        uint256 powerAllocated
    ) {
        BeamSession memory session = sessions[sessionId];
        return (
            session.grnId,
            session.morId,
            session.startedAt,
            session.lastHeartbeat,
            session.isActive,
            session.powerAllocated
        );
    }
}
