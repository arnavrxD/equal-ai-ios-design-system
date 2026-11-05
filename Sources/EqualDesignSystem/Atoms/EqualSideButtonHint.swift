import SwiftUI

/// The "Double click to Subscribe" cue beside the iPhone side button: a 6×106 white bar on the
/// right screen edge that pulses, with SemiBold 24 white text to its left. Place it over a dimmed
/// screen, top-trailing, 6pt from the edge.
public struct EqualSideButtonHint: View {
    let text: String
    @State private var pulse = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ text: String = "Double click\nto Subscribe") { self.text = text }

    public var body: some View {
        HStack(spacing: 12) {
            Text(text)
                .font(.equal(size: 24, weight: .semibold))
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
                .fixedSize()
            Capsule()
                .fill(Color.white)
                .frame(width: 6, height: 106)
                .opacity(pulse ? 0.45 : 1)
                .offset(x: pulse ? -2 : 0)
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) { pulse = true }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text.replacingOccurrences(of: "\n", with: " "))
    }
}

struct EqualSideButtonHint_Previews: PreviewProvider {
    static var previews: some View {
        EqualSideButtonHint().padding(24).background(Color.black.opacity(0.6))
    }
}
