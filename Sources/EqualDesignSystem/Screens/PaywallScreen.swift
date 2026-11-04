import SwiftUI

/// Paywall = PaywallHero + RecapCard + ComparePlansTable + FeatureCard carousel + FAQ + StickyPlanSheet.
public struct PaywallScreen: View {
    @State private var plan: EqualStickyPlanSheet.Plan = .goldPlus
    @State private var page = 0
    let onClose: () -> Void
    let onPurchase: (EqualStickyPlanSheet.Plan) -> Void

    public init(onClose: @escaping () -> Void = {}, onPurchase: @escaping (EqualStickyPlanSheet.Plan) -> Void = { _ in }) {
        self.onClose = onClose
        self.onPurchase = onPurchase
    }

    private let features: [(String, String, Bool, EqualImage)] = [
        ("Unlimited AI calls", "No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.", true, .crown),
        ("Call Screening", "Spam, sales or someone who actually needs you. Your assistant finds out first.", false, .mascot),
        ("Speaks your language", "Hindi, English, Telugu and more, in a calm and friendly voice.", false, .mascotWave)
    ]

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                EqualPaywallHero(onClose: onClose)
                EqualRecapCard().padding(.horizontal, EqualSpacing.s24).offset(y: -40)
                VStack(spacing: EqualSpacing.s48) {
                    VStack(spacing: EqualSpacing.s24) {
                        EqualSectionLabel("Compare plans")
                        EqualComparePlansTable()
                    }
                    VStack(spacing: 13) {
                        EqualSectionLabel("What you get", style: .gold)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 28) {
                                ForEach(Array(features.enumerated()), id: \.offset) { _, f in
                                    EqualFeatureCard(title: f.0, message: f.1, isExclusive: f.2, art: f.3)
                                }
                            }
                            .padding(.horizontal, EqualSpacing.s24)
                        }
                        .padding(.horizontal, -EqualSpacing.s24)
                        EqualPageDots(count: features.count, active: page)
                    }
                    VStack(spacing: EqualSpacing.s24) {
                        EqualSectionLabel("Frequently asked questions", style: .gold)
                        EqualFAQList()
                    }
                }
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.bottom, 340)
            }
        }
        .overlay(alignment: .bottom) { EqualStickyPlanSheet(selection: $plan, onPurchase: onPurchase) }
        .ignoresSafeArea(edges: .bottom)
        .background(EqualColor.grey14.ignoresSafeArea())
        .environment(\.colorScheme, .light)
    }
}

struct PaywallScreen_Previews: PreviewProvider { static var previews: some View { PaywallScreen() } }
