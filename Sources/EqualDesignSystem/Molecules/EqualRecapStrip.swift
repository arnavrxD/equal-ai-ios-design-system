import SwiftUI

/// Light, inline version of the free-week recap for the post-trial paywall hero: a gold
/// "YOUR FREE WEEK WITH EQUAL ▶" eyebrow over three value / label columns split by short rules.
public struct EqualRecapStrip: View {
    /// One value / label column.
    public struct Stat: Sendable, Hashable {
        public let value: String
        public let label: String
        public init(_ value: String, _ label: String) { self.value = value; self.label = label }
    }

    /// "2h 22m saved · 18 calls handled · 7 spam stopped" (Figma labels every column "saved"; fixed).
    public static let sampleStats = [Stat("2h 22m", "saved"), Stat("18", "calls handled"), Stat("7", "spam stopped")]

    let eyebrow: String
    let stats: [Stat]
    let onPlay: () -> Void

    public init(eyebrow: String = "Your free week with Equal", stats: [Stat] = EqualRecapStrip.sampleStats, onPlay: @escaping () -> Void = {}) {
        self.eyebrow = eyebrow
        self.stats = stats
        self.onPlay = onPlay
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s16) {
            Button(action: onPlay) {
                HStack(spacing: EqualSpacing.s4) {
                    Text(eyebrow.uppercased()).font(.equal(size: 12, weight: .semibold)).tracking(-0.026 * 12)
                        .foregroundStyle(EqualColor.goldInk.opacity(0.7))
                    Image(systemName: "play.circle.fill").font(.system(size: 12)).foregroundStyle(EqualColor.goldInk)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(eyebrow), play recap")
            HStack(spacing: 0) {
                ForEach(Array(stats.enumerated()), id: \.offset) { i, s in
                    if i > 0 { Rectangle().fill(EqualColor.grey10.opacity(0.4)).frame(width: 1, height: 37) }
                    VStack(spacing: 0) {
                        Text(s.value).equalTextStyle(.title2Em).foregroundStyle(Self.value).monospacedDigit()
                        Text(s.label).equalTextStyle(.callout).foregroundStyle(EqualColor.textSecondary)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .frame(maxWidth: 329)
    }

    static let value = Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7)
}

struct EqualRecapStrip_Previews: PreviewProvider {
    static var previews: some View {
        EqualPreviewPair { EqualRecapStrip() }
    }
}
