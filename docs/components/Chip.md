# Chip

Post-call action chips under a chat ("Call back ›", "Add to Calendar ›", "Mute ›"). **suggested** uses `gradient-chip-suggested` with an `unread-stroke` border and marks actions on unread conversations; **neutral** uses `gradient-chip-neutral` with `stroke-medium` for read ones. 37px tall (44px in the Equal sheet), `callout` text, emoji glyph leading, SF chevron trailing.

- Props: `variant` suggested | neutral, `glyph` (emoji) or `icon`, `chevron` (default true), `tall`, `avatar` (contact chips), `children`.
- Chips scroll horizontally in one row; never wrap them.
- The emoji are part of the brand voice here: 📞 call, 🗓️ calendar, 🔕 mute, 🛑 DND, ✏️ address, 📝 instruction.
