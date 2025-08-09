# System Architecture

## Components
- Mobile web client (React + Tailwind)
- Messaging (SMS via Twilio, 10DLC compliant)
- Identity (passkeys/WebAuthn, optional OTP assist)
- Non-custodial Hedera wallets (Ed25519)
- HCS10 topics for append-only events (hashinals)
- Indexer service (stateless validators + Merkle checkpointing)
- Optional Trust Slot Registry contract (later hardening)

## Diagrams
See `/assets/diagrams/` and keep SVG source committed.
