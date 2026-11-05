# SettingsRow

68px row inside a white `radius-m` settings group (8px 16px padding, `stroke-medium` dividers): 36px icon container with a 20pt glyph · title (DM Sans SemiBold 17, line 22) with an optional green "New!" tag (17pt, radius 4, `#00B140` → `#004B1B`, SemiBold 11) · subtitle (Regular 12, line 16, `text-secondary`) · 16pt chevron at 40%.

- Props: `title`, `icon` (an `EqualIcon`) or `glyph` (`.icon`, `.symbol(name, secondary:)` for SF Symbols such as `sparkles`, `mappin.and.ellipse`, `shield`; `.whatsApp` for the coded WhatsApp outline), `subtitle`, `badge` ("New!"), `showsDivider`, `action`. Wrap rows in `EqualSettingsGroup`.
- Subtitles summarise the current value ("4 active instructions", "Calm & Friendly · Hindi, English, Telugu").
- Outline icons under Settings & Support are `#555555` (`secondary: true`); the rest are `#111111`.
