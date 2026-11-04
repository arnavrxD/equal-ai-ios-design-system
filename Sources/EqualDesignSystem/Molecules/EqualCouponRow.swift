import SwiftUI

/// Coupon line under the plans: a dashed gold pill, "%" seal, code, offer and an APPLY button.
/// Applied state turns the border and button green.
public struct EqualCouponRow: View {
    let code: String
    let offer: String
    @Binding var isApplied: Bool

    public init(code: String = "EQUAL25", offer: String = "FLAT 25% OFF", isApplied: Binding<Bool>) {
        self.code = code
        self.offer = offer
        self._isApplied = isApplied
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            Text("%").font(.equal(size: 12, weight: .bold)).foregroundStyle(.white)
                .frame(width: 26, height: 26).background(Circle().fill(EqualGradient.coupon))
            Text(code).font(.equal(size: 14, weight: .bold)).foregroundStyle(EqualColor.goldCoupon)
            Text(offer).font(.equal(size: 12)).foregroundStyle(Color(equalHex: 0x5E5E5E))
            Spacer(minLength: 0)
            Button { withAnimation { isApplied.toggle() } } label: {
                Text(isApplied ? "APPLIED" : "APPLY").font(.equal(size: 12, weight: .semibold))
                    .foregroundStyle(isApplied ? EqualColor.green : EqualColor.grey01)
                    .padding(.horizontal, 14).frame(height: 40)
                    .background(Capsule().fill(isApplied ? EqualColor.unreadFill : EqualColor.goldApplyBg))
                    .overlay(Capsule().stroke(isApplied ? EqualColor.green : Color(equalHex: 0xE3B740), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, EqualSpacing.s8)
        .frame(height: 40)
        .background(Capsule().fill(Color.white))
        .overlay(Capsule().stroke(isApplied ? EqualColor.green : EqualColor.goldCouponBorder, style: StrokeStyle(lineWidth: 1, dash: isApplied ? [] : [4, 3])))
    }
}

struct EqualCouponRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack { EqualCouponRow(isApplied: .constant(false)); EqualCouponRow(isApplied: .constant(true)) }
            .padding(24).background(Color.white)
    }
}
