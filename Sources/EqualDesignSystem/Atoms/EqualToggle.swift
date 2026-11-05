import SwiftUI

/// iOS-style switch, 44×24, #00B140 when on, with a 20pt white knob (shadow 0,1 blur 2 @4%).
/// Used for "AI Assistant is On" (Figma 26242:89424).
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
                        .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityAddTraits(.isButton)
    }
}

struct EqualToggle_Previews: PreviewProvider {
    struct Demo: View {
        @State var on = true
        @State var off = false
        var body: some View { HStack(spacing: 16) { EqualToggle("On", isOn: $on); EqualToggle("Off", isOn: $off) }.padding(24).equalScreenBackground() }
    }
    static var previews: some View { Demo() }
}
