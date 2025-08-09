# State Spec v0.1

## Event Types
- `ALLOCATE` — mint/enable slots `0..8` for `userPubKey`
- `COMMIT` — bind `tokenID` to `recipientHash` with `tag`, optional `reasonHash`
- `UNBOND` — start quiet-unbond timer for `tokenID`
- `REVOKE` — finalize removal of an active commitment (post-delay)
- `RECOVER` — rotate keys/guardians; includes previous key, new key, and proof
- *(Optional)* `VERIFY` — device/passkey attestation record
- *(Optional)* `REKEY` — cohort pepper rotation announcement

## Required Fields (all events)
`{ schema: "trustmesh/state/0.1", chainId, topicId, txId, ts, userPubKey, tokenID, nonce, sig }`

Plus per-type fields:
- `COMMIT`: `{ recipientHash, tag, reasonHash?, cooldownUntil? }`
- `UNBOND`: `{ tokenID, unbondAt }`
- `REVOKE`: `{ tokenID, revokeAt }`
- `RECOVER`: `{ oldPubKey, newPubKey, guardians[], proof }`

## Rules
- **Idempotency:** `(userPubKey, tokenID, nonce)` unique.
- **Validity:** tokenID ? [0..8]; only one active commitment per tokenID.
- **Cooldown:** per-slot; `COMMIT` invalid if now < `cooldownUntil`.
- **Ordering:** indexers must process by `(ts, txId)`; ties broken by `txId`.

## Checkpointing
- Indexers produce hourly Merkle roots over deterministic state.
- Publish `{ merkleRoot, schemaHash, height, ts }` to a dedicated HCS topic.
