# PlanBadge

The plan badge 7pt after the logo in the home header (`EqualPlanBadge`). Capsules with 12pt side padding and a 0.78pt inside stroke. GOLD is the vector wordmark on black with a gold gradient stroke (`#E3C269 → clear → #E3C269`); the light GOLD is the same on white with a `#B88D1A` wordmark; GOLD PLUS is DM Sans Bold 9 `#FFD35D` on black; TRIAL, TRIAL ENDED and EXPIRED are neutral (`#F1F1F1` fill, `#E0E0E0` stroke, `#737373` text).

- Variants: `.gold` (49×19), `.goldLight` (49×19), `.goldPlus` (79×24), `.trial` (52×24), `.trialEnded` (87×24), `.expired` (66×24), `.neutral(String)`.
- Consumer passes: the kind. `EqualAppHeader(badge:)` places it; `EqualLimitFlow.chatBadge` / `chatUpgradedBadge` give the per-flow badge.
- Do use `.goldLight` on homes after the trial starts and `.gold` (black) on the permission and limit-flow homes.
- Don't draw "GOLD" as text: the wordmark is a vector (`EqualGoldWordmark`).
