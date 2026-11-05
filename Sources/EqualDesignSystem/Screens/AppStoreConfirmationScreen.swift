import SwiftUI

/// The native purchase sheet over the paywall it was opened from: the dimmed paywall (the limit
/// paywall for limit flows), `EqualAppStoreSheet` with the flow's product, price and note, and the
/// blue `EqualSideButtonCue` beside the hardware button.
public struct AppStoreConfirmationScreen: View {
    public typealias Plan = EqualStickyPlanSheet.Plan

    let flow: EqualPurchaseFlow
    let plan: Plan
    let couponApplied: Bool
    let onClose: () -> Void

    /// - Parameters:
    ///   - plan: the plan being bought; defaults to the flow's pre-selected plan.
    ///   - couponApplied: shows the EQUAL25 price (₹374 / ₹187).
    public init(flow: EqualPurchaseFlow = .trialLastDay, plan: Plan? = nil, couponApplied: Bool = false, onClose: @escaping () -> Void = {}) {
        self.flow = flow
        self.plan = plan ?? flow.defaultPlan
        self.couponApplied = couponApplied
        self.onClose = onClose
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if flow.isLimit {
                    LimitPaywallScreen(flow: flow, plan: plan)
                } else {
                    PaywallScreen(config: PaywallConfig(selectedPlan: plan))
                }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            Color.black.opacity(flow.isLimit ? 0.4 : 0.35).ignoresSafeArea()
                .onTapGesture(perform: onClose)
            EqualAppStoreSheet(flow: flow, plan: plan, couponApplied: couponApplied, onClose: onClose)
                .padding(.horizontal, EqualSpacing.s8)
                .padding(.bottom, EqualSpacing.s8)
                .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .topTrailing) { EqualSideButtonCue().ignoresSafeArea() }
        .environment(\.colorScheme, .light)
    }
}

struct AppStoreConfirmationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppStoreConfirmationScreen()
        AppStoreConfirmationScreen(flow: .planExpired)
    }
}
