# TrialProgress

Free-week progress from "Today" to "Day 7". Three looks from the Figma explorations: seven 32×8 pills, a 281pt grey track with a gold-to-clear fill, and the 225pt white-50% timeline that sits on the soft paywall's gold dome.

- Styles: `.segmented` (green / green 12%, lime / lime 18% in dark), `.continuous` (gold fade on `#E8E8E8`), `.timeline` (solid `#B17300` on white 50% with a soft shadow; labels stay black).
- Pass `day` (1...totalDays), optional `totalDays`, `startLabel`, `endLabel` (defaults to "Day 7").
- Do pick the style that matches the hero background (`EqualTrialHero` does this for you).
- Don't use it for generic loading; that is `EqualProgressBar`.
