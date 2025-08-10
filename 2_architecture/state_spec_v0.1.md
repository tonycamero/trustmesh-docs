# State Spec v0.1

## Event Types
ALLOCATE, COMMIT, UNBOND, REVOKE, RECOVER { oldPubKey, newPubKey, guardians[], proof },  
VERIFY_DEVICE, CONTACT_ADD { ownerId, contactId, channel, ts }, CONTACT_REMOVE, REKEY,  
CHECKPOINT { merkleRoot, schemaHash, height, ts },  
**ATTEST_BRIGHTID { subjectId, verified, method, proofHash, ts }**  // optional audit attestation

## Required Fields (all)
{ schema:"trustmesh/state/0.1", chainId, topicId, txId, ts, userPubKey, slotID?, nonce, sig, cohortId, pepperVersion }

## Rules
- **Slots:** slotID in [0..8]; one active commitment per slot.
- **Quiet unbonding:** default 72h between UNBOND and REVOKE.
- **Cooldown:** per-slot default 14d; COMMIT invalid if now < cooldownUntil.
- **Contacts:** unlimited; private by default; low weight.
- **Ordering:** reduce by (ts, txId); tie-break on txId.
- **Checkpoint cadence:** hourly Merkle to dedicated HCS topic; verify continuity.
- **Uniqueness policy (BrightID):**  
  - If `policy.requireBrightIDForCommit == true`, the reducer MUST reject COMMIT unless `profile[pubKey].brightidVerified == true`.  
  - Optional: write **ATTEST_BRIGHTID** after successful verification for local auditability (no PII).

## Pseudonymity
IDs and recipient hashes derived with cohort-peppered HMAC (HKDF peppers; stored in KMS/HSM; rotated with REKEY).
