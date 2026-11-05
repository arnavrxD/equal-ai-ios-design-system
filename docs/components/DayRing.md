# DayRing

The 48pt day counter of the trial countdown: a 3pt ring whose arc runs clockwise from 12 o'clock for daysLeft/7 over a faint track, with the Bold 28 numeral in the tone colour. `EqualTrialTone` (gold, green, amber, red) lives in the same file.

- States: 7 (full gold ring, no track), 6–3 green, 2 amber, 1 red with a 20% track.
- Pass `daysLeft`, optional `totalDays`, `tone` (defaults to `EqualTrialTone.forDay`) and `size`.
- Do use arc length days/7 (Figma draws day 3 short; that is a drawing slip).
- Don't recolour per screen; the tone carries the urgency.
