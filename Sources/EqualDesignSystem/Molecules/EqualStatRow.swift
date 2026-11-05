import SwiftUI

/// Metric row on the dark value-recap story: a gold-outlined icon box, the label, a tabular value
/// and a white 10% hairline. 57pt tall.
///
/// Icon box 34×34 radius 10, #F7CB3C 8% fill and 30% stroke, 18pt glyph in #F7CB3C; label 15 at
/// x48 in white 85%; value SemiBold 22 white (Geist in Figma, DM Sans by the type rule).
public struct EqualStatRow: View {
    let icon: EqualIcon
    let label: String
    let value: String

    public init(_ label: String, value: String, icon: EqualIcon) {
        self.label = label
        self.value = value
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: 14) {
            EqualIconView(icon, size: 15, weight: .light).foregroundStyle(EqualColor.goldLabel)
                .frame(width: 34, height: 34)
                .background(RoundedRectangle(cornerRadius: 10).fill(EqualColor.goldLabel.opacity(0.08)))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(EqualColor.goldLabel.opacity(0.3), lineWidth: 1))
            Text(label).font(.equal(size: 15)).foregroundStyle(.white.opacity(0.85))
            Spacer()
            Text(value).font(.equal(size: 22, weight: .semibold)).monospacedDigit().foregroundStyle(.white)
        }
        .frame(height: 57)
        .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.1)).frame(height: 1) }
        .accessibilityElement(children: .combine)
    }
}

struct EqualStatRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            EqualStatRow("Calls handled", value: "18", icon: .phoneOutline)
            EqualStatRow("Spam and sales stopped", value: "7", icon: .shield)
        }
        .padding(24)
        .background(Color(equalHex: 0x0B0B0A))
    }
}
