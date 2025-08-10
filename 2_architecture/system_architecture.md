# System Architecture

## Components
- **Frontend:** React + Tailwind mobile web
- **Identity/Keys:** **Magic.link** (passkeys/WebAuthn) for key mgmt & recovery (DeRec post-MVP)
- **Messaging:** **XMTP SDK** (wallet/alias chat, E2E). **SMS only** for invites/claims. HCS10 for system/campaign triggers.
- **Payments:** **TRST stablecoin** via **Brale** (KYC/AML, custody/compliance) + **MatterFi SDK**; **KNS** Send-to-Name; QR-pay
- **Engagement:** Hedera **NFTs** (redeemable/POAP) + **hashinals** (portable, non-financial artifacts)
- **Commitment Layer:** **Circle of Trust Registry** enforcing **9 DBTs** per user, quiet unbonding & cooldown
- **Contacts Layer:** Unlimited, consented contact graph (private by default; low weight)
- **Indexer:** Deterministic reducer + **hourly Merkle checkpoint** to a dedicated HCS topic
- **Privacy:** Cohort-peppered HMAC IDs (HKDF-derived peppers in KMS/HSM; rotation/versioning)

## Data Flows
- **Commitment:** COMMIT ? (UNBOND) ? REVOKE ? slot cooldown
- **Contacts:** CONTACT_ADD/REMOVE; opt-in sharing
- **Messaging:** XMTP consent/block/report; rate limits; HCS triggers; SMS invites only
- **Payments:** TRST transfers via Brale/MatterFi; KNS resolution; �pay trusted first� policy
