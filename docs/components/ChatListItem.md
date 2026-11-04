# ChatListItem

One conversation in the home list: Avatar (56) · name (`headline-em`) · one-line summary (`body`, `text-secondary`, ellipsised) · time (`footnote`) · unread count · a horizontally scrolling row of post-call action Chips. Unread rows show the time in `text-action` semibold and use **suggested** chips; read rows use **neutral** chips.

- Props: `name`, `message`, `time`, `unread`, `initials` / `avatarSrc`, `tint`, `contact`, `actions` [{label, glyph}].
- The summary is what the assistant learned on the call, not the caller's literal words.
