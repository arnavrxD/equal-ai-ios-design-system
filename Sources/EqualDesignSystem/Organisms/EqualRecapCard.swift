import SwiftUI

/// Dark "Your free week with Equal" card that overlaps the paywall hero: three tabular stats in
/// 115pt columns, the gold eyebrow with a replay button, concentric rings and a faint gold glow.
///
/// 345×102, radius 16, `EqualGradient.recap` and the `.recap` shadow. Values are DM Sans SemiBold 22
/// (Geist in Figma, DM Sans by the type rule).
public struct EqualRecapCard: View {
    let eyebrow: String
    let stats: [(value: String, label: String)]
    let onReplay: (() -> Void)?

    /// - Parameter onReplay: shows the replay button after the eyebrow (reopens the value-recap story).
    public init(eyebrow: String = "Your free week with Equal",
                stats: [(value: String, label: String)] = [("2h 22m", "saved"), ("18", "calls handled"), ("7", "spam stopped")],
                onReplay: (() -> Void)? = {}) {
        self.eyebrow = eyebrow
        self.stats = stats
        self.onReplay = onReplay
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Text(eyebrow.uppercased()).font(.equal(size: 11, weight: .semibold)).tracking(0.88)
                    .foregroundStyle(EqualColor.goldRecapLabel)
                if let onReplay {
                    Button(action: onReplay) { EqualReplayDot() }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Replay your week")
                }
            }
            .frame(height: 16)
            .padding(.top, 11)
            HStack(spacing: 0) {
                ForEach(Array(stats.enumerated()), id: \.offset) { i, s in
                    VStack(spacing: 1) {
                        Text(s.value).font(.equal(size: 22, weight: .semibold)).monospacedDigit().frame(height: 29)
                        Text(s.label).font(.equal(size: 11)).frame(height: 14)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        if i > 0 { Rectangle().fill(EqualColor.goldHairline).frame(width: 1, height: 34).offset(y: -2) }
                    }
                }
            }
            .padding(.top, 13)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 102)
        .background(alignment: .topLeading) { EqualGoldCardBackground() }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .equalShadow(.recap)
        .accessibilityElement(children: .combine)
    }
}

/// The dark gold card surface shared by the recap and value cards: `EqualGradient.recap`, a faint
/// gold glow and the concentric rings bleeding off the bottom-right corner.
struct EqualGoldCardBackground: View {
    var showsRings = true
    var body: some View {
        ZStack(alignment: .topLeading) {
            EqualGradient.recap
            if showsRings {
                Ellipse().fill(Color(equalHex: 0xFFC927, alpha: 0.08)).frame(width: 142, height: 142).blur(radius: 57)
                    .offset(x: 250, y: 20)
                // 4 white hairline rings (82/111/134/152) under a clear → white linear mask
                ZStack {
                    ForEach([82, 111, 134, 152] as [CGFloat], id: \.self) { d in
                        Circle().stroke(Color.white, lineWidth: 1).frame(width: d, height: d)
                    }
                }
                .frame(width: 152, height: 152)
                .mask(LinearGradient(colors: [.white.opacity(0), .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .offset(x: 286, y: 58)
            }
        }
        .accessibilityHidden(true)
    }
}

/// 16pt replay button: #F7CB3C at 18% with a gold play triangle.
struct EqualReplayDot: View {
    var body: some View {
        ZStack {
            Circle().fill(EqualColor.goldLabel.opacity(0.18))
            Image(systemName: "play.fill").font(.system(size: 6)).foregroundStyle(EqualColor.goldLabel).offset(x: 0.5)
        }
        .frame(width: 16, height: 16)
    }
}

struct EqualRecapCard_Previews: PreviewProvider {
    static var previews: some View {
        EqualRecapCard().padding(24).frame(width: 393).background(EqualColor.grey14)
    }
}
