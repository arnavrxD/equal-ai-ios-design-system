# LockScreenNotification

A light, frosted iOS lock-screen notification from Equal for the permission previews: white 50% over a background blur, the green Equal icon, title, "now" and the body, all DM Sans with -4% tracking.

- Variants: `.large` (339×71, radius 22.7, icon 42, title SemiBold 17.6, body Medium 13.8) and `.small` (269×78, radius 18, icon 33, "Equal AI" SemiBold 14, line SemiBold 10 and a two-line Regular 8 detail).
- Consumer passes: `title`, `message`, optional `detail` (small only), `time`, `size`.
- Do show it over the lock-screen wallpaper.
- Don't use it for in-app banners; `EqualPushBanner` is the dark push banner.
