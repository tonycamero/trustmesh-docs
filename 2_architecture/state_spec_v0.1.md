# State Spec v0.1

## Event Types
- `ALLOCATE` — enable 9 DBT slots for `userPubKey`
- `COMMIT` — bind `slotID` → `recipientHash` with `tag`, optional `reasonHash`
- `UNBOND` — start quiet-unbond timer (`unbondAt`)
- `REVOKE` — finalize removal post-delay; frees slot; sets `cooldownUntil`
- `RECOVER` — rotate keys/guardians: `{ oldPubKey, newPubKey, guardians[], proof }`
- `VERIFY_DEVICE` — device/passkey attestation record (Magic.link)
- `CONTACT_ADD` — `{ ownerId, contactId, channel, ts }`
- `CONTACT_REMOVE` — remove contact
- `REKEY` — cohort pepper rotation announcement
- `CHECKPOINT` — indexer announces `{ merkleRoot, schemaHash, height, ts }` to checkpoint topic

## Required Fields (all events)
{ schema:"trustmesh/state/0.1", chainId, topicId, txId, ts,
  userPubKey, slotID?, nonce, sig, cohortId, pepperVersion }

## Rules
- **Idempotency:** `(userPubKey, (slotID|eventKey), nonce)` unique
- **Slots:** `slotID → [0..8]`; **one active commitment per slot**
- **Quiet Unbonding:** default **72h** between `UNBOND` and `REVOKE`
- **Cooldown:** per-slot; default **14 days**; `COMMIT` invalid if `now < cooldownUntil`
- **Contacts:** unlimited; private by default; low weight (policy below)
- **Ordering:** reduce by `(ts, txId)`; tie-break on `txId`
- **Checkpoint cadence:** **hourly** Merkle to dedicated HCS topic; verifiers must check continuity

## Pseudonymity
`recipientHash` and user IDs = `HMAC_SHA256(cohortPepper[vX], E164(phone)|walletAlias)`; peppers via HKDF; stored in KMS/HSM.
