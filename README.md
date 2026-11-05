# Equal AI iOS Design System

The SwiftUI design system behind the Equal AI iOS app, built from the **EQAI-iOS** Figma file (page *Oboarding/Paywall Changes*). Tokens, atoms, molecules, organisms and screens, with a documentation site that shows every component live next to its Swift source.

**Docs site:** https://eq-ios-ds.vercel.app

| | |
|---|---|
| Colour tokens | 93 (semantic light/dark, primitives, Gold, avatar tints, iOS) |
| Text styles | 30 (the file's 22 iOS styles in DM Sans + product accents) |
| Atoms | 31 |
| Molecules | 34 |
| Organisms | 35 |
| Screens | 27 screen types, 112 catalogued states |
| Swift | 151 files, 14,154 lines |
| Platforms | iOS 17+, macOS 14+ (for previews and snapshot rendering) |

## Install

Xcode → **File → Add Package Dependencies…** → `https://github.com/arnavrxD/equal-ai-ios-design-system`, or in `Package.swift`:

```swift
.package(url: "https://github.com/arnavrxD/equal-ai-ios-design-system.git", branch: "main")
```

```swift
import SwiftUI
import EqualDesignSystem

@main
struct EqualApp: App {
    init() { EqualFonts.register() }
    var body: some Scene { WindowGroup { HomeScreen() } }
}
```

### Fonts

DM Sans (variable, SIL Open Font License) is bundled in `Resources/Fonts`; call `EqualFonts.register()` at launch. All text is DM Sans; SF Pro appears only inside SF Symbols icons.

## Atomic structure

```
Sources/EqualDesignSystem/
├─ Tokens/       generated from tokens/tokens.json: EqualColor, EqualTextStyle, EqualSpacing, EqualRadius, EqualShadow
├─ Foundation/   dynamic colours, DM Sans registration, typography, gradients, SF Symbol icons, vector logo/mark/app icon/flag,
│                decorations (rings, scalloped star, glow), ambient glows, doodle pattern, images, animated GIF player
├─ Atoms/        31: EqualButton, EqualIconButton, EqualChip, EqualTag, EqualAvatar, EqualUnreadCount, EqualToggle, EqualPlanRadio, EqualCheckbox, EqualCompareCheck, EqualSectionLabel, EqualPageDots, EqualProgressBar, EqualTextField, EqualThinkingText, EqualCrownLoader, EqualFieldMessage, EqualIconView, EqualMadeInIndiaPill, EqualTrialProgress, EqualDayRing, EqualStarHalo, EqualCheckBadge, EqualSideButtonHint, EqualSideButtonCue, EqualRingLoader, EqualPlanBadge, EqualGoldWordmark, EqualNotificationSkeleton, EqualBubbleTail, EqualProfileAvatarBadge
├─ Molecules/    34: EqualSearchBar, EqualChatListItem, EqualChatBubble, EqualComposer, EqualQuickActionTile, EqualSettingsRow, EqualAssistantToggleCard, EqualPlanCard, EqualCouponRow, EqualFAQItem, EqualStatRow, EqualPushBanner, EqualGenderCard, EqualAvailabilityPill, EqualSheetHeader, EqualUpiStep, EqualKeyValueRow, EqualOTPField, EqualOnboardingHeader, EqualPhoneMockup, EqualTrialCountdownCard, EqualTrialInfoCard, EqualFeaturePill, EqualPlanDetailsCard, EqualRecapStrip, EqualSwipeToStart, EqualTrialPill, EqualPlanPicker, EqualApplePayHintCard, EqualUpiStepList, EqualLockScreenNotification, EqualSectionHeader, EqualChatWallpaper, EqualNoticingCard
├─ Organisms/    35: EqualAppHeader, EqualTabBar, EqualChatList, EqualSheet, EqualPermissionSheet, EqualPromoCard, EqualRecapCard, EqualMembershipCard, EqualProfileHeader, EqualComparePlansTable, EqualFeatureCard, EqualStickyPlanSheet, EqualPaywallHero, EqualValueRecapStory, EqualAppStoreSheet, EqualPaymentProcessing, EqualSuccessState, EqualInviteCard, EqualLiveCallCard, EqualSocialProofCard, EqualWelcomeIntro, EqualIntroSlide, EqualTrialHero, EqualPriceDealCard, EqualStickyCTABar, EqualExpiredHeader, EqualPurchaseConfirmSheet, EqualEmptyState, EqualValueCard, EqualUpiPhoneIllustration, EqualProcessingSheet, EqualPermissionPreview, EqualConsentDialog, EqualPromoCarousel, EqualRenewSheet
├─ Screens/      27: SplashScreen, SplashSocialProofScreen, PhoneNumberScreen, OTPScreen, NameGenderScreen, WelcomeScreen, IntroScreeningScreen, PermissionScreen, HomeScreen, EqualChatScreen, ValueRecapScreen, PaywallScreen, AppStoreConfirmationScreen, PaymentProcessingScreen, PurchaseSuccessScreen, SettingsScreen, SubscriptionScreen, GoldTrialStartScreen, SoftPaywallScreen, TrialStartedScreen, TrialHomeScreen, PlanExpiredHomeScreen, PurchaseConfirmScreen, ActivatingGoldScreen, UpiWaitScreen, ProcessingSheetScreen, LimitFlowChatScreen
├─ Catalog/      EqualCatalogView + Entries/ per area: every foundation, component and screen state, browsable in-app
└─ Resources/    Fonts (DM Sans, OFL) · Images (only non-codable art: 3D renders, photos, screenshots)
```

Screens use organisms only, organisms use molecules and atoms, and everything reads tokens. Every file has a `PreviewProvider`.

## Repository

| Path | What |
|---|---|
| `tokens/tokens.json` | The single source for colours, type, spacing, radius, shadow, gradients |
| `Sources/` | The Swift package |
| `Examples/EqualCatalogApp/` | An `@main` app that opens `EqualCatalogView` |
| `Tools/Snapshots/` | `swift run equal-snapshots <dir>` renders every catalog entry to PNG with `ImageRenderer` |
| `design/` | Figma exports: screens, flow boards, 73 images, 75 SVG icons, `assets-manifest.json` |
| `docs/` | Brand book and per-component guidelines |
| `scripts/` | `generate_tokens.py` (tokens → Swift) and `build-web.mjs` (Swift → site data) |
| `web/` | The documentation site (static, deployed to Vercel) |

## Workflow

### Code first

Everything that can be drawn is SwiftUI: the logo, mark, app icon and Indian flag are vector paths; rings, rays, badges, seals, glows, coupon shapes, the UPI phone illustration and the neural-net art are shapes. Only 3D renders, photos, screenshots and the 392-icon doodle wallpaper ship as images (`EqualImage`).

```bash
python3 scripts/generate_tokens.py        # tokens/tokens.json → Sources/EqualDesignSystem/Tokens/*.swift
swift build                               # compile check (works with Command Line Tools)
./scripts/render-snapshots.sh            # SwiftUI renders (WebP) + catalog manifest for the site
node scripts/build-web.mjs                # Swift sources + docs → web/data.js
```

Preview the site locally with `cd web && python3 -m http.server`. Deploy it with `scripts/deploy.sh`: it deploys a copy of `web/` from outside the git repo, because Vercel's Hobby plan blocks deploys whose commit author isn't on the account. Run `vercel link --project eq-ios-ds` once first on a fresh clone.

## Notes

- The `#Preview` macro needs full Xcode, so previews use `PreviewProvider`.
- `ImageRenderer` cannot draw text fields or scroll views; the snapshot set leaves those out. Run them in Xcode or the catalog app.
- Gold/paywall surfaces are light-only, as in the Figma file; semantic tokens carry dark values.
