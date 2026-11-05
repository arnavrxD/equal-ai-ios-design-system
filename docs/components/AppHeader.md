# AppHeader

Home top bar on white with a `#000@5%` hairline: the 24pt equal ai logo, the plan badge 7pt after it, and on the right the availability pill, the trial pill or the avatar. The legacy home uses a 28pt logo, a 45pt avatar on `#D8F6E0` and a 10% hairline.

- Variants (trailing): `.availability`, `.available(size, style)` (31pt compact glass, plain white), `.trial(text)`, `.avatar`.
- Consumer passes: `plan` ("Gold", "Gold Plus" or any text for a neutral badge) or `badge: EqualPlanBadge.Kind?`, `trailing`, `onTrailing`.
- Do use `badge:` for TRIAL / TRIAL ENDED / EXPIRED and the light GOLD badge.
- Don't put more than one control on the right.
