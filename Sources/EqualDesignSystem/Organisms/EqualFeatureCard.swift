import SwiftUI

/// "What you get" carousel card (280 wide, radius 20). **Exclusive** (Gold Plus only) has a gold
/// border, cream art panel with the crown and a "30 calls a month → Unlimited" strip.
public struct EqualFeatureCard: View {
    let title: String
    let message: String
    let isExclusive: Bool
    let art: EqualImage

    public init(title: String = "Unlimited AI calls", message: String = "No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.", isExclusive: Bool = true, art: EqualImage = .crown) {
        self.title = title
        self.message = message
        self.isExclusive = isExclusive
        self.art = art
    }

    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: EqualSpacing.s12) {
                EqualIllustration(art, size: 84)
                if isExclusive {
                    HStack(spacing: EqualSpacing.s10) {
                        Text("30 calls a month").strikethrough().font(.equal(size: 13)).foregroundStyle(EqualColor.legalText)
                            .padding(.horizontal, 12).padding(.vertical, 4)
                            .background(Capsule().fill(.white)).overlay(Capsule().stroke(EqualColor.strokeMedium))
                        Image(systemName: "arrow.right").foregroundStyle(EqualColor.goldInk).font(.system(size: 16, weight: .semibold))
                        Text("Unlimited").font(.equal(size: 13, weight: .semibold)).foregroundStyle(EqualColor.grey01)
                            .padding(.horizontal, 12).padding(.vertical, 4)
                            .background(Capsule().fill(Color(equalHex: 0xE3FFDA))).overlay(Capsule().stroke(Color(equalHex: 0x95DC00)))
                    }
                }
            }
            .frame(maxWidth: .infinity).frame(height: 192)
            .background(isExclusive ? AnyShapeStyle(LinearGradient(colors: [Color(equalHex: 0xFFF3C9), Color(equalHex: 0xFBF8EE)], startPoint: .top, endPoint: .bottom)) : AnyShapeStyle(EqualColor.grey14))
            .overlay(alignment: .topLeading) {
                EqualTag(isExclusive ? "Only in Gold Plus" : "Both plans", kind: isExclusive ? .exclusive : .bothPlans).padding(EqualSpacing.s12)
            }

            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text(title).font(.equal(size: 18, weight: .semibold)).foregroundStyle(EqualColor.grey01)
                Text(message).font(.equal(size: 12)).foregroundStyle(EqualColor.grey05)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EqualSpacing.s18)
        }
        .frame(width: 280)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.l))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.l).stroke(isExclusive ? EqualColor.goldBorder : EqualColor.strokeMedium, lineWidth: 1))
    }
}
