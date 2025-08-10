# Messaging & Event Protocol

- **Transport:** **XMTP** for all user chat (E2E). **Not SMS.**  
- **SMS:** Invite/claim only; STOP/HELP honored and logged.
- **Campaigns:** HCS10 emits triggers clients render in XMTP.
- **Consent & Safety:** First-DM approval, mute/block/report, per-address rate limits.

## State Events (HCS10)
`ALLOCATE, COMMIT, UNBOND, REVOKE, RECOVER, VERIFY_DEVICE, CONTACT_ADD, CONTACT_REMOVE, REKEY, CHECKPOINT`

- Deterministic ordering by `(ts, txId)`; hourly Merkle checkpoints to anchor reduced state.
