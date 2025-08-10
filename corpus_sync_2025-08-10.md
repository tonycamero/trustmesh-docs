===== FILE: 1_overview/vision.md =====
# Vision
**Make trust portable.** TrustMesh maps intentional, IRL commitments into a verifiable, privacy-preserving network.

## Mission
Deliver a mobile-first, Hedera-backed trust layer with:
- **9 device-bound commitment slots** (Circle of Trust)
- **Quiet unbonding** and per-slot cooldown
- **Contacts (lite trust)** for safe discovery/routing
- **TRST payments** (Brale KYC/AML; MatterFi flows)
- **IRB-ready privacy posture** (cohort-peppered HMAC; aggregate visibility)

## Differentiators
- Scarce & revocable strong trust (DBTs) + unlimited lite contacts
- Hedera-native identity, messaging, and assets
- Licensed kernel; predictable scaling and governance
===== END FILE =====

===== FILE: 1_overview/positioning.md =====
# Positioning & Narrative

- **Tagline:** Commit your trust. Shape the mesh.
- **One-liner:** A Hedera-backed trust graph — no likes, no followers, just **verified commitments**.
- **Why now:** Vanity metrics failed; privacy-first, verifiable **commitment signals** enable safer coordination.
- **Who it serves:** Students & RAs, researchers, civic groups, mission-driven orgs.
===== END FILE =====

===== FILE: 2_architecture/system_architecture.md =====
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
- **Payments:** TRST transfers via Brale/MatterFi; KNS resolution; “pay trusted first” policy
===== END FILE =====

===== FILE: 2_architecture/identity_onboarding.md =====
# Identity & Onboarding

- **Primary auth:** Passkeys (WebAuthn) via **Magic.link**
- **Recovery:** Magic.link recovery; **DeRec** planned post-MVP
- **Discovery:** OTP assists wallet claim/invite only
- **Pseudonymity:** Cohort-peppered HMAC for phone/alias; optional public pseudonyms
- **Wallets:** Non-custodial Hedera (Ed25519); keys bound to device (DBTs)
===== END FILE =====

===== FILE: 2_architecture/messaging_protocol.md =====
# Messaging & Event Protocol

- **Transport:** **XMTP** for all user chat (E2E). **Not SMS.**  
- **SMS:** Invite/claim only; STOP/HELP honored and logged.
- **Campaigns:** HCS10 emits triggers clients render in XMTP.
- **Consent & Safety:** First-DM approval, mute/block/report, per-address rate limits.

## State Events (HCS10)
`ALLOCATE, COMMIT, UNBOND, REVOKE, RECOVER, VERIFY_DEVICE, CONTACT_ADD, CONTACT_REMOVE, REKEY, CHECKPOINT`

- Deterministic ordering by `(ts, txId)`; hourly Merkle checkpoints to anchor reduced state.
===== END FILE =====

===== FILE: 2_architecture/tokenization.md =====
# Tokenization Model

- **Strong trust:** **Device-Bound Tokens (DBTs)** = your 9 commitment slots. DBTs are **not NFTs**; they’re device-key-bound authorizations managed by the Registry.
- **Lite trust:** **Contacts** are unlimited, consented connections; private by default; low analytic weight.
- **Engagement assets:** **NFTs** (redeemable/POAP) and **hashinals** as portable, **non-financial** artifacts for campaigns and acknowledgments.
- **Revocation:** Quiet unbonding (~72h) ? REVOKE ? per-slot cooldown (~14d). No public shaming.
===== END FILE =====

===== FILE: 2_architecture/privacy_security.md =====
# Privacy, Security & Compliance Design

- **Pseudonymity:** `userId = HMAC_SHA256(cohortPepper[vX], E164(phone)|walletAlias)`; peppers via HKDF in **KMS/HSM**; `REKEY` rotation/versioning.
- **Data minimization:** On-chain: event tuples + `reasonHash`; no plaintext phones; plaintext reasons ephemeral for moderation.
- **Visibility:** Public = cohort-level aggregates by tag; private details only by mutual opt-in.
- **Abuse controls:** Rate limits, spam filters, content moderation, anomaly alerts on key changes; delayed rebind post-recovery.
- **Compliance:** **GDPR + CCPA**; campus pilots: **FERPA** notes; **TCPA/10DLC** for SMS invites.
===== END FILE =====

===== FILE: 2_architecture/api_spec.md =====
# API Spec (Draft)

## Commitments
- `POST /v1/commit` ? `{ slotID, recipientHash, tag, reasonHash? }`
- `POST /v1/unbond` ? `{ slotID }`
- `POST /v1/revoke` ? `{ slotID }`
- `GET  /v1/me/slots` ? DBT bitmap + `cooldownUntil` per slot

## Contacts
- `POST /v1/contacts` ? `{ contactToken | contactHash, channel }`  // QR or invite link claim
- `DELETE /v1/contacts/:contactHash`
- `GET  /v1/me/contacts` ? private list; export token for opt-in sharing

## Messaging (XMTP)
- Client uses XMTP SDK (consent, block/report, rate limits)
- `POST /v1/bridge/sms-invite` ? SMS invite for wallet claim (STOP/HELP honored)

## Checkpoints
- `GET /v1/checkpoints/latest` ? `{ merkleRoot, schemaHash, height, ts, topicId }`

> TRST transfers via Brale/MatterFi; on/off-ramp handled by Brale.
===== END FILE =====

===== FILE: 2_architecture/state_spec_v0.1.md =====
# State Spec v0.1

## Event Types
`ALLOCATE, COMMIT, UNBOND, REVOKE, RECOVER { oldPubKey, newPubKey, guardians[], proof }, VERIFY_DEVICE, CONTACT_ADD { ownerId, contactId, channel, ts }, CONTACT_REMOVE, REKEY, CHECKPOINT { merkleRoot, schemaHash, height, ts }`

## Required Fields (all)
`{ schema:"trustmesh/state/0.1", chainId, topicId, txId, ts, userPubKey, slotID?, nonce, sig, cohortId, pepperVersion }`

## Rules
- **Slots:** `slotID ? [0..8]`; one active commitment per slot
- **Quiet unbonding:** default **72h** between `UNBOND` and `REVOKE`
- **Cooldown:** per-slot default **14d**; `COMMIT` invalid if `now < cooldownUntil`
- **Contacts:** unlimited; private by default; low weight
- **Ordering:** reduce by `(ts, txId)`; tie-break on `txId`
- **Checkpoint cadence:** **hourly** Merkle to dedicated HCS topic; verify continuity

## Pseudonymity
IDs/hashes derived with cohort-peppered HMAC (HKDF peppers; KMS/HSM).
===== END FILE =====

===== FILE: 3_ux_workflows/sms_flow.md =====
# SMS Flow (Invites/Claims Only)

- Use SMS **only** to deliver wallet claim/invite links.
- Copy patterns: Clear sender, purpose, STOP/HELP, single tap to claim.
- Respect **TCPA/10DLC**; store consent artifacts; honor STOP immediately.
- All subsequent chat is in **XMTP** (app).
===== END FILE =====

===== FILE: 3_ux_workflows/wallet_creation.md =====
# Wallet Creation & Claim

1) User taps invite/QR ? lands on **Magic.link** passkey flow (WebAuthn).  
2) On success: non-custodial Hedera wallet created; **DBTs** allocated on ALLOCATE; TRST wallet rails registered via **Brale** (KYC/AML as required).  
3) Dashboard shows **ring of nine** + Contacts.  
4) Recovery: Magic.link; DeRec post-MVP.
===== END FILE =====

===== FILE: 3_ux_workflows/engagement_loops.md =====
# Engagement Loops

- **Ring of Nine:** Visual slots (Strong trust).  
- **Reciprocity Nudge:** “Commit 1 back?” after acceptance.  
- **Cooldown UX:** Shows time until slot re-opens after unbond/revoke.  
- **Campaign Rewards:** NFTs/hashinals for actions (proof-of-presence; burn-on-redeem at POS).  
- **No global scores:** Public dashboards show **aggregate tag trends** only.
===== END FILE =====

===== FILE: 4_research_academic/faculty_engagement.md =====
# Faculty Engagement

- One-pager + demo: trust as scarce, revocable signal; cohort pseudonymity; research value.  
- Consent model, DPIA/TIA summary, and IRB-ready deployment checklist.  
- Data access = aggregates by default; de-identified microdata by separate consent.
===== END FILE =====

===== FILE: 4_research_academic/data_privacy.md =====
# Data Privacy (IRB-Ready)

- Cohort-peppered HMAC IDs (peppers in KMS/HSM; rotate via `REKEY`).  
- Store `reasonHash` only; ephemeral plaintext for moderation.  
- Functional deletion: stop indexing subject; remove from aggregates (ledger entries remain).  
- GDPR + CCPA; campus pilots include FERPA notes.
===== END FILE =====

===== FILE: 4_research_academic/kpi_metrics.md =====
# KPIs & Metrics

- **Adoption:** Claim?Commit = 55%; Day-7 active commitments/user 3.0–4.5  
- **Health:** Revocation < 8%; abuse flags < 1%  
- **Network:** Reciprocity rate; tag distribution; contact?commit uplift  
- **Reliability:** XMTP delivery success; HCS backlog; checkpoint continuity
===== END FILE =====

===== FILE: 5_development_plan/mvp_scope.md =====
# MVP Scope

**In scope**
- Messaging loop (**XMTP**; HCS10 triggers; **SMS invites only**)
- Payments loop (**TRST via Brale/MatterFi**; KNS)
- Engagement loop (NFT/hashinal rewards)
- Circle of Trust (9 **DBTs**; quiet unbonding; per-slot cooldown)
- **Contacts (lite trust)** — unlimited, low weight, private by default
- Indexer with **hourly** Merkle checkpoints
- Privacy: cohort-peppered HMAC, functional deletion
- Recovery: **Magic.link** (passkeys); **DeRec** post-MVP

**Out of scope (MVP)**
- Non-TRST payment rails
- Global reputation scores (aggregates only)
===== END FILE =====

===== FILE: 5_development_plan/sprint_plan.md =====
# Sprint Plan (Outline)

- **S1:** Passkeys + wallet claim (Magic.link); HCS topics; ALLOCATE/COMMIT  
- **S2:** XMTP consent & DM rules; SMS invite bridge; Contacts graph  
- **S3:** TRST flows (Brale/MatterFi); KNS; pay-trusted-first policy  
- **S4:** Indexer + hourly Merkle; dashboards (aggregates)  
- **S5:** Engagement (NFT/hashinals); proof-of-presence; POS burn  
- **S6:** Privacy polish; DPIA/TIA; functional deletion; abuse tooling
===== END FILE =====

===== FILE: 5_development_plan/risk_assessment.md =====
# Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---:|---:|---|
| Brale/MatterFi outage/geo | Med | High | Queue+retry; outage banners; degrade to non-payment flows |
| XMTP spam/abuse | Med | Med | Opt-in DMs; block/report; rate limits; contact/mutual-first |
| SIM swap/key compromise | Med | High | Magic.link recovery; delayed rebind; anomaly alerts |
| Mirror lag/checkpoint divergence | Low | High | Deterministic reducer; hourly Merkle; independent verifiers |
| Reward farming | Med | Med | Proof-of-presence; device heuristics; cooldowns |
| KNS squatting | Med | Med | Reservation policy; verified names; rename audit log |
===== END FILE =====

===== FILE: 6_legal_compliance/gdpr.md =====
# GDPR Notes

- Lawful basis: consent/legitimate interest (research/civic modes).  
- Rights: access/rectification/erasure ? **functional deletion** pathway.  
- Data minimization; DPIA/TIA templates; processor/sub-processor list maintained.
===== END FILE =====

===== FILE: 6_legal_compliance/tcpacompliance.md =====
# TCPA / 10DLC

- **Channel use:** SMS = **invite/claim only**.  
- **Consent:** Explicit opt-in; STOP/HELP honored & logged.  
- **Registration:** 10DLC campaigns & templates.  
- **Records:** Consent artifacts; STOP logs; periodic audits.
===== END FILE =====

===== FILE: 6_legal_compliance/terms_of_service.md =====
# Terms of Service (Draft Highlights)

- Non-financial social signal; no trading/yield.  
- Privacy by design; pseudonymous IDs; aggregate visibility by default.  
- Prohibited content & abuse policy; enforcement & appeal.  
- Consent for messaging; jurisdiction & arbitration placeholders.
===== END FILE =====

===== FILE: 7_collaboration_governance/contribution_guidelines.md =====
# Contribution Guidelines

- Keep **Hedera-first / TRST-first / XMTP-first** architecture.  
- Feature branches + PRs; link issues; update docs/diagrams on change.  
- No duplicate loop logic without an integration plan.
===== END FILE =====

===== FILE: 7_collaboration_governance/meeting_notes.md =====
# Meeting Notes

Template:
- Date/Time
- Attendees
- Decisions
- Action items (owner, due)
===== END FILE =====

===== FILE: 7_collaboration_governance/glossary.md =====
# Glossary

- **Device-Bound Token (DBT):** One of a user’s **nine** commitment slots; device-key-bound; non-transferable; revocable.
- **Circle of Trust:** The 9-slot strong-trust model (quiet unbonding & cooldown).
- **Contact (Lite Trust):** Unlimited, consented connection; private by default; low weight.
- **Quiet Unbonding:** ~72h delay before removal; reduces social shock.
- **Checkpoint:** Hourly Merkle root of reduced state to HCS.
- **Hashinal:** Portable Hedera-native, non-financial artifact.
- **TRST:** Stablecoin rail on Hedera; **Brale** handles KYC/AML.
- **KNS:** Send-to-Name addressing (reservation/rename policy).
- **XMTP:** End-to-end wallet chat; **not SMS**.
- **Cohort Pepper:** Secret used for HMAC IDs; versioned & rotated.
===== END FILE =====
