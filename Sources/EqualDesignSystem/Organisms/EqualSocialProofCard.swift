import SwiftUI

/// Splash stats card: three 3D images over value + label columns on a white-30% glass card,
/// separated by short lime rules ("5L+ Indian users · 4.4 star Rating · 150 Mn+ Calls handled").
public struct EqualSocialProofCard: View {
    public struct Stat: Sendable {
        public let image: EqualImage
        public let value: String
        public let label: String
        public init(_ image: EqualImage, _ value: String, _ label: String) { self.image = image; self.value = value; self.label = label }
    }

    let stats: [Stat]

    public init(stats: [Stat] = [
        Stat(.coupleCricketFans, "5L+", "Indian users"),
        Stat(.starGold, "4.4 star", "Rating"),
        Stat(.phoneHandsetGreen, "150 Mn+", "Calls handled")
    ]) {
        self.stats = stats
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Array(stats.enumerated()), id: \.offset) { i, s in
                if i > 0 {
                    Spacer(minLength: 0)
                    Rectangle().fill(EqualColor.brandLime).frame(width: 23, height: 2).padding(.top, 23)
                    Spacer(minLength: 0)
                }
                VStack(spacing: 6) {
                    EqualIllustration(s.image, size: 48)
                    VStack(spacing: 0) {
                        Text(s.value).font(.equal(size: 14, weight: .black))
                        Text(s.label).font(.equal(size: 14, weight: .medium))
                    }
                    .tracking(-0.42)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                }
                .frame(width: 84)
            }
        }
        .padding(20)
        .frame(width: 343, height: 130)
        .background(Color(equalHex: 0xD9D9D9, alpha: 0.3), in: RoundedRectangle(cornerRadius: 30))
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.25), lineWidth: 1))
        .equalShadow(.card)
        .accessibilityElement(children: .combine)
    }
}
