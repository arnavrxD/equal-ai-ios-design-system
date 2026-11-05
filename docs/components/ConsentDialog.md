# ConsentDialog

The in-app consent dialog before the iOS alerts: "Allow Equal to process your call data?" (SemiBold 18/22) and a two-paragraph Regular 12/16 explanation on a 302pt `#F7F7F7` card (radius 30, padding 32/18, gap 19), with a grey **Don't allow** (`#DADADA@70%`, Regular 14) and a green **Allow** (Bold 14), 42pt tall, 12 apart. Figma sets the buttons in Geist; they are DM Sans here.

- Variants: card only, or `backdrop: true` to centre it over the `#1E1E1E@40%` scrim.
- Consumer passes: copy overrides, `onDecline`, `onAllow`.
- Do show it once, before the first system alert.
- Don't add a close button: the user must choose.
