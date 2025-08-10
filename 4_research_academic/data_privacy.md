# Data Privacy (IRB-Ready)

- **Pseudonymity**: IDs via **cohort-peppered HMAC**; peppers in **KMS/HSM**; rotate with `REKEY`.
- **Minimal on-chain**: Store **reasonHash** only; plaintext held ephemerally for moderation.
- **Contacts**: Consent required (QR/SMS link click). Contacts private by default; opt-in sharing.
- **Visibility**: Public dashboards show **aggregate tag trends**; no identities without consent.
- **Functional deletion**: On request, stop indexing a subject-s events and remove from aggregates; ledger entries remain for integrity.
- **Compliance**: GDPR + **CCPA**; campus pilots include **FERPA** notes.
