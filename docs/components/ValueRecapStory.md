# ValueRecapStory

Full-screen last-day story: #0B0B0A with a green glow, 3pt gold progress, the Skip pill (white 10% + 15% stroke, Bold 13), the Bold 12 kicker, the 76pt time saved in a #FFF6D6 → #F4C21B → #C9960C gradient, four StatRows and "Don’t make it start over." (Bold 22, gold tail).

- Pass: `name`, `saved`, `stats`, `progress`, `onSkip`. ValueRecapScreen animates the progress over 10s and calls `onFinish`.
- Positions follow the 852pt frame from the top of the screen: ignore the top safe area.
