# Data Models (Derived)

- `users(idPubKey, cohortHash, slotBitmap, nonceCounter, createdAt)`
- `events(txId, userPubKey, tokenID, type, recipientHash, tag, reasonHash, ts, sig)`
- `edges(userHash, recipientHash, weightByTag, lastUpdated)`
