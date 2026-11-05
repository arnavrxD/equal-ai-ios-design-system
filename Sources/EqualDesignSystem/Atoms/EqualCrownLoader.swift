import SwiftUI

/// Payment spinner: a gold arc turning around the 3D crown.
public struct EqualCrownLoader: View {
    let size: CGFloat
    @State private var spin = false
    public init(size: CGFloat = 80) { self.size = size }
    public var body: some View {
        ZStack {
            Circle().stroke(Color.black.opacity(0.08), lineWidth: 4)
            Circle().trim(from: 0, to: 0.25)
                .stroke(Color(equalHex: 0xA3712F), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(spin ? 360 : 0))
            EqualIllustration(.crown, size: size * 0.62)
        }
        .frame(width: size, height: size)
        .onAppear { withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) { spin = true } }
        .accessibilityLabel("Processing")
    }
}

struct EqualSmallAtoms_Previews: PreviewProvider {
    struct Demo: View {
        @State var on = true
        @State var checked = true
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack { EqualUnreadCount(1); EqualUnreadCount(12); EqualUnreadCount(140); EqualUnreadCount() }
                HStack { EqualToggle("AI Assistant", isOn: $on); EqualPlanRadio(isSelected: false); EqualPlanRadio(isSelected: true); EqualCompareCheck() }
                EqualCheckbox("I want to receive updates on Whatsapp", isOn: $checked)
                EqualSectionLabel("Compare plans")
                EqualSectionLabel("What you get", style: .gold)
                EqualSectionLabel("Your assistant", style: .group)
                EqualPageDots(count: 5, active: 0)
                EqualProgressBar(value: 0.4)
                EqualThinkingText()
                EqualCrownLoader()
            }
            .padding(24)
            .equalScreenBackground()
        }
    }
    static var previews: some View { Demo() }
}
