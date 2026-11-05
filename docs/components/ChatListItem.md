# ChatListItem

One conversation. **regular**: 56pt avatar, name (headlineEm), one-line summary (body), time and unread count, then a row of action chips that runs to the screen edge (suggested chips on unread rows, neutral on read). **compact** (legacy home): 36pt avatar, gap 18, name SemiBold 16 `#3C3C3C`, summary Regular 15 `#858484`, time Medium 12 `#B8B8B8`, a 9pt green unread dot or a bell-slash when muted, no chips.

- Consumer passes: an `EqualChat` (now with `isMuted`), `style`, `onAction`. `EqualChat.samplesWithoutActions` and `legacySamples` are sample sets.
- Do keep chips to two or three actions.
- Don't show chips in the compact style.
