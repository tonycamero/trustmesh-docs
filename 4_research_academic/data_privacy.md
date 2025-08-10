# Data Privacy (IRB-Ready)

- **Pseudonymity:** Cohort-peppered HMAC IDs (peppers in KMS/HSM; rotate via REKEY).  
- **BrightID:** We store only an app-scoped verification state and a hash of the proof; no PII.  
- **Minimal on-chain:** reasonHash only; plaintext reasons ephemeral for moderation.  
- **Functional deletion:** Stop indexing subject, remove from aggregates (ledger entries remain for integrity).  
- **Compliance:** GDPR + CCPA; campus pilots include FERPA notes; TCPA/10DLC for SMS invites.
