import SwiftUI

/// Selectable plan card: name, price and "/month", a radio top-right and an optional tag across
/// the top edge ("Best value" dark gold, or the cream "Your plan" for the plan the user already has).
///
/// White, radius 16, 2pt border (#F2F2F2; selected #EBCB6A in sheets, #C29200 inline) and a soft
/// #B98407 glow when selected. `.sheet` and `.inline` are 84pt with a 14pt inset; `.limit` is the
/// 81pt card of the limit paywalls with a 16pt inset. When a coupon is applied, pass the old price
/// as `originalPrice` and it is shown struck through.
public struct EqualPlanCard: View {
    public enum Style: Sendable { case sheet, inline, limit }

    let name: String
    let price: String
    let period: String
    let isSelected: Bool
    let badge: String?
    let originalPrice: String?
    let currentPlanTag: String?
    let style: Style
    let action: () -> Void

    /// - Parameters:
    ///   - badge: dark "Best value" tag on the top edge.
    ///   - originalPrice: pre-coupon price, struck through after the price.
    ///   - currentPlanTag: cream tag for the user's current plan ("Your plan").
    public init(_ name: String, price: String, period: String = "/month", isSelected: Bool, badge: String? = nil,
                originalPrice: String? = nil, currentPlanTag: String? = nil, style: Style = .sheet,
                action: @escaping () -> Void = {}) {
        self.name = name
        self.price = price
        self.period = period
        self.isSelected = isSelected
        self.badge = badge
        self.originalPrice = originalPrice
        self.currentPlanTag = currentPlanTag
        self.style = style
        self.action = action
    }

    private var isLimit: Bool { style == .limit }
    private var inset: CGFloat { isLimit ? 16 : 14 }
    private var selectedStroke: Color { style == .inline ? Color(equalHex: 0xC29200) : EqualColor.goldBorder }

    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: isLimit ? 6 : 9) {
                Text(name).font(.equal(size: 15, weight: .medium)).frame(height: 20)
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(price).font(.equal(size: 22, weight: .bold)).tracking(-0.44)
                    if let originalPrice {
                        Text(originalPrice).font(.equal(size: 13)).strikethrough().foregroundStyle(Color(equalHex: 0x6B6B6B))
                    }
                    Text(period).font(.equal(size: 13)).foregroundStyle(Color(equalHex: 0x6B6B6B))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
            .foregroundStyle(EqualColor.grey01)
            .padding(.top, 15)
            .padding(.horizontal, inset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .frame(height: isLimit ? 81 : 84)
            .background {
                ZStack {
                    if isSelected {
                        // Figma: #B98407 35%, y2, blur 8, spread −10 (a 10pt-inset shape casts it)
                        RoundedRectangle(cornerRadius: EqualRadius.m).fill(Color.white).padding(10)
                            .shadow(color: EqualColor.planPlusGlow, radius: 4, x: 0, y: 2)
                    }
                    RoundedRectangle(cornerRadius: EqualRadius.m).fill(Color.white)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).strokeBorder(isSelected ? selectedStroke : Color(equalHex: 0xF2F2F2), lineWidth: 2))
            .overlay(alignment: .topTrailing) { EqualPlanRadio(isSelected: isSelected).padding(.top, 15).padding(.trailing, inset) }
            .overlay(alignment: .topTrailing) {
                if let currentPlanTag {
                    EqualPlanTag(currentPlanTag, kind: .current).offset(x: -(isLimit ? 14 : 10), y: isLimit ? -10 : -12)
                } else if let badge {
                    EqualPlanTag(badge, kind: .bestValue).offset(x: -(isLimit ? 14 : 10), y: isLimit ? -10 : -12)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel("\(name), \(price) \(period)\(currentPlanTag.map { ", \($0)" } ?? "")")
    }
}

/// 24pt radius-7 tag on a plan card's top edge.
struct EqualPlanTag: View {
    enum Kind { case bestValue, current }
    let text: String
    let kind: Kind
    init(_ text: String, kind: Kind) { self.text = text; self.kind = kind }
    var body: some View {
        Text(text).font(.equal(size: 12, weight: .semibold))
            .foregroundStyle(kind == .bestValue ? EqualColor.goldLabel : Color(equalHex: 0x5A5440))
            .padding(.horizontal, 10).frame(height: 24)
            .background(RoundedRectangle(cornerRadius: 7).fill(kind == .bestValue ? EqualColor.goldDeep : Color(equalHex: 0xF1EBDD)))
            .overlay { if kind == .current { RoundedRectangle(cornerRadius: 7).strokeBorder(Color.white, lineWidth: 1) } }
            .fixedSize()
    }
}

struct EqualPlanCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            HStack(spacing: 13) {
                EqualPlanCard("Gold", price: "₹249", isSelected: false)
                EqualPlanCard("Gold Plus", price: "₹499", isSelected: true, badge: "Best value")
            }
            HStack(spacing: 13) {
                EqualPlanCard("Gold", price: "₹249", isSelected: false, style: .inline)
                EqualPlanCard("Gold Plus", price: "₹374", isSelected: true, badge: "Best value", originalPrice: "₹499", style: .inline)
            }
            HStack(spacing: 14) {
                EqualPlanCard("Gold", price: "₹249", isSelected: false, currentPlanTag: "Your plan", style: .limit)
                EqualPlanCard("Gold Plus", price: "₹499", isSelected: true, badge: "Best value", style: .limit)
            }
        }
        .padding(24)
        .frame(width: 393)
        .background(Color.white)
    }
}
