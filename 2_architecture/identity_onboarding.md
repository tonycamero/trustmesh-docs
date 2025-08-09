# Identity & Onboarding

- Primary auth: **Passkeys (WebAuthn)**; OTP assists discovery only.
- Social recovery: 2-of-3 guardians with time-locked recovery.
- Cohort-salted pseudonymous IDs via HMAC(phone, cohortPepper) stored in HSM.
- SIM-swap safeguards: optional email/SSO attestation and delayed rekeys.
