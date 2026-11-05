# PromoCard

Home banner cards, 160pt tall, radius 18: a tinted fill with a 1pt gradient stroke outside (tint → white → tint), a soft 8% shadow, a 137pt decorative circle and a blurred glow at the top-right, a 172pt text column (SemiBold 18/22 title, Regular 12/16 subtitle, gap 4) with a pill CTA 18pt below, the 3D art on the right and a 20% dismiss ✕. Cards fill the width they are given (322 in `EqualPromoCarousel`, 338–345 alone).

- Variants: `.permissions` (orange `#E06500`, gear, "Open settings"), `.notificationAccess` (bell), `.contactAccess` (contacts book), `.meetAssistant` (green, mascot, 33pt "Call me" SemiBold 13), `.callPreferences` (blue `#0067B1`, "Explore"), `.inviteFriend` (indigo `#1300A2`, high-five, "Share now"), `.trialEnding` (white with a 10% red wash, crown, gold glows and sparkles, gold "Subscribe"), `.planExpired` (red-to-gold stroke, crossed crown, green "Renew Gold"), `.goldDays(n)` (Gold-trial countdown, unchanged).
- Consumer passes: the kind, `onDismiss`, and the CTA `action`.
- Do show the permission card for what is actually missing; it comes first in the carousel.
- Don't put two standalone cards on one home: use `EqualPromoCarousel`.
