# Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---:|---:|---|
| Brale/MatterFi outage or geo restriction | Med | High | Queue + retry; UX banner; degrade to non-payment flows |
| XMTP spam/abuse | Med | Med | Opt-in DMs; block/report; per-address rate limits; contact/mutual-first routing |
| SIM swap / key compromise | Med | High | **Magic.link** recovery; delayed rebind; anomaly alerts; optional SSO/email attestation |
| Mirror-node lag / checkpoint divergence | Low | High | Deterministic reducer; **hourly** Merkle; independent verifiers |
| Reward farming | Med | Med | Proof-of-presence gates; device heuristics; cooldowns |
| KNS squatting/impersonation | Med | Med | Reservation policy; verified names; rename audit log |
