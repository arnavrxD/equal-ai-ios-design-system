import SwiftUI

/// Selectable plan in the sticky plan sheet: 84pt, radius 16, 2pt border. Selected: gold border,
/// glow and a green radio. Gold Plus carries the "Best value" tag across its top edge.
public struct EqualPlanCard: View {
    let name: String
    let price: String
    let period: String
    let isSelected: Bool
    let badge: String?
    let action: () -> Void

    public init(_ name: String, price: String, period: String = "/month", isSelected: Bool, badge: String? = nil, action: @escaping () -> Void = {}) {
        self.name = name
        self.price = price
        self.period = period
        self.isSelected = isSelected
        self.badge = badge
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(name).font(.equal(size: 15, weight: .medium))
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(price).font(.equal(size: 22, weight: .bold)).tracking(-0.44)
                    Text(period).font(.equal(size: 13)).foregroundStyle(Color(equalHex: 0x6B6B6B))
                }
            }
            .foregroundStyle(EqualColor.grey01)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, EqualSpacing.s16)
            .frame(height: 84)
            .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(isSelected ? EqualColor.goldBorder : Color(equalHex: 0xF2F2F2), lineWidth: 2))
            .equalShadow(isSelected ? .planSelected : EqualShadow(color: .clear, radius: 0, x: 0, y: 0))
            .overlay(alignment: .topTrailing) { EqualPlanRadio(isSelected: isSelected).padding(14) }
            .overlay(alignment: .topTrailing) {
                if let badge { EqualTag(badge, kind: .bestValue).offset(x: -10, y: -11) }
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel("\(name), \(price) \(period)")
    }
}

struct EqualPlanCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            EqualPlanCard("Gold", price: "₹249", isSelected: false)
            EqualPlanCard("Gold Plus", price: "₹499", isSelected: true, badge: "Best value")
        }
        .padding(24)
        .background(Color.white)
    }
}
