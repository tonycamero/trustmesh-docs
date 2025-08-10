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
