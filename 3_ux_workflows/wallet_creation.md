# Wallet Creation & Claim

## Screen flow
1) Invite/QR -> App opens.  
2) **Create passkey** (Magic.link / WebAuthn).  
3) **Verify uniqueness** (BrightID)  
   - Why: �One person = one account. Keeps the mesh healthy.�  
   - CTA: �Open BrightID� (link/QR) -> approve -> return automatically.  
   - If verified: show checkmark and short explanation.  
   - If skipped: explain limits (e.g., can add Contacts; Commit is locked until verified).  
4) **DBTs allocated:** show the **ring of nine** and contact import.  
5) Optional: �Enable TRST actions� (EarthID/Brale) only when needed.

## Microcopy (examples)
- �Verify you�re one unique person (2�3 minutes) to unlock your 9 commitment slots.�  
- �Already verified in another Scend app? Tap to reuse.�
