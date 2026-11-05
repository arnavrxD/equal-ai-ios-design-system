import SwiftUI

/// Free-week progress from "Today" to "Day 7": seven green pills, a continuous gold bar, or the
/// translucent timeline that sits on the gold dome of the soft paywall.
public struct EqualTrialProgress: View {
    public enum Style: Sendable {
        /// Seven 32×8 pills, gap 9: green / green 12% (dark: lime / lime 18%). Labels SemiBold 15.
        case segmented
        /// 281×8 grey track with a gold-to-clear fill (gold-glow trial screen). Labels SemiBold 15.
        case continuous
        /// 225×8 white-50% track with a solid gold fill, for the gold dome. Labels Regular 15, always black.
        case timeline
    }

    let style: Style
    let day: Int
    let totalDays: Int
    let startLabel: String
    let endLabel: String

    /// - Parameters:
    ///   - day: the current trial day, 1...totalDays (day 1 fills one segment).
    ///   - endLabel: defaults to "Day \(totalDays)".
    public init(_ style: Style = .segmented, day: Int = 1, totalDays: Int = 7, startLabel: String = "Today", endLabel: String? = nil) {
        self.style = style
        self.totalDays = max(1, totalDays)
        self.day = min(max(day, 1), max(1, totalDays))
        self.startLabel = startLabel
        self.endLabel = endLabel ?? "Day \(max(1, totalDays))"
    }

    private var fraction: CGFloat { CGFloat(day) / CGFloat(totalDays) }

    public var body: some View {
        VStack(spacing: 14) {
            bar
            HStack {
                Text(startLabel)
                Spacer(minLength: 0)
                Text(endLabel)
            }
            .equalTextStyle(style == .timeline ? .subhead : .subheadEm)
            .foregroundStyle(style == .timeline ? Color.black : Self.label)
        }
        .frame(width: style == .timeline ? 225 : 286)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Free trial progress")
        .accessibilityValue("Day \(day) of \(totalDays)")
    }

    @ViewBuilder private var bar: some View {
        switch style {
        case .segmented:
            HStack(spacing: 9) {
                ForEach(0..<totalDays, id: \.self) { i in
                    Capsule().fill(i < day ? EqualColor.buttonPrimary : Self.segmentOff)
                        .frame(width: 32, height: 8)
                }
            }
            .frame(height: 8)
        case .continuous:
            Capsule().fill(Self.track)
                .frame(width: 281, height: 8)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(LinearGradient(colors: [EqualColor.goldInk, EqualColor.goldInk.opacity(0)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(54, 281 * fraction))
                }
                .padding(.leading, 5)
        case .timeline:
            Capsule().fill(Color.white.opacity(0.5))
                .shadow(color: .black.opacity(0.25), radius: 1)
                .frame(width: 225, height: 8)
                .overlay(alignment: .leading) {
                    Capsule().fill(EqualColor.goldInk).frame(width: max(34, 225 * fraction))
                }
        }
    }

    static let label = Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7)
    static let segmentOff = Color.equalDynamic(light: 0x00B140, lightAlpha: 0.12, dark: 0xBAFF29, darkAlpha: 0.18)
    static let track = Color.equalDynamic(light: 0xE8E8E8, dark: 0x333333)
}

struct EqualTrialProgress_Previews: PreviewProvider {
    static var previews: some View {
        EqualPreviewPair {
            VStack(spacing: 24) {
                EqualTrialProgress(.segmented, day: 1)
                EqualTrialProgress(.segmented, day: 4)
                EqualTrialProgress(.continuous)
                EqualTrialProgress(.timeline).padding(12).background(Color(equalHex: 0xFFE07A))
            }
        }
    }
}
