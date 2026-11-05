import SwiftUI

/// Coupon line on the paywall: a dashed gold outline with the scalloped "%" seal, the code, the
/// offer and an APPLY button. Tapping APPLY switches to the applied state: a green dashed
/// rectangle, "25% off applied" and a "✓ Applied" pill (tap it again to remove the coupon).
///
/// Styles, as drawn in Figma:
/// - `.overhang` (default): 40pt capsule, 331 wide, with the 84×40 APPLY capsule hanging over its
///   right end to the column edge (sticky sheet and inline plans).
/// - `.inset`: 40pt radius-14 field with a 66×26 APPLY pill inside (compact / rounded heroes).
/// - `.compact`: the 42pt limit-paywall field, dash 5/4, 70×26 APPLY.
/// - `.card`: the 63pt soft-paywall card with the 3D % badge and the code over the offer.
public struct EqualCouponRow: View {
    public enum Style: Sendable { case overhang, inset, compact, card }

    let code: String
    let offer: String
    let appliedTitle: String
    let style: Style
    @Binding var isApplied: Bool

    public init(code: String = "EQUAL25", offer: String = "FLAT 25% OFF", appliedTitle: String = "25% off applied",
                style: Style = .overhang, isApplied: Binding<Bool>) {
        self.code = code
        self.offer = offer
        self.appliedTitle = appliedTitle
        self.style = style
        self._isApplied = isApplied
    }

    private func toggle() { withAnimation(.snappy) { isApplied.toggle() } }

    public var body: some View {
        Group {
            if isApplied { applied } else {
                switch style {
                case .overhang: overhang
                case .inset: inset
                case .compact: compact
                case .card: card
                }
            }
        }
        .environment(\.colorScheme, .light)
    }

    // MARK: Styles

    private static let goldDash = StrokeStyle(lineWidth: 1, dash: [4, 3])
    private static let applyStroke = LinearGradient(colors: [Color(equalHex: 0xF7D774), Color(equalHex: 0xC9960C)], startPoint: .top, endPoint: .bottom)

    private var overhang: some View {
        ZStack(alignment: .trailing) {
            content
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
                .background(Capsule().fill(Color.white))
                .overlay(Capsule().strokeBorder(EqualColor.goldCouponBorder, style: Self.goldDash))
                .padding(.trailing, 14)
            applyButton(width: 84, height: 40, fill: EqualColor.goldApplyBg)
        }
    }

    private var inset: some View {
        HStack(spacing: 0) {
            content
            Spacer(minLength: 4)
            applyButton(width: 66, height: 26, fill: .white)
        }
        .padding(.leading, 8).padding(.trailing, 6)
        .frame(height: 40)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(EqualColor.goldCouponBorder, style: Self.goldDash))
    }

    private var compact: some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                EqualCouponSeal(size: 26, ring: true, labelSize: 9.8)
                HStack(spacing: 6) {
                    Text(code).font(.equal(size: 14, weight: .heavy)).tracking(0.14).foregroundStyle(Color(equalHex: 0xB9741A))
                    Text(offer).font(.equal(size: 12)).foregroundStyle(Color(equalHex: 0x6B6B6B))
                }
                .lineLimit(1)
            }
            Spacer(minLength: 4)
            Button(action: toggle) {
                Text("APPLY").font(.equal(size: 12, weight: .semibold)).tracking(0.24).foregroundStyle(EqualColor.grey01)
                    .frame(width: 70, height: 26)
                    .background(Capsule().fill(Color.white))
                    .overlay(Capsule().strokeBorder(Color(equalHex: 0xC99A1C), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 8).padding(.trailing, 8)
        .frame(height: 42)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(equalHex: 0xD9B76A), style: StrokeStyle(lineWidth: 1, dash: [5, 4])))
    }

    private var card: some View {
        HStack(spacing: 0) {
            EqualIllustration(.discountBadgeGold, size: 48)
            VStack(alignment: .leading, spacing: 0) {
                Text(code).font(.equal(size: 16, weight: .bold))
                    .foregroundStyle(RadialGradient(colors: [Color(equalHex: 0xFFB251), Color(equalHex: 0x603600)], center: .top, startRadius: 0, endRadius: 40))
                Text(offer).font(.equal(size: 12, weight: .medium)).foregroundStyle(Color(equalHex: 0x5E5E5E))
            }
            .padding(.leading, 0)
            Spacer(minLength: 4)
            Button(action: toggle) {
                Text("APPLY").font(.equal(size: 12, weight: .semibold)).foregroundStyle(Color(equalHex: 0x191919))
                    .frame(width: 83, height: 33)
                    .background(Capsule().fill(Color.white))
                    .overlay(Capsule().strokeBorder(LinearGradient(colors: [Color(equalHex: 0xA37135), Color(equalHex: 0x5D4800)], startPoint: .top, endPoint: .bottom), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 10).padding(.trailing, 14)
        .frame(height: 63)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(
            LinearGradient(colors: [Color(equalHex: 0xD58C14, alpha: 0.6), Color(equalHex: 0xB28A3C, alpha: 0.6)], startPoint: .leading, endPoint: .trailing),
            style: StrokeStyle(lineWidth: 1, dash: [7, 7])))
    }

    private var applied: some View {
        let height: CGFloat = style == .card ? 63 : (style == .compact ? 42 : 40)
        return HStack(spacing: 10) {
            if style == .card { EqualIllustration(.discountBadgeGold, size: 48) } else { EqualCouponSeal(size: 26, ring: style == .compact) }
            Text(appliedTitle).font(.equal(size: 14, weight: .bold)).foregroundStyle(Color(equalHex: 0x00872F)).lineLimit(1)
            Spacer(minLength: 4)
            Button(action: toggle) {
                Text("✓ Applied").font(.equal(size: 12, weight: .semibold)).foregroundStyle(Color(equalHex: 0x00872F))
                    .frame(width: 88, height: 26)
                    .background(Capsule().fill(Color(equalHex: 0xEAF8EF)))
                    .overlay(Capsule().strokeBorder(EqualColor.green, lineWidth: 1))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Coupon applied. Remove")
        }
        .padding(.leading, style == .card ? 10 : 8).padding(.trailing, 6)
        .frame(height: height)
        .background(RoundedRectangle(cornerRadius: style == .card ? 20 : 14).fill(Color(equalHex: 0xEFFAF2)))
        .overlay(RoundedRectangle(cornerRadius: style == .card ? 20 : 14).strokeBorder(Color(equalHex: 0x7FD39B), style: Self.goldDash))
    }

    // MARK: Parts

    /// Seal 26 at x8, code at x44 (Bold 14 #C27C0E), offer 10pt after (Regular 12 #5E5E5E).
    private var content: some View {
        HStack(spacing: 10) {
            EqualCouponSeal(size: 26)
            HStack(spacing: 10) {
                Text(code).font(.equal(size: 14, weight: .bold)).foregroundStyle(EqualColor.goldCoupon)
                Text(offer).font(.equal(size: 12)).foregroundStyle(Color(equalHex: 0x5E5E5E))
            }
            .lineLimit(1)
            .minimumScaleFactor(0.85)
        }
    }

    private func applyButton(width: CGFloat, height: CGFloat, fill: Color) -> some View {
        Button(action: toggle) {
            Text("APPLY").font(.equal(size: 12, weight: .semibold)).foregroundStyle(EqualColor.grey01)
                .frame(width: width, height: height)
                .background(Capsule().fill(fill))
                .overlay(Capsule().strokeBorder(Self.applyStroke, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Apply coupon \(code)")
    }
}

/// The scalloped gold "%" seal: #FFD95A → #F2A900 → #C77700, optional white 35% ring (limit paywalls).
struct EqualCouponSeal: View {
    var size: CGFloat = 26
    var ring = false
    var labelSize: CGFloat = 12
    var body: some View {
        ZStack {
            EqualScallopedStar(points: 12, depth: 0.84).fill(EqualGradient.coupon)
            if ring { Circle().strokeBorder(Color.white.opacity(0.35), lineWidth: 1).padding(size * 0.2) }
            Text("%").font(.equal(size: labelSize, weight: ring ? .heavy : .bold)).foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

struct EqualCouponRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualCouponRow(isApplied: .constant(false))
            EqualCouponRow(style: .inset, isApplied: .constant(false))
            EqualCouponRow(style: .compact, isApplied: .constant(false))
            EqualCouponRow(style: .card, isApplied: .constant(false))
            EqualCouponRow(isApplied: .constant(true))
        }
        .padding(24)
        .frame(width: 393)
        .background(Color.white)
    }
}
