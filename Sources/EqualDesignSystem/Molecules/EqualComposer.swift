import SwiftUI

/// Bottom input of the Equal sheet: a 52pt keyboard button (or a "Type..." field once typing)
/// and the full-width voice button on the voice gradient. Voice is the default input.
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
                EqualIconButton(.keyboard, variant: .tile, label: "Type instead") { withAnimation { isTyping = true } }
            }
            Button(action: onVoice) {
                Label(voiceTitle, systemImage: "mic.fill")
                    .font(.equal(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Capsule().fill(EqualGradient.voice))
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
