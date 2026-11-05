import SwiftUI

/// Everything that differs between the paywall variants in Figma: hero shape, top bar, the card
/// under the hero, where the plans live, coupon style, section order, table style and the
/// pre-selected plan. Copy for the CTA and billing line comes from `flow` and always follows the
/// selected plan and coupon.
public struct PaywallConfig {
    public typealias Plan = EqualStickyPlanSheet.Plan

    /// The card overlapping the hero (or placed after Compare plans).
    public enum Summary { case stats, value(EqualValueCard.State), none }
    public enum SummaryPlacement: Sendable { case overlapHero, afterCompare }
    /// `.inline`: plans and coupon under the hero title, sticky sheet shrinks to the CTA.
    public enum PlanPlacement: Sendable { case sheet, inline }
    public enum Section: Sendable { case compare, features, faq }

    public var title: String
    public var subtitle: Text
    public var heroShape: EqualPaywallHero.Shape
    public var showsCrown: Bool?
    public var showsTopBar: Bool
    public var summary: Summary
    public var summaryPlacement: SummaryPlacement
    public var planPlacement: PlanPlacement
    public var couponStyle: EqualCouponRow.Style
    public var sections: [Section]
    public var featuresTitle: String
    public var tableStyle: EqualComparePlansTable.Style
    /// "Compare plans" starts inside the gold hero (standalone paywalls 55299 / 58219).
    public var compareInHero: Bool
    public var selectedPlan: Plan
    public var flow: EqualPurchaseFlow
    public var features: [EqualFeatureCard.Content]

    public init(title: String = "Choose your plan",
                subtitle: Text = Text("1 day").bold() + Text(" left in your free trial"),
                heroShape: EqualPaywallHero.Shape = .circle,
                showsCrown: Bool? = nil,
                showsTopBar: Bool = true,
                summary: Summary = .stats,
                summaryPlacement: SummaryPlacement = .overlapHero,
                planPlacement: PlanPlacement = .sheet,
                couponStyle: EqualCouponRow.Style = .overhang,
                sections: [Section] = [.compare, .features, .faq],
                featuresTitle: String = "What you get",
                tableStyle: EqualComparePlansTable.Style = .standard,
                compareInHero: Bool = false,
                selectedPlan: Plan = .goldPlus,
                flow: EqualPurchaseFlow = .trialLastDay,
                features: [EqualFeatureCard.Content] = EqualFeatureCard.Content.paywall) {
        self.title = title
        self.subtitle = subtitle
        self.heroShape = heroShape
        self.showsCrown = showsCrown
        self.showsTopBar = showsTopBar
        self.summary = summary
        self.summaryPlacement = summaryPlacement
        self.planPlacement = planPlacement
        self.couponStyle = couponStyle
        self.sections = sections
        self.featuresTitle = featuresTitle
        self.tableStyle = tableStyle
        self.compareInHero = compareInHero
        self.selectedPlan = selectedPlan
        self.flow = flow
        self.features = features
    }

    // MARK: The Figma variant matrix

    /// 23278 · A hero with crown, stats card overlapping, Compare › What you get › FAQ.
    public static var standard: PaywallConfig { PaywallConfig() }
    /// 26157 · value card instead of the stats (not enough usage data).
    public static var valueCard: PaywallConfig { PaywallConfig(summary: .value(.trialRunning)) }
    /// 29050 · compact arc, inset coupon, What you get first.
    public static var compactFeaturesFirst: PaywallConfig {
        PaywallConfig(heroShape: .compactArc, couponStyle: .inset, sections: [.features, .compare, .faq])
    }
    /// 35117 · shallow arc with crown, no card. Figma has no top bar here; we keep it (App Review needs a dismiss).
    public static var shallowArc: PaywallConfig {
        PaywallConfig(heroShape: .shallowArc, summary: .none, couponStyle: .inset, sections: [.features, .compare, .faq])
    }
    /// 37941 · rounded-bottom R28 with crown.
    public static var roundedCrown: PaywallConfig {
        PaywallConfig(heroShape: .roundedBottom(28), summary: .none, couponStyle: .inset, sections: [.features, .compare, .faq])
    }
    /// 40788 · rounded-bottom R48, no crown, Compare first.
    public static var roundedCompact: PaywallConfig {
        PaywallConfig(heroShape: .roundedBottom(48), summary: .none, couponStyle: .inset)
    }
    /// 43657 · plans and coupon inline, CTA-only sheet, dark checks.
    public static var inlinePlans: PaywallConfig {
        PaywallConfig(heroShape: .compactArc, summary: .none, planPlacement: .inline, featuresTitle: "What you’re getting", tableStyle: .dark)
    }
    /// 46558 · inline plans with Gold selected.
    public static var inlinePlansGold: PaywallConfig { var c = inlinePlans; c.selectedPlan = .gold; return c }
    /// 49459 · "Keep Equal answering", compact arc, stats, dark checks.
    public static var keepAnswering: PaywallConfig {
        PaywallConfig(title: "Keep Equal answering", heroShape: .compactArc, tableStyle: .dark)
    }
    /// 52379 · same with Gold selected.
    public static var keepAnsweringGold: PaywallConfig { var c = keepAnswering; c.selectedPlan = .gold; return c }
    /// 55299 · standalone: Compare plans in the hero, stats card after it.
    public static var compareInHeroStats: PaywallConfig {
        PaywallConfig(title: "Keep Equal answering", heroShape: .compactArc, summaryPlacement: .afterCompare, tableStyle: .dark, compareInHero: true)
    }
    /// 58219 · same with Gold selected.
    public static var compareInHeroStatsGold: PaywallConfig { var c = compareInHeroStats; c.selectedPlan = .gold; return c }
    /// 61139 · standalone compact "Choose your plan" + stats.
    public static var standaloneStats: PaywallConfig { PaywallConfig(heroShape: .compactArc) }
    /// 64004 · standalone compact + value card.
    public static var standaloneValue: PaywallConfig { PaywallConfig(heroShape: .compactArc, summary: .value(.trialRunning)) }

    /// Every variant in the Figma matrix, with its frame id.
    public static var variants: [(name: String, nodeId: String, config: PaywallConfig)] {
        [
            ("Default", "26242:23278", .standard),
            ("Value card", "26242:26157", .valueCard),
            ("Compact, features first", "26242:29050", .compactFeaturesFirst),
            ("Shallow arc", "26242:35117", .shallowArc),
            ("Rounded with crown", "26242:37941", .roundedCrown),
            ("Rounded compact", "26242:40788", .roundedCompact),
            ("Inline plans", "26242:43657", .inlinePlans),
            ("Inline plans, Gold", "26242:46558", .inlinePlansGold),
            ("Keep Equal answering", "26242:49459", .keepAnswering),
            ("Keep Equal answering, Gold", "26242:52379", .keepAnsweringGold),
            ("Compare in hero", "26242:55299", .compareInHeroStats),
            ("Compare in hero, Gold", "26242:58219", .compareInHeroStatsGold),
            ("Standalone stats", "26242:61139", .standaloneStats),
            ("Standalone value card", "26242:64004", .standaloneValue)
        ]
    }
}

/// The plan paywall: `EqualPaywallHero`, the free-week card, Compare plans, the "What you get"
/// carousel, FAQ and `EqualStickyPlanSheet`, arranged by a `PaywallConfig`.
public struct PaywallScreen: View {
    public typealias Plan = EqualStickyPlanSheet.Plan

    let config: PaywallConfig
    @State private var plan: Plan
    @State private var couponApplied = false
    @State private var page = 0
    let onClose: () -> Void
    let onPurchase: (Plan) -> Void

    public init(config: PaywallConfig = .standard, onClose: @escaping () -> Void = {}, onPurchase: @escaping (Plan) -> Void = { _ in }) {
        self.config = config
        self._plan = State(initialValue: config.selectedPlan)
        self.onClose = onClose
        self.onPurchase = onPurchase
    }

    public var body: some View {
        ScrollView {
            content.padding(.bottom, (config.planPlacement == .inline ? 151 : 300) + 24)
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) { sheet }
        .background(EqualColor.grey14.ignoresSafeArea())
        .environment(\.colorScheme, .light)
    }

    var sheet: some View {
        EqualStickyPlanSheet(selection: $plan, couponApplied: $couponApplied, flow: config.flow,
                             layout: config.planPlacement == .inline ? .ctaOnly : .full,
                             couponStyle: config.couponStyle, onPurchase: onPurchase)
    }

    /// The scrolling content (hero to FAQ), without the ScrollView or the sheet.
    var content: some View {
        let hero = EqualPaywallHero(title: config.title, subtitle: config.subtitle, shape: config.heroShape,
                                    showsCrown: config.showsCrown, showsTopBar: config.showsTopBar, onClose: onClose)
        let m = hero.metrics
        let overlapsSummary = config.summaryPlacement == .overlapHero && !isNone(config.summary) && !config.compareInHero
        return ZStack(alignment: .top) {
            hero
            VStack(spacing: 0) {
                if config.compareInHero {
                    Color.clear.frame(height: m.textBottom + 23).allowsHitTesting(false)
                } else if config.planPlacement == .inline {
                    Color.clear.frame(height: m.textBottom + 22).allowsHitTesting(false)
                    EqualPlanPicker(selection: $plan, couponApplied: $couponApplied, style: .inline, couponStyle: config.couponStyle)
                        .padding(.horizontal, EqualSpacing.s24)
                        .padding(.bottom, 21)
                } else if overlapsSummary {
                    Color.clear.frame(height: m.textBottom + 22).allowsHitTesting(false)
                    summaryCard.padding(.horizontal, EqualSpacing.s24).padding(.bottom, EqualSpacing.s24)
                } else {
                    Color.clear.frame(height: m.height + 20).allowsHitTesting(false)
                }
                mainColumn
            }
        }
    }

    private func isNone(_ s: PaywallConfig.Summary) -> Bool { if case .none = s { return true } else { return false } }

    @ViewBuilder private var summaryCard: some View {
        switch config.summary {
        case .stats: EqualRecapCard()
        case .value(let state): EqualValueCard(state)
        case .none: EmptyView()
        }
    }

    private var mainColumn: some View {
        VStack(spacing: EqualSpacing.s48) {
            ForEach(Array(config.sections.enumerated()), id: \.offset) { _, section in
                switch section {
                case .compare:
                    VStack(spacing: EqualSpacing.s24) {
                        EqualSectionLabel("Compare plans")
                        EqualComparePlansTable(selected: plan, style: config.tableStyle)
                    }
                    if config.summaryPlacement == .afterCompare && !isNone(config.summary) { summaryCard }
                case .features:
                    VStack(spacing: 0) {
                        EqualSectionLabel(config.featuresTitle, style: .gold).padding(.bottom, EqualSpacing.s24)
                        PaywallCarousel(cards: config.features, page: $page)
                        EqualPageDots(count: config.features.count, active: page).padding(.top, 13)
                    }
                case .faq:
                    VStack(spacing: EqualSpacing.s24) {
                        EqualSectionLabel("Frequently asked questions", style: .gold)
                        EqualFAQList()
                    }
                }
            }
        }
        .padding(.horizontal, EqualSpacing.s24)
    }
}

/// Horizontally paged "What you get" cards (gap 28, first card on the 24pt margin). Swipes move one
/// card; the page binding drives the dots. Built without a ScrollView so it renders in snapshots.
struct PaywallCarousel: View {
    let cards: [EqualFeatureCard.Content]
    @Binding var page: Int
    @GestureState private var drag: CGFloat = 0

    private func cardWidth(_ c: EqualFeatureCard.Content) -> CGFloat { EqualFeatureCard(c).width }

    private var offset: CGFloat {
        cards.prefix(page).reduce(0) { $0 + cardWidth($1) + 28 }
    }

    var body: some View {
        // The strip lives in an overlay so its full width never widens the page.
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 292)
            .overlay(alignment: .topLeading) {
                HStack(alignment: .top, spacing: 28) {
                    ForEach(cards) { EqualFeatureCard($0) }
                }
                .fixedSize()
                .padding(.leading, EqualSpacing.s24)
                .offset(x: -offset + drag)
                .animation(.snappy, value: page)
            }
            .padding(.horizontal, -EqualSpacing.s24)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 12)
                .updating($drag) { v, s, _ in s = v.translation.width }
                .onEnded { v in
                    let next = v.predictedEndTranslation.width < -60 ? page + 1 : (v.predictedEndTranslation.width > 60 ? page - 1 : page)
                    page = min(max(next, 0), cards.count - 1)
                }
        )
        .accessibilityElement(children: .contain)
        .accessibilityAdjustableAction { dir in
            switch dir {
            case .increment: page = min(page + 1, cards.count - 1)
            case .decrement: page = max(page - 1, 0)
            @unknown default: break
            }
        }
    }
}

struct PaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaywallScreen()
        PaywallScreen(config: .inlinePlansGold)
    }
}
