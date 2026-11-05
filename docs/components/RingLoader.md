# RingLoader

`EqualRingLoader` is the shared ring spinner (the Figma `loader` component): a full-circle track with a flat-ended quarter arc that turns once a second, and an optional centre slot. The processing sheet uses the small size; the payment wait screen uses the large size with the crown (see CrownLoader).

- Variants: `.small` (29pt frame, 24pt ring, 2.4pt thick, `#D0D0D0` track, `#070707` arc) and `.large` (160pt frame, 133pt ring, 6.65pt thick, black 12% track, `#5E460C` arc). Dark mode: white 18% track with a `#F7F7F7` (small) or `#C88D00` (large) arc. A custom `EqualRingLoader.Style` is also accepted.
- Pass: the style, an optional `size` (scales everything), and optional centre content.
- States: spinning; still under Reduce Motion.
- Do use it for indeterminate waits. Don't use it for progress you can measure (use `EqualProgressBar`), and don't round the arc ends: Figma's are flat.
