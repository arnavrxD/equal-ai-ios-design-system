import SwiftUI

/// "❤ Made in India" pill on the splash: saffron → white → green at 30%, glass, black heart and text.
public struct EqualMadeInIndiaPill: View {
    public init() {}

    public var body: some View {
        HStack(spacing: EqualSpacing.s10) {
            EqualIconView(.heart, size: 14)
            Text("Made in India").font(.equal(size: 16, weight: .semibold)).tracking(-0.96)
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 11)
        .frame(height: 41)
        .background {
            Capsule()
                .fill(LinearGradient(stops: [
                    .init(color: Color(equalHex: 0xFE9102), location: 0),
                    .init(color: .white, location: 0.48),
                    .init(color: EqualColor.brandGreen, location: 1)
                ], startPoint: .leading, endPoint: .trailing).opacity(0.3))
                .background(.ultraThinMaterial, in: Capsule())
        }
        .equalShadow(.card)
        .accessibilityElement(children: .combine)
    }
}

struct EqualMadeInIndiaPill_Previews: PreviewProvider {
    static var previews: some View {
        EqualMadeInIndiaPill().padding(40).background(EqualColor.brandGreen)
    }
}
