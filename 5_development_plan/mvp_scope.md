# MVP Scope

In scope
- Messaging loop (XMTP; HCS10 triggers; SMS invites only)
- Payments loop (TRST via Brale/MatterFi; KNS)
- Engagement loop (NFT/hashinal rewards)
- Circle of Trust (9 DBTs; quiet unbonding; per-slot cooldown)
- Contacts (lite trust) � unlimited, low weight, private by default
- Indexer with hourly Merkle checkpoints
- Privacy: cohort-peppered HMAC, functional deletion
- **Uniqueness (BrightID):** gate **COMMIT** and high-value campaign rewards by default (config flag)
- Recovery: Magic.link passkeys; DeRec post-MVP

Out of scope (MVP)
- Non-TRST payment rails
- Global reputation scores (aggregates only)
