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
