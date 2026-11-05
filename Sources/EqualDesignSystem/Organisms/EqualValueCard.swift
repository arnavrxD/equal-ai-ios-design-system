import SwiftUI

/// Dark gold card that sells the assistant when there is not enough usage data for the free-week
/// stats: a gold eyebrow over three icon columns (calls, spam, messages).
///
/// Same shell as `EqualRecapCard` (`EqualGradient.recap`, radius 16, `.recap` shadow) and the
/// same slot on the paywall. `.trialRunning` reads "Let Equal take your next call",
/// `.trialEnded` "Turn your assistant back on".
/// - `.inPaywall` (345×113): Regular 11 labels, 34pt dividers, rings and gold glow.
/// - `.standalone` (345×118): SemiBold 12 labels at 90%, 64pt dividers, no rings.
public struct EqualValueCard: View {
    public enum State: Sendable { case trialRunning, trialEnded }
    public enum Size: Sendable { case inPaywall, standalone }

    let state: State
    let size: Size

    public init(_ state: State = .trialRunning, size: Size = .inPaywall) {
        self.state = state
        self.size = size
    }

    private var eyebrow: String { state == .trialRunning ? "Let Equal take your next call" : "Turn your assistant back on" }

    private var columns: [(icon: String, label: String)] {
        size == .inPaywall
            ? [("phone", "Screens calls\nfor you"), ("checkmark.shield", "Stops spam\nand fraud"), ("message", "Takes & delivers\nyour messages")]
            : [("phone", "Answers calls\nyou can’t take"), ("checkmark.shield", "Stops spam\nand fraud"), ("message", "Takes your\nmessages")]
    }

    public var body: some View {
        let isPaywall = size == .inPaywall
        VStack(spacing: 0) {
            Text(eyebrow.uppercased()).font(.equal(size: 11, weight: .semibold)).tracking(0.88)
                .foregroundStyle(EqualColor.goldRecapLabel)
                .frame(height: 16)
                .padding(.top, isPaywall ? 11 : 14)
            HStack(spacing: 0) {
                ForEach(Array(columns.enumerated()), id: \.offset) { i, c in
                    VStack(spacing: isPaywall ? 3 : 8) {
                        Image(systemName: c.icon).font(.system(size: 14, weight: .light))
                            .foregroundStyle(EqualColor.goldLabel)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(EqualColor.goldLabel.opacity(0.14)))
                        Text(c.label)
                            .font(.equal(size: isPaywall ? 11 : 12, weight: isPaywall ? .regular : .semibold))
                            .lineSpacing(isPaywall ? 0 : 0.5)
                            .foregroundStyle(.white.opacity(isPaywall ? 1 : 0.9))
                            .multilineTextAlignment(.center)
                            .fixedSize()
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                    .overlay(alignment: .topLeading) {
                        if i > 0 {
                            Rectangle().fill(EqualColor.goldHairline).frame(width: 1, height: isPaywall ? 34 : 64)
                                .offset(y: isPaywall ? 4 : 2)
                        }
                    }
                }
            }
            .padding(.top, isPaywall ? 13 : 8)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: isPaywall ? 113 : 118)
        .background(alignment: .topLeading) { EqualGoldCardBackground(showsRings: isPaywall) }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .equalShadow(.recap)
        .accessibilityElement(children: .combine)
    }
}

struct EqualValueCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualValueCard()
            EqualValueCard(.trialEnded)
            EqualValueCard(.trialRunning, size: .standalone)
        }
        .padding(24)
        .frame(width: 393)
        .background(EqualColor.grey14)
    }
}
