import SwiftUI

/// Metric row on the dark value-recap story: outlined icon box, label, tabular value, hairline.
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
        HStack(spacing: EqualSpacing.s12) {
            EqualIconView(icon, size: 16).foregroundStyle(EqualColor.goldLabel)
                .frame(width: 34, height: 34)
                .overlay(RoundedRectangle(cornerRadius: EqualRadius.s).stroke(EqualColor.brandLime.opacity(0.35), lineWidth: 1))
            Text(label).font(.equal(size: 16)).foregroundStyle(.white.opacity(0.85))
            Spacer()
            Text(value).font(.equal(size: 22, weight: .semibold)).monospacedDigit().foregroundStyle(.white)
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.12)).frame(height: 1) }
    }
}

struct EqualStatRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            EqualStatRow("Calls handled", value: "18", icon: .phoneOutline)
            EqualStatRow("Spam and sales stopped", value: "7", icon: .shield)
        }
        .padding(24)
        .background(Color(equalHex: 0x0B1215))
    }
}
