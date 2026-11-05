import SwiftUI

// Paywall variants, limit paywalls, App Store and success.
extension EqualCatalog {
    static let paywallItems: [EqualCatalogItem] = [
        // Atoms
        EqualCatalogItem("EqualSideButtonCue", .atoms, "Blue bar beside the side button while the App Store sheet is up.") {
            Color(equalHex: 0x8E8E93).frame(height: 220).overlay(alignment: .topTrailing) { EqualSideButtonCue(y: 60) }
        },

        // Molecules
        EqualCatalogItem("EqualPlanPicker", .molecules, "Gold / Gold Plus cards with the coupon; prices follow the coupon.") { PlanPickerDemo() },

        // Organisms
        EqualCatalogItem("EqualValueCard", .organisms, "Dark gold value card: in-paywall and standalone, trial running / ended.") {
            VStack(spacing: 16) {
                EqualValueCard()
                EqualValueCard(.trialEnded)
                EqualValueCard(.trialRunning, size: .standalone)
                EqualValueCard(.trialEnded, size: .standalone)
            }
        }
    ]
    + PaywallConfig.variants.dropFirst().map { v in
        EqualCatalogItem("Paywall · \(v.name.lowercased())", .screens, "Figma \(v.nodeId).") { PaywallScreen(config: v.config) }
    }
    + EqualPurchaseFlow.allCases.filter(\.isLimit).map { flow in
        EqualCatalogItem("Limit paywall · \(flow.displayName.lowercased())", .screens, "\(flow.heroPreTitle ?? "") / \(flow.heroTitle)") { LimitPaywallScreen(flow: flow) }
    }
    + EqualPurchaseFlow.allCases.filter(\.isLimit).map { flow in
        EqualCatalogItem("App Store confirmation · \(flow.displayName.lowercased())", .screens, "Purchase sheet over the \(flow.displayName) paywall.") { AppStoreConfirmationScreen(flow: flow) }
    }
    + [
        EqualCatalogItem("Purchase success · welcome back", .screens, "Plan expired, Gold renewed.") { PurchaseSuccessScreen(flow: .planExpired) },
        EqualCatalogItem("Purchase success · trial started", .screens, "7 days of Equal Gold.") { PurchaseSuccessScreen(.trialStarted(days: 7)) }
    ]
}

private struct PlanPickerDemo: View {
    @State var plan: EqualStickyPlanSheet.Plan = .goldPlus
    @State var coupon = true
    var body: some View {
        VStack(spacing: 28) {
            EqualPlanPicker(selection: $plan, couponApplied: $coupon, style: .inline)
            EqualPlanPicker(selection: .constant(.goldPlus), couponApplied: .constant(false), style: .limit, couponStyle: .compact, currentPlan: .gold)
        }
        .padding(.top, 12)
    }
}
