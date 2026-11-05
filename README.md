# Equal AI iOS Design System

The SwiftUI design system behind the Equal AI iOS app, built from the **EQAI-iOS** Figma file (page *Oboarding/Paywall Changes*). Tokens, atoms, molecules, organisms and screens, with a documentation site that shows every component live next to its Swift source.

**Docs site:** https://eq-ios-ds.vercel.app

| | |
|---|---|
| Colour tokens | 93 (semantic light/dark, primitives, Gold, avatar tints, iOS) |
| Text styles | 32 (the file's 22 iOS styles in DM Sans + product accents + system chrome) |
| Atoms | 17 |
| Molecules | 18 |
| Organisms | 21 |
| Screens | 15 templates |
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

The type scale is **DM Sans** (SIL Open Font License). Add `DMSans-VariableFont_opsz,wght.ttf` and `DMSans-Italic-VariableFont_opsz,wght.ttf` from [Google Fonts](https://fonts.google.com/specimen/DM+Sans) to `Sources/EqualDesignSystem/Resources/Fonts`. Until then, text falls back to SF Pro at the same sizes, weights and tracking.

## Atomic structure

```
Sources/EqualDesignSystem/
├─ Tokens/       generated from tokens/tokens.json: EqualColor, EqualTextStyle, EqualSpacing, EqualRadius, EqualShadow
├─ Foundation/   dynamic colours, fonts, typography modifier, EqualGradient, EqualIcon (SF Symbols), EqualImage, EqualLogo, glass
├─ Atoms/        EqualButton, EqualIconButton, EqualChip, EqualTag, EqualAvatar, EqualUnreadCount, EqualToggle,
│                EqualPlanRadio, EqualCheckbox, EqualCompareCheck, EqualSectionLabel, EqualPageDots,
│                EqualProgressBar, EqualTextField, EqualThinkingText, EqualCrownLoader (+ EqualIconView)
├─ Molecules/    EqualSearchBar, EqualChatListItem, EqualChatBubble, EqualComposer, EqualQuickActionTile,
│                EqualSettingsRow, EqualAssistantToggleCard, EqualPlanCard, EqualCouponRow, EqualFAQItem,
│                EqualStatRow, EqualPushBanner, EqualGenderCard, EqualAvailabilityPill, EqualTrialPill,
│                EqualSheetHeader, EqualUpiStep, EqualKeyValueRow
├─ Organisms/    EqualAppHeader, EqualTabBar, EqualChatList, EqualSheet, EqualPermissionSheet, EqualPromoCard,
│                EqualRecapCard, EqualMembershipCard, EqualProfileHeader, EqualComparePlansTable,
│                EqualFeatureCard, EqualStickyPlanSheet, EqualPaywallHero, EqualValueRecapStory,
│                EqualAppStoreSheet, EqualPaymentProcessing, EqualSuccessState, EqualEmptyState,
│                EqualOnboardingHeader, EqualInviteCard, EqualLiveCallCard
├─ Screens/      Splash, PhoneNumber, NameGender, Permission, Home, EqualChat, Paywall, Settings,
│                Subscription, ValueRecap, PaymentProcessing, PurchaseSuccess, AppStoreConfirmation
├─ Catalog/      EqualCatalogView: every foundation, component and screen, browsable in-app
└─ Resources/    Images (3D illustrations, app icons) · Fonts
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

```bash
python3 scripts/generate_tokens.py        # tokens/tokens.json → Sources/EqualDesignSystem/Tokens/*.swift
swift build                               # compile check (works with Command Line Tools)
swift run equal-snapshots web/snapshots   # SwiftUI renders for the site
node scripts/build-web.mjs                # Swift sources + docs → web/data.js
```

Preview the site locally with `cd web && python3 -m http.server`.

## Notes

- The `#Preview` macro needs full Xcode, so previews use `PreviewProvider`.
- `ImageRenderer` cannot draw text fields or scroll views; the snapshot set leaves those out. Run them in Xcode or the catalog app.
- Gold/paywall surfaces are light-only, as in the Figma file; semantic tokens carry dark values.
