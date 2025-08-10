# TrustMesh Documentation Repository

This repository is the **authoritative source** for the TrustMesh product vision, architecture, UX, compliance, and deployment model � built on the Scend Context Engineering kernel.

## Core Mandate
TrustMesh is a **Hedera-first**, privacy-preserving trust graph that turns IRL trusted relationships into **cryptographically verifiable commitments**.

Every deployment must implement the **three context loops** in this order:
NOTE: Context Loops are sequential in activation (Messaging must be live before Payments, before Engagement) � this matches the operating philosophy in CONTEXT_ENGINNERING.md

1. **Messaging** � **XMTP-powered** threads by wallet or alias. *XMTP is not SMS.* SMS is used only for **invites/claims**; all chat occurs over XMTP. HCS10 emits system/campaign triggers.
2. **Payments** � **TRST stablecoin** via **Brale** (KYC/AML + custody/compliance) with **MatterFi SDK** for flows. Wallets auto-provisioned; **Send-to-Name (KNS)** and QR-pay supported.
3. **Engagement** � Hedera **NFT/hashinal** rewards and **Circle of Trust** allocations (9 **device-bound** commitment slots per user, quiet unbonding, immutable acceptance).

### Non-Negotiables
- **TRST is the only payment rail** for stablecoin flows in MVP (**Brale handles KYC/AML**).
- **Circle of Trust** governs strong trust: **9 device-bound tokens (DBTs)** per user; revocable with quiet unbonding and per-slot cooldowns.
- **Contacts (lite trust) are included**: unlimited, consented connections for discovery/routing; low weight; private by default.
- **Hedera-first**: HTS for assets, HCS10 for events, hashinals for portable reputation.
- **Licensed kernel** � not public open source. Cloning/deployments require contractual authorization.

## Repository Structure
- **1_overview/** � Vision, positioning, Circle of Trust principles  
- **2_architecture/** � Hedera-based system design, protocol, specs  
- **3_ux_workflows/** � Loop-driven UX (Messaging ? Payments ? Engagement)  
- **4_research_academic/** � Research alignment, IRB-ready privacy posture  
- **5_development_plan/** � MVP scope, sprints, risks, deployment  
- **6_legal_compliance/** � GDPR, CCPA, TCPA, data retention  
- **7_collaboration_governance/** � Contribution guidelines, glossary, style  
- **assets/** � Diagrams, wireframes, visuals  
- **secure/** � Sensitive docs (git-ignored; encrypt or store off-repo)

## Quick Start
1. Read `1_overview/vision.md` and `positioning.md`.  
2. Engineers: `2_architecture/system_architecture.md` + `state_spec_v0.1.md`.  
3. Designers: `3_ux_workflows/circle_of_trust_flow.md` + `wallet_creation.md`.  
4. Pilots/research: `4_research_academic/`.

## Licensing & Deployment
- **Private kernel** � licensed via Scend Technologies, LLC.  
- Cloneable for approved partners (civic, campus, enterprise).  
- **No public open-source distribution**.
