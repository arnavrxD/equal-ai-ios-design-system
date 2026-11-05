import SwiftUI

/// Small labels: the black **GOLD** plan badge (and its white **goldLight** twin), membership
/// **status** / **expired**, **bestValue**, feature-card **exclusive** / **bothPlans**, **new** on
/// settings rows, the ⏰ **deal** tag and caller **category**.
///
/// "Gold" and "Gold Plus" render as `EqualPlanBadge` (vector wordmark, gradient stroke); prefer
/// `EqualPlanBadge` directly for header badges.
public struct EqualTag: View {
    public enum Kind: Sendable { case gold, goldLight, status, expired, bestValue, exclusive, bothPlans, new, deal, category }

    let text: String
    let kind: Kind

    public init(_ text: String, kind: Kind) {
        self.text = text
        self.kind = kind
    }

    public var body: some View {
        switch kind {
        case .gold, .goldLight:
            switch text.uppercased() {
            case "GOLD": EqualPlanBadge(kind == .gold ? .gold : .goldLight)
            case "GOLD PLUS": EqualPlanBadge(.goldPlus)
            default:
                Text(text.uppercased())
                    .font(.equal(size: 9, weight: .bold)).tracking(0.45)
                    .foregroundStyle(kind == .gold ? Color(equalHex: 0xFFD35D) : Color(equalHex: 0xB88D1A))
                    .padding(.horizontal, 12).frame(height: 19)
                    .background(Capsule().fill(kind == .gold ? Color.black : Color.white))
                    .overlay(Capsule().strokeBorder(EqualPlanBadge.goldStroke, lineWidth: 0.78))
            }
        case .status, .expired:
            Text(text)
                .font(.equal(size: 12, weight: .medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 12).frame(height: 24)
                .background(RoundedRectangle(cornerRadius: EqualRadius.s).fill(kind == .expired ? EqualColor.red09 : EqualColor.goldStatusBg))
                .overlay(RoundedRectangle(cornerRadius: EqualRadius.s).stroke(kind == .expired ? EqualColor.red13 : EqualColor.goldStatusBorder, lineWidth: 0.7))
        case .bestValue:
            pill(fg: EqualColor.goldLabel, bg: EqualColor.goldDeep, radius: 7, size: 12, height: 22)
        case .exclusive:
            pill(fg: EqualColor.goldLabel, bg: EqualColor.goldDeep, radius: EqualRadius.tag, size: 11, height: 22)
        case .bothPlans:
            pill(fg: EqualColor.textSecondary, bg: EqualColor.bgPrimary, radius: EqualRadius.tag, size: 11, height: 24)
                .overlay(RoundedRectangle(cornerRadius: EqualRadius.tag).stroke(EqualColor.strokeMedium, lineWidth: 1))
        case .new:
            Text(text).font(.equal(size: 9, weight: .bold)).foregroundStyle(.white)
                .padding(.horizontal, 6).frame(height: 14)
                .background(RoundedRectangle(cornerRadius: EqualRadius.xs).fill(EqualColor.green))
        case .deal:
            // ⏰ glyph #AE6D28 + label on #272727, inner shadow (2.18,-2.18) blur 1.64 #4B4B4B,
            // 0.65 #FFF2C3 stroke and two soft #FFEDB8 glows behind.
            HStack(spacing: 4.4) {
                Image(systemName: "alarm.fill").font(.system(size: 7, weight: .bold)).foregroundStyle(Color(equalHex: 0xAE6D28))
                    .frame(width: 9, height: 9).background(Circle().fill(Color(equalHex: 0xFFF2C3)))
                Text(text.uppercased()).font(.equal(size: 10, weight: .bold)).foregroundStyle(.white)
            }
            .padding(.horizontal, 12).frame(height: 21)
            .background(
                RoundedRectangle(cornerRadius: EqualRadius.s)
                    .fill(EqualColor.goldStatusBg.shadow(.inner(color: Color(equalHex: 0x4B4B4B), radius: 0.82, x: 2.18, y: -2.18)))
            )
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.s).strokeBorder(EqualColor.goldStatusBorder, lineWidth: 0.65))
            .background {
                HStack(spacing: 20) {
                    Circle().fill(Color(equalHex: 0xFFEDB8)).frame(width: 54, height: 54)
                    Circle().fill(Color(equalHex: 0xFFEDB8)).frame(width: 54, height: 54)
                }
                .blur(radius: 35).opacity(0.5).allowsHitTesting(false)
            }
        case .category:
            Text(text).font(.equal(size: 10.7, weight: .semibold)).foregroundStyle(.white)
                .padding(.horizontal, 8).frame(height: 17)
                .background(Capsule().fill(Color.black))
        }
    }

    private func pill(fg: Color, bg: Color, radius: CGFloat, size: CGFloat, height: CGFloat) -> some View {
        Text(text).font(.equal(size: size, weight: .semibold)).foregroundStyle(fg)
            .padding(.horizontal, size == 12 ? 9 : 12).frame(height: height)
            .background(RoundedRectangle(cornerRadius: radius).fill(bg))
    }
}

struct EqualTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack { EqualTag("Gold", kind: .gold); EqualTag("Gold", kind: .goldLight); EqualTag("Gold Plus", kind: .gold); EqualTag("New", kind: .new) }
            HStack { EqualTag("Active", kind: .status); EqualTag("Free Trial", kind: .status); EqualTag("Expired", kind: .expired) }
            HStack { EqualTag("Best value", kind: .bestValue); EqualTag("Only in Gold Plus", kind: .exclusive); EqualTag("Both plans", kind: .bothPlans) }
            HStack { EqualTag("Limited time deal", kind: .deal); EqualTag("Promotional", kind: .category) }
        }
        .padding(24)
        .equalScreenBackground()
    }
}
