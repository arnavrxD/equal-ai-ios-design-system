import SwiftUI

/// The paywall-v2 deal card: on a black-to-bronze card, the struck "₹ 499", a big gold "₹249"
/// that rolls its digits into place, "/month", an optional coffee comparison line, concentric
/// rings with a gold glow, and a "LIMITED TIME DEAL" tag straddling the top edge.
public struct EqualPriceDealCard: View {
    let price: Int
    let originalPrice: Int?
    let period: String
    let comparison: String?
    let tag: String?
    let rollsOnAppear: Bool
    @State private var shown: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// - Parameters:
    ///   - comparison: the "☕ Less than your weekly cup of coffee" line; nil gives the compact 99pt card.
    ///   - tag: text of the deal tag (uppercased); nil hides it.
    ///   - rollsOnAppear: counts the digits from `originalPrice` down to `price` when the card appears.
    public init(price: Int = 249, originalPrice: Int? = 499, period: String = "/month", comparison: String? = "Less than your weekly cup of coffee", tag: String? = "Limited time deal", rollsOnAppear: Bool = true) {
        self.price = price
        self.originalPrice = originalPrice
        self.period = period
        self.comparison = comparison
        self.tag = tag
        self.rollsOnAppear = rollsOnAppear
        self._shown = State(initialValue: price)
    }

    private static let gold = Color(equalHex: 0xE0AF00)
    private static let mint = Color(equalHex: 0xECFFF3)

    public var body: some View {
        VStack(spacing: -6) {
            HStack(alignment: .center, spacing: EqualSpacing.s8) {
                if let originalPrice {
                    Text("₹ \(originalPrice)")
                        .font(.equal(size: 24, weight: .semibold))
                        .strikethrough(true, color: Self.gold.opacity(0.6))
                        .foregroundStyle(Self.gold.opacity(0.6))
                        .accessibilityLabel("Was ₹\(originalPrice)")
                }
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    bigPrice
                    Text(period).font(.equal(size: 18, weight: .medium)).foregroundStyle(Self.mint.opacity(0.7))
                }
            }
            .frame(height: 57)
            .padding(.top, 22)
            if let comparison {
                HStack(spacing: EqualSpacing.s10) {
                    Text("☕").font(.equal(size: 20))
                    Text(comparison).font(.equal(size: 12)).foregroundStyle(Self.mint)
                }
                .padding(EqualSpacing.s10)
            }
        }
        .padding(.bottom, comparison == nil ? 20 : 9)
        .frame(maxWidth: .infinity)
        .background { cardBackground }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.goldCard))
        .shadow(color: .black.opacity(0.16), radius: 9, x: 4, y: 4)
        .overlay(alignment: .top) { if let tag { dealTag(tag).offset(y: -11) } }
        .onAppear(perform: roll)
        .accessibilityElement(children: .combine)
    }

    private var bigPrice: some View {
        let text = Text("₹\(shown)").font(.equal(size: 52, weight: .heavy)).tracking(-1)
        return text
            .foregroundStyle(Self.gold)
            .overlay {
                RadialGradient(stops: [
                    .init(color: Color(equalHex: 0xA37135), location: 0),
                    .init(color: Color(equalHex: 0xF7EBC2), location: 0.5),
                    .init(color: Color(equalHex: 0xBF9D67), location: 1)
                ], center: .center, startRadius: 0, endRadius: 80)
                .opacity(0.44)
                .mask(text)
            }
            .contentTransition(.numericText(value: Double(shown)))
            .accessibilityLabel("₹\(price)")
    }

    private func roll() {
        guard rollsOnAppear, !reduceMotion, let originalPrice, originalPrice != price else { return }
        shown = originalPrice
        withAnimation(.snappy(duration: 0.9).delay(0.25)) { shown = price }
    }

    private var cardBackground: some View {
        ZStack(alignment: .topLeading) {
            Color.black
            EqualGradient.membership
            // Glow (142, #FFC927 60%, blur 114) and concentric rings (152) in the bottom-right corner.
            GeometryReader { geo in
                let cx = geo.size.width - 344 + 359, cy: CGFloat = 146
                Circle().fill(Color(equalHex: 0xFFC927, alpha: 0.6)).frame(width: 142, height: 142).blur(radius: 57)
                    .position(x: cx - 24, y: cy - 20)
                ZStack {
                    ForEach([82.0, 111, 134, 152], id: \.self) { d in
                        Circle().stroke(LinearGradient(colors: [.white.opacity(0), .white.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                            .frame(width: d, height: d)
                    }
                }
                .position(x: cx, y: cy)
                // Two faint cream glows under the deal tag.
                Circle().fill(Color(equalHex: 0xFFEDB8)).frame(width: 54, height: 54).blur(radius: 35).opacity(0.5)
                    .position(x: geo.size.width / 2 - 28, y: 40)
                Circle().fill(Color(equalHex: 0xFFEDB8)).frame(width: 54, height: 54).blur(radius: 35).opacity(0.5)
                    .position(x: geo.size.width / 2 + 37, y: 40)
            }
        }
    }

    private func dealTag(_ text: String) -> some View {
        HStack(spacing: 4.4) {
            Image(systemName: "alarm.fill").font(.system(size: 7)).foregroundStyle(Color(equalHex: 0xAE6D28))
            Text(text.uppercased()).font(.equal(size: 10, weight: .bold)).foregroundStyle(.white)
        }
        .padding(.horizontal, EqualSpacing.s12)
        .padding(.vertical, EqualSpacing.s4)
        .frame(height: 21)
        .background(
            RoundedRectangle(cornerRadius: EqualRadius.s)
                .fill(EqualColor.goldStatusBg.shadow(.inner(color: Color(equalHex: 0x4B4B4B), radius: 0.8, x: 2.18, y: -2.18)))
        )
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.s).strokeBorder(EqualColor.goldStatusBorder, lineWidth: 0.65))
    }
}

struct EqualPriceDealCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            EqualPriceDealCard()
            EqualPriceDealCard(comparison: nil)
        }
        .padding(24)
        .background(Color.white)
    }
}
