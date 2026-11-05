import SwiftUI

// Gold trial, soft paywall, trial countdown and expiry.
extension EqualCatalog {
    static let goldTrialItems: [EqualCatalogItem] = [
        // Atoms
        EqualCatalogItem("EqualTrialProgress", .atoms, "Today → Day 7: seven segments, continuous gold bar, or the dome timeline.") {
            VStack(spacing: 24) {
                EqualTrialProgress(.segmented, day: 1)
                EqualTrialProgress(.segmented, day: 4)
                EqualTrialProgress(.continuous)
                EqualTrialProgress(.timeline).padding(12).background(Color(equalHex: 0xFFDB6E), in: RoundedRectangle(cornerRadius: 12))
            }
            .frame(maxWidth: .infinity)
        },
        EqualCatalogItem("EqualDayRing", .atoms, "Trial day counter: toned ring with a days/7 arc.") {
            HStack(spacing: 10) { ForEach([7, 6, 3, 2, 1], id: \.self) { EqualDayRing($0) } }
        },
        EqualCatalogItem("EqualStarHalo", .atoms, "Gold glow with two rounded 8-point star outlines.") {
            EqualStarHalo().frame(maxWidth: .infinity).padding(.top, 60).background(Color(equalHex: 0xFAFAFA))
        },
        EqualCatalogItem("EqualCheckBadge", .atoms, "Green verified disc for the trial-started mascot.") {
            HStack(spacing: 16) { EqualCheckBadge(); EqualCheckBadge(size: 32) }
        },
        EqualCatalogItem("EqualSideButtonHint", .atoms, "\"Double click to Subscribe\" beside the side button.") {
            HStack { Spacer(); EqualSideButtonHint() }.padding(.vertical, 16).background(Color.black.opacity(0.55))
        },

        // Molecules
        EqualCatalogItem("EqualTrialCountdownCard", .molecules, "Days 7→1: gold, green, amber, red; Keep Gold on days 2 and 1.") {
            VStack(spacing: 12) { ForEach([7, 6, 5, 4, 3, 2, 1], id: \.self) { EqualTrialCountdownCard(daysLeft: $0) } }
        },
        EqualCatalogItem("EqualTrialInfoCard", .molecules, "\"On day 7 we’ll ask… ₹249/month\": card and stacked.") {
            VStack(spacing: 24) { EqualTrialInfoCard(.card); EqualTrialInfoCard(.stacked) }
        },
        EqualCatalogItem("EqualFeaturePill", .molecules, "Glassy gold feature pill with 3D icon.") {
            VStack(alignment: .leading, spacing: 12) {
                EqualFeaturePill.contacts
                EqualFeaturePill.screening
                EqualFeaturePill.languages
                EqualFeaturePill.voices
            }
            .frame(maxWidth: .infinity)
            .padding(12).background(Color.white, in: RoundedRectangle(cornerRadius: 16))
        },
        EqualCatalogItem("EqualPlanDetailsCard", .molecules, "Plan, price, expiry and Cancellation Policy.") { EqualPlanDetailsCard() },
        EqualCatalogItem("EqualRecapStrip", .molecules, "Light free-week recap for the price hero.") { EqualRecapStrip() },
        EqualCatalogItem("EqualSwipeToStart", .molecules, "Swipe-to-start capsule, green / lime in dark.") { EqualSwipeToStart() },
        EqualCatalogItem("EqualTrialPill", .molecules, "\"1 Day Left\" header pill with gold wash and gradient hairline.") { EqualTrialPill() },

        // Organisms
        EqualCatalogItem("EqualTrialHero", .organisms, "Equal Gold / Free for a week! on gold dome, gold glow, lime disc or dark.") {
            VStack(spacing: 16) {
                EqualTrialHero(background: .goldDome).clipped()
                EqualTrialHero(background: .goldDome, variant: .price("₹249/month")).clipped()
                EqualTrialHero(background: .goldGlow).padding(.bottom, 24).background(EqualColor.bgPrimary).clipped()
                EqualTrialHero(background: .limeDisc).padding(.bottom, 24).background(EqualColor.bgPrimary).clipped()
                EqualTrialHero(background: .limeDisc, art: .mascot).padding(.bottom, 24).background(EqualColor.bgPrimary).clipped()
                EqualTrialHero(background: .dark).padding(.bottom, 24).background(Color.black).clipped()
            }
            .frame(width: 393)
            .padding(.horizontal, -24)
        },
        EqualCatalogItem("EqualPriceDealCard", .organisms, "₹499 struck, rolling ₹249, coffee line, limited-time tag.") {
            VStack(spacing: 32) { EqualPriceDealCard(rollsOnAppear: false); EqualPriceDealCard(comparison: nil, rollsOnAppear: false) }
                .padding(.top, 12)
        },
        EqualCatalogItem("EqualStickyCTABar", .organisms, "Gold CTA, gold with terms, green renew.") {
            VStack(spacing: 16) { EqualStickyCTABar(); EqualStickyCTABar(.goldTerms); EqualStickyCTABar(.renew) }
                .padding(.horizontal, -24)
        },
        EqualCatalogItem("EqualExpiredHeader", .organisms, "Subscription Expired top with crown and red ✕.") {
            EqualExpiredHeader().frame(width: 393).clipped().padding(.horizontal, -24)
        },
        EqualCatalogItem("EqualPurchaseConfirmSheet", .organisms, "Equal purchase sheet: trial, price, terms, side-button cue.") {
            EqualPurchaseConfirmSheet().padding(8).background(Color.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 30))
        },
        EqualCatalogItem("EqualEmptyState", .organisms, "No chats yet, with the optional Meet Your Assistant call.") {
            VStack(spacing: 32) { EqualEmptyState(actionTitle: "Meet Your Assistant"); EqualEmptyState(illustrationSize: 117) }
        },

        // Screens
        EqualCatalogItem("Gold trial start", .screens, "Free week offer: gold glow, continuous progress, swipe to start.") { GoldTrialStartScreen() },
        EqualCatalogItem("Gold trial start · dark", .screens, "Dark exploration with segmented lime progress.") { GoldTrialStartScreen(background: .dark) },
        EqualCatalogItem("Gold trial start · lime", .screens, "Lime disc with the crowned mascot.") { GoldTrialStartScreen(background: .limeDisc, art: .mascot) },
        EqualCatalogItem("Soft paywall", .screens, "Gold dome, timeline, features, terms card, FAQ, sticky CTA.") { SoftPaywallScreen() },
        EqualCatalogItem("Soft paywall · dark", .screens, "Dark dome; terms block below the FAQ.") { SoftPaywallScreen().environment(\.colorScheme, .dark) },
        EqualCatalogItem("Trial started", .screens, "7 days of Equal Gold, Starts Today!") { TrialStartedScreen() },
        EqualCatalogItem("Trial home · day 7", .screens, "Countdown day 7, empty state with Meet Your Assistant.") { TrialHomeScreen(day: 7) },
        EqualCatalogItem("Trial home · day 7 permissions", .screens, "Day 7 with the Enable Permissions card.") { TrialHomeScreen(day: 7, showsPermissionCard: true) },
        EqualCatalogItem("Trial home · day 6", .screens, "Countdown day 6, green.") { TrialHomeScreen(day: 6) },
        EqualCatalogItem("Trial home · day 5", .screens, "Countdown day 5 with chats.") { TrialHomeScreen(day: 5) },
        EqualCatalogItem("Trial home · day 4", .screens, "Countdown day 4.") { TrialHomeScreen(day: 4) },
        EqualCatalogItem("Trial home · day 3", .screens, "Countdown day 3.") { TrialHomeScreen(day: 3) },
        EqualCatalogItem("Trial home · day 2", .screens, "Amber with Keep Gold.") { TrialHomeScreen(day: 2) },
        EqualCatalogItem("Trial home · day 1", .screens, "Red with Keep Gold.") { TrialHomeScreen(day: 1) },
        EqualCatalogItem("Plan expired", .screens, "Subscription Expired page with Renew.") { PlanExpiredHomeScreen() },
        EqualCatalogItem("Purchase confirm", .screens, "Equal purchase sheet with the side-button hint.") { PurchaseConfirmScreen() }
    ]
}
