# ProfileHeader

Top of Settings (Figma 26242:90520): a 283pt white block with bottom radius 21.8 and a 557pt ellipse washed with a linear gradient (white → `#FFC927`; mint `#F1FFF5` → `#CEFFDB` once the plan expired), the `ProfileAvatarBadge`, the name (ExtraBold 28.4) and phone number (Medium 17.5). A "←  Settings" row (Medium 20, `#1E1E1E`) appears for the free-trial and expired states.

- Props: `name`, `phone`, `isExpired`, `avatar`, `onBack` (shows the back row).
- It is laid out for the top of the screen (the status bar covers its first 54pt), so let it ignore the top safe area. The membership card overlaps it from y 200.
