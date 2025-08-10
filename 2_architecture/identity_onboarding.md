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
- **User flow:** In-app �Verify uniqueness� -> **Open BrightID** (link/QR) -> approve connection -> return to app.  
- **Accepted methods for pilots:** **Meets** (hosted verification) and **Aura**.  
- **What we store:**  
  - `brightidVerified: boolean`  
  - `brightid.method: "meets" | "aura"`  
  - `brightid.verifiedAt: ISO8601`  
  - `brightid.proofHash: string` (hash of BrightID response or app-link proof; no PII)  
- **Privacy:** No real names or phone numbers sent to BrightID; we only link the BrightID app account to our app scope.  
- **Failure / grace:** If BrightID is unavailable, show a �try again� option and (configurable) **grace-period** for low-value actions (Contacts allowed; Commit may remain gated).

## Recovery
- **Primary:** Magic.link recovery and passkey re-registration.  
- **Post-MVP:** DeRec guardian-based recovery (rebind DBTs after delay).  
- **After recovery:** Re-check BrightID status; cache result again.
