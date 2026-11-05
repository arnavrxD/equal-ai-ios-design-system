import SwiftUI

/// The plan badge beside the logo in the home header: black **GOLD** (vector wordmark),
/// black **GOLD PLUS**, the light white-and-gold **GOLD**, and the neutral grey **TRIAL**,
/// **TRIAL ENDED** and **EXPIRED** states.
///
/// All variants are capsules with 12pt side padding and a 0.78pt inside stroke. GOLD is 19pt
/// tall; GOLD PLUS and the neutral states are 24pt.
public struct EqualPlanBadge: View {
    public enum Kind: Hashable, Sendable {
        /// Black capsule, gold gradient stroke, `#FFD35D` wordmark (49×19).
        case gold
        /// White capsule, gold gradient stroke, `#B88D1A` wordmark (49×19). Homes after the trial starts.
        case goldLight
        /// Black capsule, "GOLD PLUS" in `#FFD35D` (79×24).
        case goldPlus
        /// Neutral "TRIAL" (52×24).
        case trial
        /// Neutral "TRIAL ENDED" (87×24).
        case trialEnded
        /// Neutral "EXPIRED" (66×24).
        case expired
        /// Neutral capsule with any label.
        case neutral(String)
    }

    let kind: Kind

    public init(_ kind: Kind) { self.kind = kind }

    public var body: some View {
        Group {
            switch kind {
            case .gold:
                EqualGoldWordmark(width: 25)
                    .padding(.horizontal, 12).frame(height: 19)
                    .background(Capsule().fill(Color.black))
                    .overlay(Capsule().strokeBorder(Self.goldStroke, lineWidth: 0.78))
            case .goldLight:
                EqualGoldWordmark(width: 25, color: Color(equalHex: 0xB88D1A))
                    .padding(.horizontal, 12).frame(height: 19)
                    .background(Capsule().fill(Color.white))
                    .overlay(Capsule().strokeBorder(Color.white, lineWidth: 0.78))
                    .overlay(Capsule().strokeBorder(Self.goldStroke, lineWidth: 0.78))
            case .goldPlus:
                label("GOLD PLUS", color: Color(equalHex: 0xFFD35D))
                    .background(Capsule().fill(Color.black))
                    .overlay(Capsule().strokeBorder(Self.goldStroke, lineWidth: 0.78))
            case .trial, .trialEnded, .expired, .neutral:
                label(text, color: Color(equalHex: 0x737373))
                    .background(Capsule().fill(Color(equalHex: 0xF1F1F1)))
                    .overlay(Capsule().strokeBorder(Color(equalHex: 0xE0E0E0), lineWidth: 0.78))
            }
        }
        .fixedSize()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    /// `#E3C269 → #E3C269@0 (49%) → #E3C269`, the stroke of the gold badges.
    static let goldStroke = LinearGradient(stops: [
        .init(color: Color(equalHex: 0xE3C269), location: 0),
        .init(color: Color(equalHex: 0xE3C269, alpha: 0), location: 0.49),
        .init(color: Color(equalHex: 0xE3C269), location: 1)
    ], startPoint: .leading, endPoint: .trailing)

    private var text: String {
        switch kind {
        case .gold, .goldLight: "GOLD"
        case .goldPlus: "GOLD PLUS"
        case .trial: "TRIAL"
        case .trialEnded: "TRIAL ENDED"
        case .expired: "EXPIRED"
        case .neutral(let s): s.uppercased()
        }
    }

    private var accessibilityText: String {
        switch kind {
        case .gold, .goldLight: "Gold plan"
        case .goldPlus: "Gold Plus plan"
        default: text.capitalized
        }
    }

    private func label(_ s: String, color: Color) -> some View {
        Text(s)
            .font(.equal(size: 9, weight: .bold)).tracking(0.45)
            .foregroundStyle(color)
            .padding(.horizontal, 12).frame(height: 24)
    }
}

struct EqualPlanBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack { EqualPlanBadge(.gold); EqualPlanBadge(.goldLight); EqualPlanBadge(.goldPlus) }
            HStack { EqualPlanBadge(.trial); EqualPlanBadge(.trialEnded); EqualPlanBadge(.expired) }
        }
        .padding(24)
        .background(Color.white)
    }
}
