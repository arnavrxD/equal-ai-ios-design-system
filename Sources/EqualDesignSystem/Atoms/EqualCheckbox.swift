import SwiftUI

/// 18pt square checkbox with a caption label ("I want to receive updates on Whatsapp").
public struct EqualCheckbox: View {
    @Binding var isOn: Bool
    let label: String

    public init(_ label: String, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }

    public var body: some View {
        Button { isOn.toggle() } label: {
            HStack(spacing: 7) {
                RoundedRectangle(cornerRadius: EqualRadius.xs)
                    .fill(isOn ? EqualColor.green : .clear)
                    .overlay(RoundedRectangle(cornerRadius: EqualRadius.xs).stroke(isOn ? EqualColor.green : EqualColor.strokeDark, lineWidth: 1.5))
                    .overlay { if isOn { Image(systemName: "checkmark").font(.system(size: 10, weight: .heavy)).foregroundStyle(.white) } }
                    .frame(width: 18, height: 18)
                Text(label).equalTextStyle(.caption1).foregroundStyle(EqualColor.textPrimary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityValue(isOn ? "Checked" : "Unchecked")
    }
}
