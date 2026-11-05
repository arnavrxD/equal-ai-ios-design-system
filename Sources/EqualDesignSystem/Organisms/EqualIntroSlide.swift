import SwiftUI

/// Walkthrough slide scaffold: speaker toggle, title, a phone mockup with an overlapping card,
/// a bottom fade and the 4pt progress bar.
public struct EqualIntroSlide<Card: View>: View {
    let title: String
    let progress: Double
    @Binding var isMuted: Bool
    let card: Card

    public init(title: String = "Unknown callers are screened automatically", progress: Double = 0.41, isMuted: Binding<Bool>, @ViewBuilder card: () -> Card) {
        self.title = title
        self.progress = progress
        self._isMuted = isMuted
        self.card = card()
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                EqualIconButton(isMuted ? .speakerOff : .speaker, variant: .glass, size: 48, label: isMuted ? "Unmute narration" : "Mute narration") { isMuted.toggle() }
            }
            .padding(.horizontal, 18)
            Text(title).equalTextStyle(.title2Em).foregroundStyle(EqualColor.textPrimary)
                .multilineTextAlignment(.center).frame(width: 343).padding(.top, 6)
            ZStack(alignment: .top) {
                EqualPhoneMockup()
                LinearGradient(stops: [.init(color: .white.opacity(0), location: 0.16), .init(color: EqualColor.bgPrimary, location: 1)], startPoint: .top, endPoint: .bottom)
                    .frame(height: 223)
                    .padding(.top, 414)
                card.padding(.horizontal, 17).padding(.top, 325)
            }
            .frame(height: 560, alignment: .top)
            .clipped()
            .padding(.top, 34)
            EqualProgressBar(value: progress).frame(width: 305).padding(.top, 8)
            Spacer(minLength: 0)
        }
        .equalAmbientGlow(.intro)
    }
}

struct EqualOnboardingOrganisms_Previews: PreviewProvider {
    static var previews: some View {
        EqualSocialProofCard().padding(24).background(EqualColor.brandGreen)
        EqualWelcomeIntro()
        EqualIntroSlide(isMuted: .constant(false)) { EqualLiveCallCard() }
    }
}
