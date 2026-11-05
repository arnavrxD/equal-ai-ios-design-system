# PermissionSheet

Bottom sheet that asks for a system permission (`#F7F7F7`, top radius 28, no shadow): a 48pt close button 22pt from the top, the 3D art at its Figma size in a 120pt frame, title (title2Em), body (17 `#555`), a primary button and an optional "Continue anyway" link. Padding 12/24/32/24.

- Presets: `.notificationRequired` (bell), `.enablePermissions` (gear), `.contactRequired`, `.limitedContacts` and `.whatYoureLosing` (contacts book, "Update settings" for the last two), `.allowAccess` (warning triangle, "Allow access" with no icon and no link — the hard gate).
- Consumer passes: a preset (or image, title, message, `primaryTitle`, `primaryIcon` or `nil`, `secondaryTitle` or `nil`), `backdrop` (`.walkthrough` `#1E1E1E@40%`, `.home` `#000@30%`) and the three actions.
- Do drop the link on home sheets (`showsSecondary: false`).
- Don't give the hard gate an escape link.
