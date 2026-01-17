#!/usr/bin/env python3
"""
GRN Firmware Simulation

Simulates Ground Reception Node firmware for beam authorization.
"""

import hashlib
import hmac
import time
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import rsa, padding

class GRN:
    def __init__(self, node_id, private_key):
        self.node_id = node_id
        self.private_key = private_key
        self.session_key = None
        self.heartbeat_interval = 0.05  # 50 ms

    def generate_beacon(self):
        """Generate beacon message with signature."""
        timestamp = str(time.time())
        message = f"{self.node_id}:{timestamp}"
        signature = self.private_key.sign(
            message.encode(),
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        return {
            'id': self.node_id,
            'pubkey': self.private_key.public_key(),
            'sig': signature.hex(),
            'timestamp': timestamp
        }

    def receive_session_key(self, encrypted_key):
        """Decrypt and store session key."""
        # Simplified: assume key is pre-shared for sim
        self.session_key = encrypted_key

    def send_ready(self, nonce):
        """Send ready signal with nonce."""
        return {'nonce': nonce}

    def heartbeat(self):
        """Send periodic heartbeat."""
        return {'heartbeat': time.time()}

# Example usage
if __name__ == "__main__":
    # Generate keys (in real firmware, use PUF)
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048
    )

    grn = GRN(node_id="GRN-001", private_key=private_key)
    beacon = grn.generate_beacon()
    print("Beacon generated:", beacon['id'])
