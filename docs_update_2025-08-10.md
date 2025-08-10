===== FILE: README.md =====
# TrustMesh Documentation Repository

This repository is the **authoritative source** for the TrustMesh product vision, architecture, UX, compliance, and deployment model — built on the Scend Context Engineering kernel.

## Core Mandate
TrustMesh is a **Hedera-first**, privacy-preserving trust graph that turns IRL trusted relationships into **cryptographically verifiable commitments**.

Every deployment must implement the **three context loops** in this order:
NOTE: Context Loops are sequential in activation (Messaging must be live before Payments, before Engagement) — this matches the operating philosophy in CONTEXT_ENGINNERING.md

1. **Messaging** — **XMTP-powered** threads by wallet or alias. *XMTP is not SMS.* SMS is used only for **invites/claims**; all chat occurs over XMTP. HCS10 emits system/campaign triggers.
2. **Payments** — **TRST stablecoin** via **Brale** (KYC/AML + custody/compliance) with **MatterFi SDK** for flows. Wallets auto-provisioned; **Send-to-Name (KNS)** and QR-pay supported.
3. **Engagement** — Hedera **NFT/hashinal** rewards and **Circle of Trust** allocations (9 **device-bound** commitment slots per user, quiet unbonding, immutable acceptance).

### Non-Negotiables
- **TRST is the only payment rail** for stablecoin flows in MVP (**Brale handles KYC/AML**).
- **Circle of Trust** governs strong trust: **9 device-bound tokens (DBTs)** per user; revocable with quiet unbonding and per-slot cooldowns.
- **Contacts (lite trust) are included**: unlimited, consented connections for discovery/routing; low weight; private by default.
- **Hedera-first**: HTS for assets, HCS10 for events, hashinals for portable reputation.
- **Licensed kernel** — not public open source. Cloning/deployments require contractual authorization.

## Repository Structure
- **1_overview/** — Vision, positioning, Circle of Trust principles  
- **2_architecture/** — Hedera-based system design, protocol, specs  
- **3_ux_workflows/** — Loop-driven UX (Messaging → Payments → Engagement)  
- **4_research_academic/** — Research alignment, IRB-ready privacy posture  
- **5_development_plan/** — MVP scope, sprints, risks, deployment  
- **6_legal_compliance/** — GDPR, CCPA, TCPA, data retention  
- **7_collaboration_governance/** — Contribution guidelines, glossary, style  
- **assets/** — Diagrams, wireframes, visuals  
- **secure/** — Sensitive docs (git-ignored; encrypt or store off-repo)

## Quick Start
1. Read `1_overview/vision.md` and `positioning.md`.  
2. Engineers: `2_architecture/system_architecture.md` + `state_spec_v0.1.md`.  
3. Designers: `3_ux_workflows/circle_of_trust_flow.md` + `wallet_creation.md`.  
4. Pilots/research: `4_research_academic/`.

## Licensing & Deployment
- **Private kernel** — licensed via Scend Technologies, LLC.  
- Cloneable for approved partners (civic, campus, enterprise).  
- **No public open-source distribution**.
===== END FILE =====

===== FILE: 1_overview/vision.md =====
# Vision
**Make trust portable.** TrustMesh maps intentional, IRL commitments into a verifiable, privacy-preserving network.

## Mission
Deliver a mobile-first, Hedera-backed trust layer with:
- **9 device-bound commitment slots** (Circle of Trust)
- **Quiet unbonding** and immutable acceptance
- **TRST payments** (Brale KYC/AML; MatterFi flows)
- **IRB-ready privacy posture**
- **Contacts (lite trust)** for safe discovery and routing

## Differentiators
- Scarce & revocable strong trust (DBTs) + unlimited **lite** contacts
- Hedera-native identity, messaging, and assets
- Licensed kernel for controlled scaling
===== END FILE =====

===== FILE: 2_architecture/system_architecture.md =====
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
- **Commitment:** COMMIT → (UNBOND) → REVOKE; registry updates bitmap; indexer reduces to edges; hourly checkpoint
- **Contacts:** CONTACT_ADD/REMOVE; indexer maintains private graph; opt-in sharing
- **Messaging:** XMTP consent/block/report + rate limits; HCS triggers; SMS invites only
- **Payments:** TRST transfers via Brale/MatterFi; KNS resolution; policy **pay trusted first**
===== END FILE =====

===== FILE: 2_architecture/state_spec_v0.1.md =====
# State Spec v0.1

## Event Types
- `ALLOCATE` — enable 9 DBT slots for `userPubKey`
- `COMMIT` — bind `slotID` → `recipientHash` with `tag`, optional `reasonHash`
- `UNBOND` — start quiet-unbond timer (`unbondAt`)
- `REVOKE` — finalize removal post-delay; frees slot; sets `cooldownUntil`
- `RECOVER` — rotate keys/guardians: `{ oldPubKey, newPubKey, guardians[], proof }`
- `VERIFY_DEVICE` — device/passkey attestation record (Magic.link)
- `CONTACT_ADD` — `{ ownerId, contactId, channel, ts }`
- `CONTACT_REMOVE` — remove contact
- `REKEY` — cohort pepper rotation announcement
- `CHECKPOINT` — indexer announces `{ merkleRoot, schemaHash, height, ts }` to checkpoint topic

## Required Fields (all events)
{ schema:"trustmesh/state/0.1", chainId, topicId, txId, ts,
  userPubKey, slotID?, nonce, sig, cohortId, pepperVersion }

## Rules
- **Idempotency:** `(userPubKey, (slotID|eventKey), nonce)` unique
- **Slots:** `slotID → [0..8]`; **one active commitment per slot**
- **Quiet Unbonding:** default **72h** between `UNBOND` and `REVOKE`
- **Cooldown:** per-slot; default **14 days**; `COMMIT` invalid if `now < cooldownUntil`
- **Contacts:** unlimited; private by default; low weight (policy below)
- **Ordering:** reduce by `(ts, txId)`; tie-break on `txId`
- **Checkpoint cadence:** **hourly** Merkle to dedicated HCS topic; verifiers must check continuity

## Pseudonymity
`recipientHash` and user IDs = `HMAC_SHA256(cohortPepper[vX], E164(phone)|walletAlias)`; peppers via HKDF; stored in KMS/HSM.
===== END FILE =====

===== FILE: 2_architecture/api_spec.md =====
# API Spec (Draft)

## Commitments
- POST /v1/commit → { slotID, recipientHash, tag, reasonHash? }
- POST /v1/unbond → { slotID }
- POST /v1/revoke → { slotID }
- GET  /v1/me/slots → DBT bitmap + cooldownUntil per slot

## Contacts
- POST /v1/contacts → { contactToken | contactHash, channel }  // QR or invite link claim
- DELETE /v1/contacts/:contactHash
- GET  /v1/me/contacts → private list; export token for opt-in sharing

## Messaging (XMTP)
- Client uses **XMTP SDK** directly (send/receive rules: consent, block/report, rate limits)
- POST /v1/bridge/sms-invite → send SMS invite for wallet claim (STOP/HELP honored)

## Checkpoints
- GET /v1/checkpoints/latest → { merkleRoot, schemaHash, height, ts, topicId }

Notes: TRST transfers via Brale/MatterFi; on/off-ramp handled by Brale.
===== END FILE =====

===== FILE: 3_ux_workflows/circle_of_trust_flow.md =====
# Circle of Trust — UX Flow

1. **Initiate**: Tap **Commit Trust** → select **tag** (e.g., Integrity), optional short note → pick recipient (QR, alias, or contact).
2. **Accept**: Recipient claims via wallet onboarding (**Magic.link**); sees the commitment and **ring of nine**.
3. **Reciprocate**: Prompt **Commit 1 back?** with one-tap prefill.
4. **Quiet unbonding**: -Uncommit- starts a **~72h** quiet period; after that, the slot frees; **per-slot cooldown** (~14d) applies.
5. **Privacy**: Public shows **aggregate tag counts** only; details private unless both opt-in.

Language: use **-commit-** (not stake). Show **Strong trust** for commitments; **Lite trust** for contacts.
===== END FILE =====

===== FILE: 3_ux_workflows/messaging_flow.md =====
# Messaging — XMTP (not SMS)

- **Transport**: All chat uses **XMTP** (end-to-end encrypted).  
- **Consent**: First DM requires recipient approval → **Allow / Mute / Block**.  
- **Rules**: Per-address rate limits; spam scoring; **block/report** in UI.  
- **Contacts**: DMs route easier between **contacts** or **mutual commitments**; default -trusted first.-  
- **Campaigns**: System/campaign messages are **HCS10 triggers** clients render in XMTP.  
- **SMS**: **Invite/claim only**; STOP/HELP on SMS; no two-way chat over SMS.
===== END FILE =====

===== FILE: 3_ux_workflows/payments_flow.md =====
# Payments — TRST Only (MVP)

- **Rail**: **TRST stablecoin**; **Brale** manages **KYC/AML, custody, compliance**; **MatterFi SDK** drives flows.
- **Send**: Pay by **KNS name**, QR, or alias; default policy **-pay trusted first.-**
- **Balance**: TRST balance visible; show outage banners and queue/retry for Brale/MatterFi incidents.
- **Geofencing & Limits**: Enforced per Brale policy; clear error states.
- **Receipts**: Optional hashinal receipt; POS NFTs can be **burn-on-redeem**.

**KNS policy**: reservation & rename history to deter squatting; verified badges for known entities.
===== END FILE =====

===== FILE: 4_research_academic/data_privacy.md =====
# Data Privacy (IRB-Ready)

- **Pseudonymity**: IDs via **cohort-peppered HMAC**; peppers in **KMS/HSM**; rotate with `REKEY`.
- **Minimal on-chain**: Store **reasonHash** only; plaintext held ephemerally for moderation.
- **Contacts**: Consent required (QR/SMS link click). Contacts private by default; opt-in sharing.
- **Visibility**: Public dashboards show **aggregate tag trends**; no identities without consent.
- **Functional deletion**: On request, stop indexing a subject-s events and remove from aggregates; ledger entries remain for integrity.
- **Compliance**: GDPR + **CCPA**; campus pilots include **FERPA** notes.
===== END FILE =====

===== FILE: 5_development_plan/mvp_scope.md =====
# MVP Scope

**In scope**
- Messaging loop (**XMTP SDK**; HCS10 triggers; **SMS invites only**)
- Payments loop (**TRST via Brale/MatterFi**; KNS)
- Engagement loop (NFT/hashinal rewards)
- Circle of Trust (9 **DBTs**; quiet unbonding; per-slot cooldown)
- **Contacts (lite trust)** — unlimited, low weight, private by default
- Indexer with **hourly** Merkle checkpoints to HCS topic
- Privacy: cohort-peppered HMAC, functional deletion
- Recovery: **Magic.link** (passkeys); **DeRec post-MVP**

**Post-MVP**
- DeRec-based recovery
- Governance/DAO mechanics
- Multi-rail payments

**Out of scope (MVP)**
- Non-TRST payment rails
- Global -reputation scores- (aggregate trends only)
===== END FILE =====

===== FILE: 5_development_plan/risk_assessment.md =====
# Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---:|---:|---|
| Brale/MatterFi outage or geo restriction | Med | High | Queue + retry; UX banner; degrade to non-payment flows |
| XMTP spam/abuse | Med | Med | Opt-in DMs; block/report; per-address rate limits; contact/mutual-first routing |
| SIM swap / key compromise | Med | High | **Magic.link** recovery; delayed rebind; anomaly alerts; optional SSO/email attestation |
| Mirror-node lag / checkpoint divergence | Low | High | Deterministic reducer; **hourly** Merkle; independent verifiers |
| Reward farming | Med | Med | Proof-of-presence gates; device heuristics; cooldowns |
| KNS squatting/impersonation | Med | Med | Reservation policy; verified names; rename audit log |
===== END FILE =====

===== FILE: 6_legal_compliance/tcpacompliance.md =====
# TCPA / 10DLC Compliance

- **Channel use**: SMS is **invite/claim only**. All ongoing chat occurs in **XMTP**.
- **Consent**: Explicit consent for SMS invites; **STOP/HELP** honored and logged.
- **Registration**: 10DLC campaign registration; content templates whitelisted.
- **Record-keeping**: Store consent artifacts and STOP logs; periodic audits.
===== END FILE =====

===== FILE: 7_collaboration_governance/glossary.md =====
# Glossary

- **Device-Bound Token (DBT):** One of a user-s **nine** commitment slots; bound to device key; non-transferable; revocable.
- **Circle of Trust:** The 9-slot strong trust model with quiet unbonding & cooldown.
- **Contact (Lite Trust):** Unlimited, consented connection used for discovery/routing; private by default; low analytic weight.
- **Quiet Unbonding:** ~72h delay before commitment removal; reduces social shock.
- **Checkpoint:** Hourly Merkle root of reduced state published to HCS.
- **Hashinal:** Portable Hedera-native reputation artifact (non-financial).
- **TRST:** Scend-s stablecoin rail on Hedera; **Brale handles KYC/AML**.
- **KNS:** Human-readable Send-to-Name addressing with reservation/rename policy.
- **XMTP:** End-to-end encrypted wallet chat; **not SMS**.
- **Cohort Pepper:** Secret used to derive pseudonymous IDs per cohort; versioned & rotated.
===== END FILE =====
