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
