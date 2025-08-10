# Trust Slot Registry � Contract Interface (Draft)

**Purpose:** On-chain guardrails for max **9 active commitments** per user; indexers verify and checkpoint.

## Storage
- `mapping(address user => uint16 slotsBitmap)`  // 9 LSB used
- `mapping(address user => uint64 nonceCounter)`

## Methods
- `commit(bytes32 digest, bytes sig)` � sets bit for `slotID` after verifying signature
- `unbond(bytes32 digest, bytes sig)` � marks slot pending (quiet unbond)
- `revoke(bytes32 digest, bytes sig)` � clears bit post-delay and sets `cooldownUntil`
- `checkpoint(bytes32 merkleRoot, bytes32 schemaHash)` � optional anchor to contract

## Security
- EIP-191 style digests include `{ chainId, topicId, slotID, nonce, expiry }`.
- Replay protection via `nonceCounter`.
- Contract SHOULD emit events mirrored by the HCS reducer for third-party verification.
