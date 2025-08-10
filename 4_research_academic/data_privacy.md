# Data Privacy (IRB-Ready)

- Cohort-peppered HMAC IDs (peppers in KMS/HSM; rotate via `REKEY`).  
- Store `reasonHash` only; ephemeral plaintext for moderation.  
- Functional deletion: stop indexing subject; remove from aggregates (ledger entries remain).  
- GDPR + CCPA; campus pilots include FERPA notes.
