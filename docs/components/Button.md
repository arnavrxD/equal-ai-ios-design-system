# Button

Pill-shaped actions: **primary** green (onboarding and permission CTAs), **gold** dark-to-gold gradient (paywall purchase CTAs), **goldPill** (small gold CTA on trial cards), **danger** and **link** (secondary text action). Sizes: `.large` 52pt (18pt label), `.medium` 36pt, `.small` 32pt, `.cta` 52pt with the paywall label (SemiBold 16, 32pt side padding).

- Gold at `.large` uses the paywall CTA spec automatically, with the light streak (16×72 white 52%, blur, 55pt in). `showsStreak` forces it on (green Renew CTA) or off (limit paywalls).
- Pass: `title`, `variant`, `size`, `icon`, `trailingIcon`, `fullWidth`, `isLoading`, `showsStreak`, `action`.
- One primary or gold CTA per screen; labels say what happens and name the plan and price ("Get Gold Plus for ₹499/month").
