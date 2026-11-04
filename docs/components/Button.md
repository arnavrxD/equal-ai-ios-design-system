# Button

Pill-shaped actions in four looks: **primary** green (onboarding and permission CTAs), **gold** dark-to-gold gradient (every paywall purchase CTA), **goldpill** (small gold CTA on trial cards) and **link** (secondary text action under a primary). Heights: `lg` 52px (full-width CTAs), `md` 36px, `sm` 32px.

- Props: `variant` primary | gold | goldpill | danger | link, `size` lg | md | sm, `block`, `icon` (Icon name), `disabled`, `children`.
- One primary or gold CTA per screen. Pair it with a `link` for the escape route ("Continue anyway").
- Disabled primary uses `button-disabled` with `text-on-action-disabled` (the grey "Send OTP" before a number is entered).
- Labels are sentence case and say what happens: "Send OTP", "Open settings", "Get Gold Plus for ₹499/month".
