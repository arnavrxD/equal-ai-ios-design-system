import SwiftUI

/// Home card that counts the free Gold week down from 7 to 1: a toned `EqualDayRing`, the day's
/// title and tip, and 3D art, or a "Keep Gold" button on the last two days. Gold on day 7, green on
/// days 6–3, amber on day 2, red on day 1.
public struct EqualTrialCountdownCard: View {
    let daysLeft: Int
    let title: String
    let message: String
    let onKeepGold: () -> Void

    /// - Parameters:
    ///   - daysLeft: 7...1.
    ///   - title: defaults to the Figma copy ("7 days of Gold, on us", "6 days of Gold left", …).
    ///   - message: defaults to the Figma tip for the day; pass real numbers ("answered 12 calls") when you have them.
    public init(daysLeft: Int, title: String? = nil, message: String? = nil, onKeepGold: @escaping () -> Void = {}) {
        let d = min(max(daysLeft, 1), 7)
        self.daysLeft = d
        self.title = title ?? Self.defaultTitle(d)
        self.message = message ?? Self.defaultMessage(d)
        self.onKeepGold = onKeepGold
    }

    private var tone: EqualTrialTone { .forDay(daysLeft) }
    private var showsCTA: Bool { daysLeft <= 2 }

    public var body: some View {
        HStack(spacing: EqualSpacing.s16) {
            EqualDayRing(daysLeft, tone: tone)
            VStack(alignment: .leading, spacing: EqualSpacing.s2) {
                Text(title).equalTextStyle(.calloutEm).foregroundStyle(EqualColor.textPrimary)
                Text(message).equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary)
                    .frame(maxWidth: showsCTA ? 136 : 170, alignment: .leading)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: showsCTA ? 136 : 222, alignment: .leading)
            Spacer(minLength: 0)
            if showsCTA {
                Button(action: onKeepGold) {
                    Text("Keep Gold").font(.equal(size: 12, weight: .semibold)).foregroundStyle(.white)
                        .frame(width: 92, height: 35)
                        .background(Capsule().fill(EqualTrialTone.amber.ink))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.leading, 14)
        .padding(.trailing, showsCTA ? 14 : 13)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 91)
        .background {
            ZStack {
                tone == .red ? EqualColor.bgPrimary : EqualColor.bgSurface
                LinearGradient(colors: tone.wash, startPoint: .leading, endPoint: .trailing).opacity(0.1)
            }
            .overlay(alignment: .topTrailing) {
                // 114pt tone disc at 16%, 72pt in from the trailing edge (Figma x 266 of 338).
                Circle().fill(tone.ink.opacity(0.16)).frame(width: 114, height: 114).offset(x: 42, y: 31)
            }
        }
        .overlay(alignment: .topTrailing) { if !showsCTA { art } }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).strokeBorder(EqualColor.strokeSubtle, lineWidth: 1))
        .accessibilityElement(children: .combine)
    }

    /// The 100×91 art box on the trailing edge: 3D render plus sparkles in the tone at 40%.
    private var art: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            if daysLeft >= 7 {
                EqualImage.crown.image.aspectRatio(contentMode: .fit)
                    .frame(width: 92, height: 92)
                    .rotationEffect(.degrees(-11))
                    .offset(x: 18, y: 0)
            } else {
                FramedArt(image: Self.art(daysLeft), size: 90, fraction: Self.artFraction(daysLeft)).offset(x: 17, y: 3)
                Image(systemName: "bubble.left")
                    .font(.system(size: 11.5)).foregroundStyle(tone.ink.opacity(0.4))
                    .offset(x: 20, y: 8)
            }
            sparkle(10, filled: true).offset(x: 36, y: 13)
            sparkle(11, filled: false).offset(x: 11, y: 73)
            sparkle(14, filled: true).offset(x: 24, y: 6)
            sparkle(7, filled: true).offset(x: 84, y: 12)
        }
        .frame(width: 100, height: 91)
        .accessibilityHidden(true)
    }

    @ViewBuilder private func sparkle(_ size: CGFloat, filled: Bool) -> some View {
        let star = TrialStarShape(points: 4, innerRatio: 0.382, cornerRadius: 0)
        Group {
            if filled { star.fill(tone.ink) } else { star.stroke(tone.ink, lineWidth: 0.54) }
        }
        .frame(width: size, height: size)
        .opacity(0.4)
    }

    static func defaultTitle(_ d: Int) -> String {
        switch d {
        case 7: return "7 days of Gold, on us"
        case 1: return "1 day of Gold left"
        default: return "\(d) days of Gold left"
        }
    }

    static func defaultMessage(_ d: Int) -> String {
        switch d {
        case 7: return "Everything is unlocked. Nothing to pay yet."
        case 6: return "Try instructions and tell your assistant what to say."
        case 5: return "Your assistant has answered 12 calls so far."
        case 4: return "Your assistant muted 10 spam calls in last 2 days."
        case 3: return "You have saved over 2 hours of unnecessary call time."
        case 2: return "Keep it from ₹249/month when the trial ends."
        default: return "From tomorrow, assistant stops answering calls."
        }
    }

    /// Share of Figma's 90pt frame the trimmed render fills.
    static func artFraction(_ d: Int) -> CGFloat {
        switch d {
        case 6: return 0.92
        case 4: return 0.69
        default: return 0.72
        }
    }

    static func art(_ d: Int) -> EqualImage {
        switch d {
        case 6: return .mascotReadingBook
        case 4: return .mascotSpamBlocked
        default: return .mascotPhoneVoice
        }
    }
}

struct EqualTrialCountdownCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            ForEach((1...7).reversed(), id: \.self) { EqualTrialCountdownCard(daysLeft: $0) }
        }
        .padding(24)
        .equalScreenBackground()
    }
}
