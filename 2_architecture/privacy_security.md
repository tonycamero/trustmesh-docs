# Privacy, Security & Compliance Design

- **Pseudonymization:** **Cohort-peppered HMACs** � `userId = HMAC_SHA256(cohortPepper[vX], E164(phone)|walletAlias)`. Peppers derived via HKDF, stored in **KMS/HSM**, rotated with `REKEY`.
- **Identity & keys:** **Magic.link** passkeys/WebAuthn (primary). OTP only assists discovery. Post-MVP: **DeRec** for social recovery.
- **Data minimization:** Store `reasonHash` on-chain; plaintext reasons are ephemeral for moderation only. No plaintext phone numbers.
- **Visibility:** Public shows **aggregate tag trends** per cohort; identities private unless both parties opt in.
- **Functional deletion:** On request, cease indexing a subject�s events and remove from aggregates; ledger entries remain for integrity.
- **Security controls:** Rate limits, spam filters, abuse reporting; anomaly alerts on key changes; delayed rebind after recovery.
- **Compliance:** **GDPR + CCPA**; campus pilots add **FERPA** notes. TCPA/10DLC for SMS **invites only**. DPIA/TIA templates maintained in `6_legal_compliance/`.
