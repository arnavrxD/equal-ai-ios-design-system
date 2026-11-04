import SwiftUI

/// Small labels: the black **GOLD** plan badge, membership **status** / **expired**, **bestValue**,
/// feature-card **exclusive** / **bothPlans**, **new** on settings rows, **deal** and caller **category**.
public struct EqualTag: View {
    public enum Kind: Sendable { case gold, status, expired, bestValue, exclusive, bothPlans, new, deal, category }

    let text: String
    let kind: Kind

    public init(_ text: String, kind: Kind) {
        self.text = text
        self.kind = kind
    }

    public var body: some View {
        switch kind {
        case .gold:
            Text(text.uppercased())
                .font(.equal(size: 9, weight: .heavy)).tracking(1.1)
                .foregroundStyle(EqualGradient.goldText)
                .padding(.horizontal, 12).frame(height: 19)
                .background(Capsule().fill(Color.black))
                .overlay(Capsule().stroke(EqualColor.goldLabel, lineWidth: 0.8))
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
            Text(text.uppercased()).font(.equal(size: 10, weight: .bold)).tracking(0.4).foregroundStyle(.white)
                .padding(.horizontal, 12).frame(height: 21)
                .background(RoundedRectangle(cornerRadius: EqualRadius.s).fill(EqualColor.goldStatusBg))
                .overlay(RoundedRectangle(cornerRadius: EqualRadius.s).stroke(EqualColor.goldStatusBorder, lineWidth: 0.7))
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
            HStack { EqualTag("Gold", kind: .gold); EqualTag("Gold Plus", kind: .gold); EqualTag("New", kind: .new) }
            HStack { EqualTag("Active", kind: .status); EqualTag("Free Trial", kind: .status); EqualTag("Expired", kind: .expired) }
            HStack { EqualTag("Best value", kind: .bestValue); EqualTag("Only in Gold Plus", kind: .exclusive); EqualTag("Both plans", kind: .bothPlans) }
            HStack { EqualTag("Limited time deal", kind: .deal); EqualTag("Promotional", kind: .category) }
        }
        .padding(24)
        .equalScreenBackground()
    }
}
