# Privacy, Security & Compliance Design

- **Pseudonymity:** `userId = HMAC_SHA256(cohortPepper[vX], E164(phone)|walletAlias)`; peppers via HKDF in **KMS/HSM**; `REKEY` rotation/versioning.
- **Data minimization:** On-chain: event tuples + `reasonHash`; no plaintext phones; plaintext reasons ephemeral for moderation.
- **Visibility:** Public = cohort-level aggregates by tag; private details only by mutual opt-in.
- **Abuse controls:** Rate limits, spam filters, content moderation, anomaly alerts on key changes; delayed rebind post-recovery.
- **Compliance:** **GDPR + CCPA**; campus pilots: **FERPA** notes; **TCPA/10DLC** for SMS invites.
