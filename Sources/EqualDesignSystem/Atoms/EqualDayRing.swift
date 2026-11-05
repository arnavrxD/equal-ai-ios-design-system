import SwiftUI

/// Colour of the trial countdown: **gold** on day 7, **green** days 6–3, **amber** day 2, **red** day 1.
public enum EqualTrialTone: Sendable, CaseIterable {
    case gold, green, amber, red

    /// The tone the countdown uses with `daysLeft` days of the trial remaining.
    public static func forDay(_ daysLeft: Int) -> EqualTrialTone {
        switch daysLeft {
        case 7...: return .gold
        case 3...6: return .green
        case 2: return .amber
        default: return .red
        }
    }

    /// Numeral, arc and accent colour.
    public var ink: Color {
        switch self {
        case .gold: return EqualColor.goldInk
        case .green: return EqualColor.green
        case .amber: return Color(equalHex: 0xCC8100)
        case .red: return EqualColor.red08
        }
    }

    /// Start and end of the card's 10% tone wash.
    var wash: [Color] {
        switch self {
        case .gold: return [Color(equalHex: 0xFEEC83), Color(equalHex: 0xA56B06)]
        case .green: return [Color(equalHex: 0x56FF93), Color(equalHex: 0x00782B)]
        case .amber: return [Color(equalHex: 0xFEEC83), Color(equalHex: 0xCC8100)]
        case .red: return [Color(equalHex: 0xFE8383), Color(equalHex: 0xCC0000)]
        }
    }

    /// Opacity of the ring's unfilled track.
    var trackOpacity: Double { self == .red ? 0.2 : 0.1 }
}

/// The 48pt day counter of the trial countdown card: a 3pt ring whose arc runs clockwise from
/// 12 o'clock for `daysLeft / 7`, over a faint track, with the bold numeral inside.
public struct EqualDayRing: View {
    let daysLeft: Int
    let totalDays: Int
    let tone: EqualTrialTone
    let size: CGFloat

    /// - Parameter tone: defaults to `EqualTrialTone.forDay(daysLeft)`.
    public init(_ daysLeft: Int, totalDays: Int = 7, tone: EqualTrialTone? = nil, size: CGFloat = 48) {
        self.daysLeft = max(0, daysLeft)
        self.totalDays = max(1, totalDays)
        self.tone = tone ?? .forDay(daysLeft)
        self.size = size
    }

    public var body: some View {
        let s = size / 48
        let fraction = min(1, CGFloat(daysLeft) / CGFloat(totalDays))
        ZStack {
            if fraction < 1 {
                Circle().inset(by: 1.5 * s).stroke(tone.ink.opacity(tone.trackOpacity), lineWidth: 3 * s)
            }
            Circle().inset(by: 1.5 * s).trim(from: 0, to: fraction)
                .stroke(tone.ink, lineWidth: 3 * s)
                .rotationEffect(.degrees(-90))
            Text("\(daysLeft)")
                .font(.equal(size: 28 * s, weight: .bold)).tracking(-0.026 * 28 * s)
                .monospacedDigit()
                .foregroundStyle(tone.ink)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(daysLeft) of \(totalDays) days left")
    }
}

struct EqualDayRing_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) { ForEach((1...7).reversed(), id: \.self) { EqualDayRing($0) } }
            .padding(24).equalScreenBackground()
    }
}
