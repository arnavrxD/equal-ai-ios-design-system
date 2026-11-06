import SwiftUI

/// Soft paywall (21093:38189): the free Gold week with no card. Gold dome hero with the
/// Today → Day 7 timeline, "WHAT YOU GET" carousel and dots, the "On day 7 we'll ask…" card, FAQ
/// and the sticky "Start using Equal Gold" bar. In dark mode (21210:124354) the dome turns
/// black-to-gold and the terms block moves below the FAQ as the centred mascot block.
public struct SoftPaywallScreen: View {
    let onStart: () -> Void
    @Environment(\.colorScheme) private var scheme

    public init(onStart: @escaping () -> Void = {}) { self.onStart = onStart }

    public var body: some View {
        EqualScrollContent { page }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                EqualStickyCTABar(.gold, action: onStart).ignoresSafeArea(edges: .bottom)
            }
            .background(EqualColor.bgPrimary.ignoresSafeArea())
            .ignoresSafeArea(edges: .top)
    }

    var page: some View {
        let isDark = scheme == .dark
        return VStack(spacing: 0) {
            EqualTrialHero(background: .goldDome, progressDay: 1)
            EqualSectionLabel("What you get", style: .gold)
                .padding(.horizontal, 32)
                .padding(.top, 19)
            GoldTrialFeatureCarousel(showsDots: true, usesProductArt: true)
                .padding(.top, 15)
            if !isDark {
                EqualTrialInfoCard(.card)
                    .padding(.horizontal, EqualSpacing.s24)
                    .padding(.top, 56)
            }
            EqualSectionLabel("Frequently asked questions", style: .gold)
                .padding(.horizontal, 32)
                .padding(.top, isDark ? 52 : 57)
            EqualFAQList()
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.top, EqualSpacing.s24)
            if isDark {
                EqualTrialInfoCard(.stacked)
                    .padding(.top, 52)
            }
        }
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
    }
}

struct SoftPaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        SoftPaywallScreen()
        SoftPaywallScreen().environment(\.colorScheme, .dark)
    }
}
