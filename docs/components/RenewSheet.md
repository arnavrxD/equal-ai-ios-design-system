# RenewSheet

Pinned bottom sheet on the expired subscription page (Figma 26242:98635, 393×127): white with 24pt top corners and the sticky shadow, a 52pt black-to-gold "Renew Plan – ₹249/month" capsule (SemiBold 16) with a light streak, and an underlined "Explore other plans" link (SemiBold 15).

- States: one.
- The consumer passes `title`, `linkTitle`, `onRenew` and `onExplore`.
- Do place it with `.safeAreaInset(edge: .bottom)`; the white runs under the home indicator.
- Don't use it for plan selection (that is `EqualStickyPlanSheet`), and keep the renew price the same as the Settings card (₹249/month for Gold).
