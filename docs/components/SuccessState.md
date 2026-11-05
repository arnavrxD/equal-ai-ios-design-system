# SuccessState

Post-purchase confirmation: the crowned mascot (190pt) with a 40pt green check, a white rounded-star outline (228 / 152, white 75% / 45%) and a 520pt warm radial glow, then "Congratulations!" (14 #555), the Bold 28 title and a 16pt subtitle.

- Kinds: `.upgraded(plan, subtitle:)` ("You’re on Gold Plus 🎉" / "Unlimited AI calls start now"; free-trial flow passes "Your assistant stays on your calls"), `.welcomeBack(plan)` ("Welcome back 🎉" / "Your Gold plan is active again"), `.trialStarted(days:)` (200pt mascot, StarHalo, "7 days of / Equal Gold / Starts Today!").
- Pass the kind, or use `EqualPurchaseFlow.successKind(for:)`. The halo draws outside the view's frame: leave room around it.
- Do use PurchaseSuccessScreen for the full page (footer, auto-continue after 2.8s).
