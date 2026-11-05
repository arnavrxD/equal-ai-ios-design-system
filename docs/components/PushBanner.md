# PushBanner

iOS notification banner used in the trial-ending flow: black 70% glass (radius 24, `0 8 40 #000@20%` shadow), the Equal app icon (`EqualAppIcon` 38), title SemiBold 15, "now" in `#4D4D4D` with a linear-dodge (plus-lighter) blend and a two-line body 14 `#DDDDDD`, all DM Sans with -0.23 tracking.

- Consumer passes: `title`, `message`, `time`.
- Do show it over the lock screen or a dimmed home.
- Don't use it on light lock screens; `EqualLockScreenNotification` is the light variant.
