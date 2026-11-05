import SwiftUI

/// Dark "Your free week with Equal" card that overlaps the paywall hero: three tabular stats.
public struct EqualRecapCard: View {
    let eyebrow: String
    let stats: [(value: String, label: String)]

    public init(eyebrow: String = "Your free week with Equal", stats: [(value: String, label: String)] = [("2h 22m", "saved"), ("18", "calls handled"), ("7", "spam stopped")]) {
        self.eyebrow = eyebrow
        self.stats = stats
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s10) {
            HStack(spacing: 6) {
                Text(eyebrow.uppercased()).font(.equal(size: 11, weight: .semibold)).tracking(0.88)
                Image(systemName: "play.circle.fill").font(.system(size: 13))
            }
            .foregroundStyle(EqualColor.goldRecapLabel)
            HStack(spacing: 0) {
                ForEach(Array(stats.enumerated()), id: \.offset) { i, s in
                    if i > 0 { Rectangle().fill(EqualColor.goldHairline).frame(width: 1, height: 34) }
                    VStack(spacing: 0) {
                        Text(s.value).font(.equal(size: 22, weight: .semibold)).monospacedDigit()
                        Text(s.label).font(.equal(size: 11)).opacity(0.85)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .foregroundStyle(.white)
        }
        .padding(.horizontal, EqualSpacing.s18)
        .padding(.vertical, EqualSpacing.s16)
        .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(EqualGradient.recap))
        .equalShadow(.recap)
    }
}
