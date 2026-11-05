# TrialHero

Top of the Gold free-week screens: crown (or crowned mascot), "Equal Gold / Free for a week!", "No card, no autopay, nothing to cancel." and the trial progress. The `.price` variant shows "₹249/month" and the recap strip instead.

- Backgrounds: `.goldDome` (soft paywall; black-to-gold dome in dark mode, 8 rays, timeline progress), `.goldGlow` (gold glow and rays, continuous progress), `.limeDisc` (green-to-lime disc; with `art: .mascot` the disc grows and gets rays), `.dark` (black page with a 70% gold glow, segmented lime progress).
- Pass `background`, `art`, `variant` (`.freeWeek` / `.price("₹249/month")`), `progressDay` (nil hides the progress) and recap `stats`.
- Do place it edge to edge at the very top (it includes the status-bar inset).
- Don't combine it with `EqualPaywallHero`; that is the paid paywall's hero.
