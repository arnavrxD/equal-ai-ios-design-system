import SwiftUI

/// Bottom input of the Equal sheet: a 52pt keyboard button (or a "Type..." field once typing)
/// and the full-width voice button on the lime-to-green voice gradient. Voice is the default input.
public struct EqualComposer: View {
    let voiceTitle: String
    @Binding var text: String
    @State private var isTyping = false
    let onVoice: () -> Void
    let onSubmit: (String) -> Void

    public init(voiceTitle: String = "Send voice note", text: Binding<String>, onVoice: @escaping () -> Void = {}, onSubmit: @escaping (String) -> Void = { _ in }) {
        self.voiceTitle = voiceTitle
        self._text = text
        self.onVoice = onVoice
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s12) {
            if isTyping {
                TextField("Type...", text: $text)
                    .font(.equal(size: 16))
                    .onSubmit { onSubmit(text) }
                    .padding(.horizontal, EqualSpacing.s18)
                    .frame(height: 52)
                    .background(Capsule().fill(EqualColor.bgSurface).equalShadow(.composer))
            } else {
                Button { withAnimation { isTyping = true } } label: {
                    Image(systemName: "keyboard").font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color(equalHex: 0x6B7280))
                        .frame(width: 52, height: 52)
                        .background(Circle().fill(Color.white).equalShadow(.composer))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Type instead")
            }
            Button(action: onVoice) {
                HStack(spacing: EqualSpacing.s12) {
                    Image(systemName: "mic.fill").font(.system(size: 15, weight: .medium))
                    Text(voiceTitle).font(.equal(size: 16, weight: .semibold)).tracking(-0.42)
                }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Capsule().fill(EqualGradient.voice))
                    .background(Capsule().fill(Color(equalHex: 0xEFFFE8, alpha: 0.72)))
                    .equalShadow(.composer)
            }
            .buttonStyle(.plain)
        }
    }
}

struct EqualComposer_Previews: PreviewProvider {
    static var previews: some View {
        EqualComposer(text: .constant("")).padding(24).equalScreenBackground()
    }
}
