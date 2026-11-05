# AvailabilityPill

Header pill showing whether the assistant is answering: 8pt green dot (grey when busy) and "Available" / "Busy". **glass**: white 30% over a material, `#000@5%` hairline, soft shadow, green text and a `#555` caret. **plain**: solid white, `#BFE8CC` stroke, `#111111` text, no caret, 37pt.

- Sizes: `.regular` 36pt Regular 15; `.compact` 31pt Medium 14 (home with the permission card).
- Consumer passes: `isAvailable`, `size`, `style`, `action`.
- Do use plain after an upgrade, glass elsewhere.
- Don't recolour the dot: it is the state.
