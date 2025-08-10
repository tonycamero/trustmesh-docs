===== FILE: 2_architecture/identity_onboarding.md =====
# Identity & Onboarding

## Sequence (MVP)
1) **Invite/Claim (SMS or QR)** -> user opens the app link.  
2) **Passkeys (Magic.link / WebAuthn)** -> device key created; non-custodial Hedera wallet provisioned (Ed25519).  
3) **Uniqueness check (BrightID)** -> user links and verifies in BrightID, returns to app; we record app-scoped proof.  
4) **DBT allocation (ALLOCATE)** -> 9 device-bound commitment slots (DBTs) enabled.  
5) **Contacts** -> user can add unlimited contacts.  
6) **Optional compliance (EarthID/Brale)** -> only when a regulated TRST action requires it.

## BrightID details
- **Purpose:** Privacy-preserving uniqueness (one-human-one-account) to reduce sybils and farming.  
- **User flow:** In-app “Verify uniqueness” -> **Open BrightID** (link/QR) -> approve connection -> return to app.  
- **Accepted methods for pilots:** **Meets** (hosted verification) and **Aura**.  
- **What we store:**  
  - `brightidVerified: boolean`  
  - `brightid.method: "meets" | "aura"`  
  - `brightid.verifiedAt: ISO8601`  
  - `brightid.proofHash: string` (hash of BrightID response or app-link proof; no PII)  
- **Privacy:** No real names or phone numbers sent to BrightID; we only link the BrightID app account to our app scope.  
- **Failure / grace:** If BrightID is unavailable, show a “try again” option and (configurable) **grace-period** for low-value actions (Contacts allowed; Commit may remain gated).

## Recovery
- **Primary:** Magic.link recovery and passkey re-registration.  
- **Post-MVP:** DeRec guardian-based recovery (rebind DBTs after delay).  
- **After recovery:** Re-check BrightID status; cache result again.

===== END FILE =====

===== FILE: 2_architecture/state_spec_v0.1.md =====
# State Spec v0.1

## Event Types
ALLOCATE, COMMIT, UNBOND, REVOKE, RECOVER { oldPubKey, newPubKey, guardians[], proof },  
VERIFY_DEVICE, CONTACT_ADD { ownerId, contactId, channel, ts }, CONTACT_REMOVE, REKEY,  
CHECKPOINT { merkleRoot, schemaHash, height, ts },  
**ATTEST_BRIGHTID { subjectId, verified, method, proofHash, ts }**  // optional audit attestation

## Required Fields (all)
{ schema:"trustmesh/state/0.1", chainId, topicId, txId, ts, userPubKey, slotID?, nonce, sig, cohortId, pepperVersion }

## Rules
- **Slots:** slotID in [0..8]; one active commitment per slot.
- **Quiet unbonding:** default 72h between UNBOND and REVOKE.
- **Cooldown:** per-slot default 14d; COMMIT invalid if now < cooldownUntil.
- **Contacts:** unlimited; private by default; low weight.
- **Ordering:** reduce by (ts, txId); tie-break on txId.
- **Checkpoint cadence:** hourly Merkle to dedicated HCS topic; verify continuity.
- **Uniqueness policy (BrightID):**  
  - If `policy.requireBrightIDForCommit == true`, the reducer MUST reject COMMIT unless `profile[pubKey].brightidVerified == true`.  
  - Optional: write **ATTEST_BRIGHTID** after successful verification for local auditability (no PII).

## Pseudonymity
IDs and recipient hashes derived with cohort-peppered HMAC (HKDF peppers; stored in KMS/HSM; rotated with REKEY).

===== END FILE =====

===== FILE: 2_architecture/api_spec.md =====
# API Spec (Draft)

## Commitments
- POST /v1/commit -> { slotID, recipientHash, tag, reasonHash? }  // 402_VERIFICATION_REQUIRED if BrightID gating on and not verified
- POST /v1/unbond -> { slotID }
- POST /v1/revoke -> { slotID }
- GET  /v1/me/slots -> DBT bitmap + cooldownUntil per slot

## Contacts
- POST /v1/contacts -> { contactToken | contactHash, channel }  // QR or invite link claim
- DELETE /v1/contacts/:contactHash
- GET  /v1/me/contacts -> private list; export token for opt-in sharing

## Identity (BrightID)
- POST /v1/identity/brightid/link -> returns { appLinkPayload, qrData, expiresAt }  // front-end opens BrightID
- POST /v1/identity/brightid/verify -> { appLinkResponse }  // server verifies with BrightID node; sets profile.brightidVerified=true
- GET  /v1/me/identity -> { brightidVerified, method, verifiedAt }

## Messaging (XMTP)
- Client uses XMTP SDK (consent, block/report, rate limits)
- POST /v1/bridge/sms-invite -> sends SMS invite for wallet claim (STOP/HELP honored)

## Checkpoints
- GET /v1/checkpoints/latest -> { merkleRoot, schemaHash, height, ts, topicId }

Notes: TRST transfers via Brale/MatterFi; on/off-ramp handled by Brale.

===== END FILE =====

===== FILE: 3_ux_workflows/wallet_creation.md =====
# Wallet Creation & Claim

## Screen flow
1) Invite/QR -> App opens.  
2) **Create passkey** (Magic.link / WebAuthn).  
3) **Verify uniqueness** (BrightID)  
   - Why: “One person = one account. Keeps the mesh healthy.”  
   - CTA: “Open BrightID” (link/QR) -> approve -> return automatically.  
   - If verified: show checkmark and short explanation.  
   - If skipped: explain limits (e.g., can add Contacts; Commit is locked until verified).  
4) **DBTs allocated:** show the **ring of nine** and contact import.  
5) Optional: “Enable TRST actions” (EarthID/Brale) only when needed.

## Microcopy (examples)
- “Verify you’re one unique person (2–3 minutes) to unlock your 9 commitment slots.”  
- “Already verified in another Scend app? Tap to reuse.”

===== END FILE =====

===== FILE: 4_research_academic/data_privacy.md =====
# Data Privacy (IRB-Ready)

- **Pseudonymity:** Cohort-peppered HMAC IDs (peppers in KMS/HSM; rotate via REKEY).  
- **BrightID:** We store only an app-scoped verification state and a hash of the proof; no PII.  
- **Minimal on-chain:** reasonHash only; plaintext reasons ephemeral for moderation.  
- **Functional deletion:** Stop indexing subject, remove from aggregates (ledger entries remain for integrity).  
- **Compliance:** GDPR + CCPA; campus pilots include FERPA notes; TCPA/10DLC for SMS invites.

===== END FILE =====

===== FILE: 5_development_plan/mvp_scope.md =====
# MVP Scope

In scope
- Messaging loop (XMTP; HCS10 triggers; SMS invites only)
- Payments loop (TRST via Brale/MatterFi; KNS)
- Engagement loop (NFT/hashinal rewards)
- Circle of Trust (9 DBTs; quiet unbonding; per-slot cooldown)
- Contacts (lite trust) — unlimited, low weight, private by default
- Indexer with hourly Merkle checkpoints
- Privacy: cohort-peppered HMAC, functional deletion
- **Uniqueness (BrightID):** gate **COMMIT** and high-value campaign rewards by default (config flag)
- Recovery: Magic.link passkeys; DeRec post-MVP

Out of scope (MVP)
- Non-TRST payment rails
- Global reputation scores (aggregates only)

===== END FILE =====

===== FILE: 5_development_plan/risk_assessment.md =====
# Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---:|---:|---|
| BrightID adoption friction | Med | Med | Host Meets at launch; in-app handoff; grace for Contacts-only until verified |
| BrightID API dependency | Low | Med | Cache status; retry/backoff; allow temporary grace for low-value actions |
| Brale/MatterFi outage/geo | Med | High | Queue+retry; outage banners; degrade to non-payment flows |
| XMTP spam/abuse | Med | Med | Opt-in DMs; block/report; rate limits; contact/mutual-first |
| SIM swap/key compromise | Med | High | Magic.link recovery; delayed rebind; anomaly alerts |
| Mirror lag/checkpoint divergence | Low | High | Deterministic reducer; hourly Merkle; independent verifiers |
| Reward farming | Med | Med | Proof-of-presence; device heuristics; cooldowns |
| KNS squatting | Med | Med | Reservation policy; verified names; rename audit log |

===== END FILE =====

===== FILE: 7_collaboration_governance/glossary.md =====
# Glossary

- **Device-Bound Token (DBT):** One of a user’s nine commitment slots; device-key-bound; non-transferable; revocable.  
- **Circle of Trust:** 9-slot strong-trust model (quiet unbonding and cooldown).  
- **Contact (Lite Trust):** Unlimited, consented connection; private by default; low weight.  
- **BrightID:** Privacy-preserving **uniqueness** system; verifies one-human-one-account without PII.  
- **Meets / Aura:** BrightID verification methods used in pilots.  
- **Quiet Unbonding:** ~72h delay before removal to reduce social shock.  
- **Checkpoint:** Hourly Merkle root of reduced state to HCS.  
- **Hashinal:** Portable Hedera-native, non-financial artifact.  
- **TRST:** Stablecoin rail on Hedera; Brale handles KYC/AML.  
- **KNS:** Send-to-Name addressing.  
- **XMTP:** End-to-end wallet chat (not SMS).  
- **Cohort Pepper:** Secret used for HMAC IDs; versioned and rotated.

===== END FILE =====
