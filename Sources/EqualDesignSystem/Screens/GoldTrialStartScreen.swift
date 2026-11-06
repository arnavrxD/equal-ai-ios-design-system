import SwiftUI

/// The Gold free-week offer, built from the most complete of the four explorations (20552:61164):
/// gold-glow hero over the doodle page with continuous progress, "WHAT YOU GET" carousel, the
/// stacked "On day 7 we'll ask…" block and swipe-to-start. `background` switches to the other
/// explorations: `.dark` (20796:47857), `.limeDisc` with the crown (20796:48312) or the mascot
/// (21019:84829).
public struct GoldTrialStartScreen: View {
    let background: EqualTrialHero.Background
    let art: EqualTrialHero.Art
    let onStart: () -> Void

    public init(background: EqualTrialHero.Background = .goldGlow, art: EqualTrialHero.Art = .crown, onStart: @escaping () -> Void = {}) {
        self.background = background
        self.art = art
        self.onStart = onStart
    }

    public var body: some View {
        EqualScrollContent { page }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom, spacing: 0) { swipeBar }
            .background { pageBackground }
            .ignoresSafeArea(edges: .top)
            .environment(\.colorScheme, background == .dark ? .dark : scheme)
    }

    @Environment(\.colorScheme) private var scheme

    var page: some View {
        VStack(spacing: 0) {
            EqualTrialHero(background: background, art: art, progressDay: 1)
            EqualSectionLabel("What you get", style: .gold)
                .padding(.horizontal, 32)
                .padding(.top, background == .goldGlow ? 33 : 35)
            GoldTrialFeatureCarousel()
                .padding(.top, 28)
            EqualTrialInfoCard(.stacked)
                .padding(.top, 39)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
    }

    private var pageBackground: some View {
        ZStack(alignment: .top) {
            EqualColor.bgPrimary
            if background != .limeDisc {
                EqualDoodlePattern()
                    .opacity(0.08)
                    .frame(height: 850, alignment: .top)
                    .clipped()
                    .mask(LinearGradient(stops: [.init(color: .black, location: 0.45), .init(color: .clear, location: 1)], startPoint: .top, endPoint: .bottom))
            }
        }
        .ignoresSafeArea()
    }

    /// 393×109 container fading from the page colour, holding the 335×66 swipe control.
    private var swipeBar: some View {
        EqualSwipeToStart(onComplete: onStart)
            .frame(maxWidth: 335)
            .padding(.top, 12)
            .padding(.bottom, 31)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(stops: [.init(color: EqualColor.bgPrimary.opacity(0), location: 0), .init(color: EqualColor.bgPrimary, location: 0.23)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
    }
}

/// The six "What you get" cards in a horizontal pager (303 wide, gap 28), shared by the trial screens.
struct GoldTrialFeatureCarousel: View {
    static let features: [(title: String, message: String, art: EqualImage)] = [
        ("Call Screening", "Spam, sales, or someone who actually needs you. Your assistant finds out first.", .mascotPhoneVoice),
        ("Handles calls from your contacts", "In a meeting? It takes the message and tells you what mattered.", .rotaryPhoneRedFront),
        ("Speaks your language", "Choose from 10+ languages and 4 voices to make your assistant feel more like you.", .letterAHindi),
        ("Instructions", "Tell Equal what to do or say. It does exactly that, for any call that you want.", .mascotReadingBook),
        ("Saved addresses", "Delivery and cab drivers get it without calling you multiple times to confirm.", .mascotMap),
        ("Post-call Actions", "Take relevant actions based on your calls. Set reminder, reply on WhatsApp, mute, and more.", .whatsappLogoGreen)
    ]

    var showsDots = false
    /// The soft paywall's phone-mockup art (Figma 21093:38189) instead of the Gold-trial mascots.
    var usesProductArt = false

    private var cards: [(title: String, message: String, art: EqualImage)] {
        usesProductArt ? EqualFeatureCard.Content.paywall.filter { !$0.isExclusive }.map { ($0.title, $0.message, $0.art) } : Self.features
    }

    var body: some View {
        VStack(spacing: 18) {
            EqualScrollContent(.horizontal) {
                HStack(spacing: 28) {
                    ForEach(cards, id: \.title) { f in
                        EqualFeatureCard(title: f.title, message: f.message, isExclusive: false, art: f.art, style: .trial)
                    }
                }
                .padding(.horizontal, EqualSpacing.s24)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            if showsDots { EqualPageDots(count: 5, active: 0) }
        }
    }
}

struct GoldTrialStartScreen_Previews: PreviewProvider {
    static var previews: some View {
        GoldTrialStartScreen()
        GoldTrialStartScreen(background: .dark)
        GoldTrialStartScreen(background: .limeDisc, art: .mascot)
    }
}
