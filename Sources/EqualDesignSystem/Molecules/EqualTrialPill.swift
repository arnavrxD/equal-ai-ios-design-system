import SwiftUI

/// Header pill during the last trial days: cream-to-yellow, gold border and text, small crown.
public struct EqualTrialPill: View {
    let text: String
    public init(_ text: String = "1 Day Left") { self.text = text }
    public var body: some View {
        HStack(spacing: EqualSpacing.s4) {
            EqualIllustration(.crown, size: 18)
            Text(text).font(.equal(size: 14, weight: .medium))
        }
        .foregroundStyle(EqualColor.goldInk)
        .padding(.horizontal, EqualSpacing.s12).frame(height: 34)
        .background(Capsule().fill(LinearGradient(colors: [Color(equalHex: 0xFFFDF2), Color(equalHex: 0xFEEC83)], startPoint: .top, endPoint: .bottom)))
        .overlay(Capsule().stroke(EqualColor.goldInk, lineWidth: 1))
        .equalShadow(.card)
    }
}
