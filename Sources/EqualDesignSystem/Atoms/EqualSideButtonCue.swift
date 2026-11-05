import SwiftUI

/// The blue bar on the right screen edge, beside the hardware side button, shown while the App
/// Store confirmation is up ("Double-click side button to pay").
///
/// 4×84, radius 2, #007AFF with an 80% blue glow (blur 12). It pulses gently unless Reduce Motion
/// is on. Place it with `.overlay(alignment: .topTrailing)` on the screen; `y` is its top (190 on
/// a 393×852 iPhone).
public struct EqualSideButtonCue: View {
    let y: CGFloat
    @State private var pulse = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(y: CGFloat = 190) { self.y = y }

    public var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(EqualColor.iosBlue)
            .frame(width: 4, height: 84)
            .background(RoundedRectangle(cornerRadius: 2).fill(EqualColor.iosBlue.opacity(0.8)).blur(radius: 6))
            .opacity(pulse ? 0.55 : 1)
            .padding(.top, y)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { pulse = true }
            }
            .accessibilityHidden(true)
    }
}

struct EqualSideButtonCue_Previews: PreviewProvider {
    static var previews: some View {
        Color.gray.frame(width: 393, height: 400).overlay(alignment: .topTrailing) { EqualSideButtonCue(y: 100) }
    }
}
