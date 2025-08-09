#!/usr/bin/env bash
set -euo pipefail

# Usage: bash bootstrap_trustmesh_docs.sh [target-dir]
ROOT=${1:-trustmesh-docs}

say() { printf "\033[1;32m?\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m!\033[0m %s\n" "$1"; }

if [[ -d "$ROOT" ]]; then
  warn "Directory '$ROOT' already exists. Files may be overwritten if you re-run."
fi

say "Creating directory structure under $ROOT/"
mkdir -p "$ROOT"/{assets/diagrams,assets/wireframes,scripts,.github/ISSUE_TEMPLATE}
mkdir -p "$ROOT"/{1_overview,2_architecture,3_ux_workflows,4_research_academic,5_development_plan,6_legal_compliance,7_collaboration_governance,secure}

# --- Top-level files ---
cat > "$ROOT/README.md" <<'MD'
# TrustMesh Documentation Repository

This repository hosts the **authoritative corpus** for TrustMesh: product vision, technical architecture, UX, research posture, governance, and compliance.

## How this repo is organized
- `1_overview/` — Vision, positioning, principles
- `2_architecture/` — System design, protocols, specs
- `3_ux_workflows/` — Flows, wireframes, interaction patterns
- `4_research_academic/` — Research alignment, KPIs, pilot plans
- `5_development_plan/` — Roadmaps, sprints, risks, deployment
- `6_legal_compliance/` — GDPR, TCPA, ToS, retention/deletion
- `7_collaboration_governance/` — Contrib guide, comms, style, glossary
- `assets/` — Diagrams, wireframes, and exported visuals
- `secure/` — **Sensitive docs** (git-ignored); store encrypted or off-repo

## Quick start
1. Read `1_overview/vision.md`.
2. Engineers start at `2_architecture/system_architecture.md` and `2_architecture/state_spec_v0.1.md`.
3. Designers start at `3_ux_workflows/sms_flow.md`.
4. For pilots/academics, see `4_research_academic/`.

## Contributing
See `7_collaboration_governance/contribution_guidelines.md` and `.github/PULL_REQUEST_TEMPLATE.md`.

MD

cat > "$ROOT/.gitignore" <<'GI'
# Node & tooling
node_modules/
.DS_Store
.env*
.cache/
dist/

# Assets
assets/exports/

# Sensitive materials kept out of git
secure/**

# Editor
.vscode/
.idea/
GI

cat > "$ROOT/SECURITY.md" <<'SEC'
# Security Policy

- Report vulnerabilities privately to security@trustmesh.example (replace with real address).
- Do not open public issues for undisclosed vulnerabilities.
- We follow a 90-day disclosure window, accelerated for severe issues.

SEC

cat > "$ROOT/LICENSE" <<'LIC'
TODO: Choose a license (e.g., Apache-2.0, MIT) before public release.
LIC

cat > "$ROOT/.github/PULL_REQUEST_TEMPLATE.md" <<'PR'
## Summary

Explain the change and the problem it solves.

## Checklist
- [ ] Updates relevant docs
- [ ] Follows style guide
- [ ] Adds/updates diagrams if architecture changed
- [ ] Links to related issues/decisions

## Screenshots/Diagrams (if applicable)

PR

cat > "$ROOT/.github/ISSUE_TEMPLATE/bug_report.md" <<'BUG'
---
name: Bug report
about: Create a report to help us improve
---

**Describe the bug**

**Steps to reproduce**

**Expected behavior**

**Environment**
- App version:
- OS/Device:

**Additional context**

BUG

cat > "$ROOT/.github/ISSUE_TEMPLATE/feature_request.md" <<'FR'
---
name: Feature request
about: Suggest an idea for TrustMesh
---

**Problem / Opportunity**

**Proposed solution**

**Alternatives considered**

**Risks & assumptions**

**Definition of done**

FR

# --- 1_overview ---
cat > "$ROOT/1_overview/vision.md" <<'MD'
# Vision & Mission

**Vision:** TrustMesh turns everyday acts of trust into a portable, verifiable social signal—privacy-first and human-centered.

**Mission:** Ship a mobile-first, Hedera-backed trust layer with **non-custodial wallets** and **9 revocable trust slots** per person, optimized for research-grade integrity and campus-scale adoption.

**Key Differentiators**
- Scarcity & revocability (9 slots, quiet unbonding)
- Cohort-salted pseudonymity; privacy by design
- HCS-first event stream; deterministic state spec
- Research alignment (IRB-ready modes, aggregate visibility)

**Target Audiences**: Students (RAs/residents), faculty/researchers, civic orgs.
MD

cat > "$ROOT/1_overview/positioning.md" <<'MD'
# Positioning & Narrative

- **Tagline:** Commit your trust. Shape the mesh.
- **One-liner:** A decentralized, revocable trust layer—no likes, no followers, just verified commitments.
- **Why now:** Privacy-preserving reputation and small-cohort networks outperform vanity metrics.

MD

# --- 2_architecture ---
cat > "$ROOT/2_architecture/system_architecture.md" <<'MD'
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
MD

cat > "$ROOT/2_architecture/identity_onboarding.md" <<'MD'
# Identity & Onboarding

- Primary auth: **Passkeys (WebAuthn)**; OTP assists discovery only.
- Social recovery: 2-of-3 guardians with time-locked recovery.
- Cohort-salted pseudonymous IDs via HMAC(phone, cohortPepper) stored in HSM.
- SIM-swap safeguards: optional email/SSO attestation and delayed rekeys.
MD

cat > "$ROOT/2_architecture/messaging_protocol.md" <<'MD'
# Messaging & Trust Minting Protocol

- Outbound SMS: single notification on commit, explicit opt-in for ongoing messages.
- Commands: `YES`, `WHO`, `STOP`, `HELP`.
- Anti-abuse: rate limits per device/number, profanity & PII filters.
MD

cat > "$ROOT/2_architecture/tokenization.md" <<'MD'
# Tokenization & Trust Slots

- Conceptual model: **9 per-user slots** (not transferable tokens in MVP).
- Events mutate slot state; no balances move.
- Future HTS path: frozen balances + registry contract enforces slot rules.
MD

cat > "$ROOT/2_architecture/privacy_security.md" <<'MD'
# Privacy, Security & Compliance Design

- Pseudonymization via whats a 
- Data minimization: plaintext reasons ephemeral ? store hashes + categories
- IRB/GDPR posture: functional deletion, consent screens, access controls
- Threats: Sybil, SIM-swap, spam; mitigations documented
MD

cat > "$ROOT/2_architecture/api_spec.md" <<'MD'
# API Spec (Draft)

## Events Ingestion
`POST /v1/events` — accepts signed HCS events for relaying & indexing

## Query
`GET /v1/edges/:id` — returns anonymized edge weights by tag
`GET /v1/me/slots` — returns slot bitmap + cooldowns

## Admin/Research
`GET /v1/checkpoints/latest` — Merkle root + schema hash
MD

cat > "$ROOT/2_architecture/data_models.md" <<'MD'
# Data Models (Derived)

- `users(idPubKey, cohortHash, slotBitmap, nonceCounter, createdAt)`
- `events(txId, userPubKey, tokenID, type, recipientHash, tag, reasonHash, ts, sig)`
- `edges(userHash, recipientHash, weightByTag, lastUpdated)`
MD

cat > "$ROOT/2_architecture/state_spec_v0.1.md" <<'MD'
# State Spec v0.1

## Event Types
- `ALLOCATE` — mint/enable slots `0..8` for `userPubKey`
- `COMMIT` — bind `tokenID` to `recipientHash` with `tag`, optional `reasonHash`
- `UNBOND` — start quiet-unbond timer for `tokenID`
- `REVOKE` — finalize removal of an active commitment (post-delay)
- `RECOVER` — rotate keys/guardians; includes previous key, new key, and proof
- *(Optional)* `VERIFY` — device/passkey attestation record
- *(Optional)* `REKEY` — cohort pepper rotation announcement

## Required Fields (all events)
`{ schema: "trustmesh/state/0.1", chainId, topicId, txId, ts, userPubKey, tokenID, nonce, sig }`

Plus per-type fields:
- `COMMIT`: `{ recipientHash, tag, reasonHash?, cooldownUntil? }`
- `UNBOND`: `{ tokenID, unbondAt }`
- `REVOKE`: `{ tokenID, revokeAt }`
- `RECOVER`: `{ oldPubKey, newPubKey, guardians[], proof }`

## Rules
- **Idempotency:** `(userPubKey, tokenID, nonce)` unique.
- **Validity:** tokenID ? [0..8]; only one active commitment per tokenID.
- **Cooldown:** per-slot; `COMMIT` invalid if now < `cooldownUntil`.
- **Ordering:** indexers must process by `(ts, txId)`; ties broken by `txId`.

## Checkpointing
- Indexers produce hourly Merkle roots over deterministic state.
- Publish `{ merkleRoot, schemaHash, height, ts }` to a dedicated HCS topic.
MD

cat > "$ROOT/2_architecture/registry_contract_interface.md" <<'MD'
# Trust Slot Registry — Contract Interface (Draft)

- **Purpose:** On-chain guardrails for max 9 active commitments per user; indexer becomes a verifier.

## Storage
- `mapping(address user => uint16 slotsBitmap)` // 9 LSB used
- `mapping(address user => uint64 nonceCounter)`

## Methods
- `commit(bytes32 digest, bytes sig)` ? sets bit for `tokenID` after verifying signature
- `unbond(bytes32 digest, bytes sig)` ? marks slot pending
- `revoke(bytes32 digest, bytes sig)` ? clears bit post-delay
- `checkpoint(bytes32 merkleRoot, bytes32 schemaHash)` ? optional anchoring

## Security
- EIP-191 style signed digests including `chainId`, `topicId`, `nonce`, and `expiry`.
- Replay protection via `nonceCounter`.
MD

# --- 3_ux_workflows ---
cat > "$ROOT/3_ux_workflows/sms_flow.md" <<'MD'
# SMS Flow

1. Sender commits ? recipient gets SMS: “Someone committed trust for [tag]. Reply YES or WHO.”
2. Recipient visits link, passkey onboarding, optional OTP assist.
3. Claim screen shows commitment; CTA: **Commit 1 back?**
4. Compliance: STOP/HELP honored; 10DLC registration maintained.
MD

cat > "$ROOT/3_ux_workflows/wallet_creation.md" <<'MD'
# Wallet Creation & Claim Flow

- Create Hedera wallet with passkey-backed Ed25519 key.
- Link to pseudonymous cohort ID (HMAC).
- Show **ring of nine** slots; highlight the claimed one.
MD

cat > "$ROOT/3_ux_workflows/engagement_loops.md" <<'MD'
# Engagement Loops & Gamification

- Scarcity education via ring-of-nine visuals
- Reciprocity nudge post-claim
- Structured reasons (templates) to reduce toxicity
- Aggregate-only public trends by tag; no names by default
MD

cat > "$ROOT/3_ux_workflows/user_journeys.md" <<'MD'
# User Journeys

- Initiator (seed user / RA)
- Recipient (first-commit experience)
- Researcher (aggregate dashboards)
MD

mkdir -p "$ROOT/3_ux_workflows/wireframes"
: > "$ROOT/3_ux_workflows/wireframes/.keep"

# --- 4_research_academic ---
cat > "$ROOT/4_research_academic/faculty_engagement.md" <<'MD'
# Faculty Engagement Materials

- Purpose letter, IRB coordination notes, data handling summary.
- Cohort codes and opt-in language.
MD

cat > "$ROOT/4_research_academic/data_privacy.md" <<'MD'
# Research Data Privacy Protocols

- Pseudonymization pipeline
- Access controls, aggregation thresholds
- Functional deletion process
MD

cat > "$ROOT/4_research_academic/kpi_metrics.md" <<'MD'
# KPIs & Analytics Definitions

- K-factor (48h target = 1.2)
- Claim?Commit conversion (= 55%)
- Avg commits Day 7 (3.0–4.5)
- Revocation rate (< 8%)
- Abuse flag rate (< 1%)
MD

cat > "$ROOT/4_research_academic/pilot_plan.md" <<'MD'
# Pilot Plan

- Seed strategy (RAs, cohorts)
- Success criteria & dashboards
- Feedback loops and iteration cadence
MD

# --- 5_development_plan ---
cat > "$ROOT/5_development_plan/mvp_scope.md" <<'MD'
# MVP Scope

- HCS-first events, indexer, mobile UI, passkeys, SMS claim.
- Quiet unbonding, per-slot cooldowns, rate limits.
MD

cat > "$ROOT/5_development_plan/sprint_plan.md" <<'MD'
# Sprint Plan (Draft)

- Sprint 1: Identity & wallet creation
- Sprint 2: Events + indexer + checkpoints
- Sprint 3: UX flows + moderation + analytics
- Sprint 4: Pilot instrumentation & feedback
MD

cat > "$ROOT/5_development_plan/risk_assessment.md" <<'MD'
# Risks & Mitigations

- SIM swap / number recycling ? SSO attestations, delayed rekeys
- SMS deliverability ? 10DLC, STOP/HELP, content tuning
- Abuse/toxicity ? filters, structured reasons, burn/report
MD

cat > "$ROOT/5_development_plan/testing_deployment.md" <<'MD'
# Testing & Deployment

- Unit: event validation, signature checks
- Integration: end-to-end commit/unbond/revoke
- Load: HCS throughput, indexer performance
- Deploy: staged topics per environment, feature flags
MD

# --- 6_legal_compliance ---
cat > "$ROOT/6_legal_compliance/gdpr.md" <<'MD'
# GDPR & Privacy Impact (Draft)

- Lawful basis: consent & legitimate interest (research mode)
- Pseudonymization, data minimization, functional deletion
- DPO contact, SAR procedure
MD

cat > "$ROOT/6_legal_compliance/tcpacompliance.md" <<'MD'
# TCPA / 10DLC Compliance

- Explicit opt-in; STOP/HELP handling
- Campaign registration & template review
- Record-keeping
MD

cat > "$ROOT/6_legal_compliance/terms_of_service.md" <<'MD'
# Terms of Service (Placeholder)

- User consent to pseudonymous processing
- Community standards & anti-abuse
- Revocation and content guidelines
MD

cat > "$ROOT/6_legal_compliance/data_retention_deletion.md" <<'MD'
# Data Retention & Deletion Policy

- Retention windows per event type
- Functional deletion mechanics
- Backup & restore procedures
MD

# --- 7_collaboration_governance ---
cat > "$ROOT/7_collaboration_governance/contribution_guidelines.md" <<'MD'
# Contribution Guidelines

- Use feature branches; write meaningful commit messages
- Propose changes via PRs referencing issues/decisions
- Keep docs atomic; update diagrams when architecture changes
MD

cat > "$ROOT/7_collaboration_governance/meeting_notes.md" <<'MD'
# Meeting Notes

Template:
- Date/Time
- Attendees
- Decisions
- Action items (owner, due)
MD

cat > "$ROOT/7_collaboration_governance/communication_protocols.md" <<'MD'
# Communication Protocols

- Weekly eng sync, biweekly research sync
- Decision records via short ADRs in PR descriptions
- Escalations via named channel & rotation
MD

cat > "$ROOT/7_collaboration_governance/escalation_paths.md" <<'MD'
# Escalation Paths

- Severity levels
- On-call contacts
- Incident comms template
MD

cat > "$ROOT/7_collaboration_governance/style_guide.md" <<'MD'
# Documentation Style Guide

- Write in clear, active voice; avoid jargon.
- One concept per page; keep sections under ~200 lines.
- Include a context block, decision, and implications.
- Diagrams in SVG with source committed.
MD

cat > "$ROOT/7_collaboration_governance/glossary.md" <<'MD'
# Glossary

- **Commit (verb):** Allocate one trust slot to a recipient.
- **Quiet Unbonding:** Delay period before a commitment is revoked.
- **Checkpoint:** Merkle-root summary of deterministic state.
- **Cohort Pepper:** Secret used for HMAC pseudonymization per cohort.
MD

cat > "$ROOT/7_collaboration_governance/CODEOWNERS" <<'OWN'
# Example CODEOWNERS — replace with real GitHub handles
* @trustmesh-core
1_overview/ @product-lead
2_architecture/ @arch-lead @security-lead
3_ux_workflows/ @design-lead
4_research_academic/ @research-lead
5_development_plan/ @pm-lead
6_legal_compliance/ @legal-counsel
7_collaboration_governance/ @ops-lead
OWN

# --- scripts ---
cat > "$ROOT/scripts/validate_docs.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail

# Simple lints: ensure each markdown has an H1 and < 2000 lines
fail=0
while IFS= read -r -d '' f; do
  if ! grep -q '^# ' "$f"; then
    echo "Missing H1: $f"; fail=1
  fi
  if [[ $(wc -l < "$f") -gt 2000 ]]; then
    echo "Too long (>2000 lines): $f"; fail=1
  fi
done < <(find . -name '*.md' -print0)
exit $fail
SH
chmod +x "$ROOT/scripts/validate_docs.sh"

# --- secure area guidance ---
cat > "$ROOT/secure/README.md" <<'MD'
# Secure Materials Area (git-ignored)

Store **sensitive** artifacts here (e.g., DPIAs with identifiers, carrier forms). Prefer encrypted storage or a separate private repo with limited access.
MD

say "Scaffold complete. Next: init git and push to your remote."
