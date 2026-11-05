# ValueCard

Dark gold card that sells the assistant when there is not enough usage data for the free-week stats. Same shell and slot as RecapCard (`gradient-recap`, radius 16, `shadow-recap`): a gold uppercase eyebrow over three icon columns (calls, spam, messages) split by gold hairlines.

- Variants: `.trialRunning` ("Let Equal take your next call"), `.trialEnded` ("Turn your assistant back on"); sizes `.inPaywall` (345×113, Regular 11 labels, rings and glow) and `.standalone` (345×118, SemiBold 12 labels at 90%, no rings).
- Pass: `EqualValueCard(.trialRunning, size: .inPaywall)`. Copy is fixed per size, as in Figma.
- Do place it where the stats card would go (overlapping the hero 22pt under the subtitle). Don't show it next to RecapCard: it replaces it.
