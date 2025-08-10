# System Architecture

## Components
- **Frontend:** React + Tailwind mobile web
- **Identity/Keys:** **Magic.link** (passkeys/WebAuthn) for key management & recovery (DeRec post-MVP)
- **Messaging:** **XMTP SDK** (wallet/alias chat; E2E). **SMS only** for invites/claims. HCS10 for campaign/system triggers.
- **Payments:** **TRST stablecoin** via **Brale** (KYC/AML + custody/compliance) with **MatterFi SDK**; **KNS** Send-to-Name; QR-pay
- **Engagement:** Hedera **NFTs** (redeemable/POAP-style) + **hashinals** (portable reputation artifacts)
- **Commitment Layer:** **Circle of Trust Registry** (contract) enforcing **9 device-bound tokens (DBTs)** per user, quiet unbonding & per-slot cooldowns
- **Contacts Layer:** Unlimited, consented contact graph (private by default; low weight)
- **Indexer:** Stateless validators + deterministic reducer + **hourly Merkle checkpoint** to a dedicated HCS topic
- **Secrets & Privacy:** Cohort-peppered HMAC IDs derived in **KMS/HSM**; pepper versioning & rotation

## Data Flows
- **Commitment:** COMMIT ? (UNBOND) ? REVOKE; registry updates bitmap; indexer reduces to edges; hourly checkpoint
- **Contacts:** CONTACT_ADD/REMOVE; indexer maintains private graph; opt-in sharing
- **Messaging:** XMTP consent/block/report + rate limits; HCS triggers; SMS invites only
- **Payments:** TRST transfers via Brale/MatterFi; KNS resolution; policy **pay trusted first**
