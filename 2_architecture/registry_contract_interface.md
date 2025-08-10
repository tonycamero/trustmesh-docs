# Trust Slot Registry � Contract Interface (Draft)

- **Purpose:** On-chain guardrails for max 9 active commitments per user; indexer becomes a verifier.

## Storage

- `mapping(address user => uint16 slotsBitmap)` // 9 LSB used
- `mapping(address user => uint64 nonceCounter)`

## Methods

- `commit(bytes32 digest, bytes sig)` ? sets bit for `tokenID` after verifying signature
- `unbond(bytes32 digest, bytes sig)` ? marks slot pending
- `revoke(bytes32 digest, bytes sig)` ? clears bit post-delay
- `checkpoint(bytes32 merkleRoot, bytes32 schemaHash)` ? optional anchoring

## Security

- EIP-191 style signed digests including `chainId`, `topicId`, `nonce`, and `expiry`.
- Replay protection via `nonceCounter`.
