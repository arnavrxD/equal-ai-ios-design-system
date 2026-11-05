import SwiftUI

/// iOS-style switch, 44×24, green when on. Used for "AI Assistant is On".
public struct EqualToggle: View {
    @Binding var isOn: Bool
    let label: String

    public init(_ label: String, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }

    public var body: some View {
        Button { withAnimation(.snappy(duration: 0.2)) { isOn.toggle() } } label: {
            Capsule()
                .fill(isOn ? EqualColor.green : EqualColor.buttonDisabled)
                .frame(width: 44, height: 24)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle().fill(.white).frame(width: 20, height: 20).padding(2)
                        .shadow(color: .black.opacity(0.12), radius: 1.5, y: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityAddTraits(.isButton)
    }
}
