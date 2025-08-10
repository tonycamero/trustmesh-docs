# Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---:|---:|---|
| Brale/MatterFi outage/geo | Med | High | Queue+retry; outage banners; degrade to non-payment flows |
| XMTP spam/abuse | Med | Med | Opt-in DMs; block/report; rate limits; contact/mutual-first |
| SIM swap/key compromise | Med | High | Magic.link recovery; delayed rebind; anomaly alerts |
| Mirror lag/checkpoint divergence | Low | High | Deterministic reducer; hourly Merkle; independent verifiers |
| Reward farming | Med | Med | Proof-of-presence; device heuristics; cooldowns |
| KNS squatting | Med | Med | Reservation policy; verified names; rename audit log |
