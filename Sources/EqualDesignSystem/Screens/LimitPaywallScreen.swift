import SwiftUI

/// The upgrade paywall opened from a limit message in the Equal chat (Gold limit, Trial limit,
/// Trial ended, Plan expired): the pre-title hero, "What you get", Compare plans and FAQ, with the
/// limit configuration of `EqualStickyPlanSheet` pinned at the bottom.
///
/// All copy comes from `EqualPurchaseFlow`: hero lines, the plan selected on open (Gold for Plan
/// expired), the "Your plan" tag (Gold limit), the note and the CTA, which follow the selection.
public struct LimitPaywallScreen: View {
    public typealias Plan = EqualStickyPlanSheet.Plan

    let flow: EqualPurchaseFlow
    @State private var plan: Plan
    @State private var couponApplied = false
    @State private var page = 0
    let onClose: () -> Void
    let onPurchase: (Plan) -> Void

    public init(flow: EqualPurchaseFlow = .goldLimit, plan: Plan? = nil, onClose: @escaping () -> Void = {}, onPurchase: @escaping (Plan) -> Void = { _ in }) {
        self.flow = flow
        self._plan = State(initialValue: plan ?? flow.defaultPlan)
        self.onClose = onClose
        self.onPurchase = onPurchase
    }

    public var body: some View {
        ScrollView {
            content.padding(.bottom, 331 + 24)
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) { sheet }
        .background(EqualColor.grey14.ignoresSafeArea())
        .environment(\.colorScheme, .light)
    }

    var sheet: some View {
        EqualStickyPlanSheet(selection: $plan, couponApplied: $couponApplied, flow: flow, onPurchase: onPurchase)
    }

    var hero: EqualPaywallHero {
        EqualPaywallHero(title: flow.heroTitle, preTitle: flow.heroPreTitle ?? "", shape: flow.heroShape, tint: flow.heroTint, onClose: onClose)
    }

    /// Hero to FAQ, without the ScrollView or the sheet.
    var content: some View {
        let hero = hero
        return ZStack(alignment: .top) {
            hero
            VStack(spacing: EqualSpacing.s48) {
                VStack(spacing: 0) {
                    EqualSectionLabel("What you get", style: .gold).padding(.bottom, 12)
                    PaywallCarousel(cards: EqualFeatureCard.Content.paywall, page: $page)
                    EqualPageDots(count: EqualFeatureCard.Content.paywall.count, active: page).padding(.top, 13)
                }
                VStack(spacing: EqualSpacing.s24) {
                    EqualSectionLabel("Compare plans")
                    EqualComparePlansTable(selected: plan)
                }
                VStack(spacing: EqualSpacing.s24) {
                    EqualSectionLabel("Frequently asked questions", style: .gold)
                    EqualFAQList()
                }
            }
            .padding(.horizontal, EqualSpacing.s24)
            .padding(.top, hero.metrics.height + 10)
        }
    }
}

struct LimitPaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        LimitPaywallScreen(flow: .goldLimit)
        LimitPaywallScreen(flow: .planExpired)
    }
}
