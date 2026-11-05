import SwiftUI

/// Header pill during the last trial days ("1 Day Left"): white with a 10% gold wash, a gold →
/// white → gold hairline outside the capsule, a small crown and Medium 14 gold text.
public struct EqualTrialPill: View {
    let text: String
    public init(_ text: String = "1 Day Left") { self.text = text }
    public var body: some View {
        HStack(spacing: EqualSpacing.s4) {
            EqualIllustration(.crown, size: 18)
            Text(text).font(.equal(size: 14, weight: .medium)).tracking(-0.03 * 14)
        }
        .foregroundStyle(EqualColor.goldInk)
        .padding(.horizontal, EqualSpacing.s12).frame(height: 34)
        .background {
            ZStack {
                Capsule().fill(Color.white)
                Capsule().fill(LinearGradient(colors: [Color(equalHex: 0xFEEC83), Color(equalHex: 0xA56B06)], startPoint: .leading, endPoint: .trailing)).opacity(0.1)
            }
        }
        // 1pt stroke outside the 34pt capsule.
        .overlay(
            Capsule()
                .stroke(LinearGradient(stops: [
                    .init(color: EqualColor.goldInk, location: 0),
                    .init(color: .white, location: 0.48),
                    .init(color: EqualColor.goldInk, location: 1)
                ], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                .padding(-0.5)
        )
        .equalShadow(.card)
    }
}

struct EqualTrialPill_Previews: PreviewProvider {
    static var previews: some View {
        EqualTrialPill().padding(24).equalScreenBackground()
    }
}
