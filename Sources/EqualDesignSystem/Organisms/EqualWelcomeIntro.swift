import SwiftUI

/// The welcome break: the waving hand, then "Welcome Keshav!" and a line typed out with a caret,
/// then "Let’s go ›" fades in.
public struct EqualWelcomeIntro: View {
    let name: String
    let message: String
    let onContinue: () -> Void
    @State private var shown = 0
    @State private var caretOn = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(name: String = "Keshav", message: String = "Let me show you how I can take your calls when you’re busy.", onContinue: @escaping () -> Void = {}) {
        self.name = name
        self.message = message
        self.onContinue = onContinue
    }

    private var title: String { "Welcome \(name)!" }
    private var total: Int { title.count + message.count }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            EqualAnimatedImage(.waveHand, size: 180)
            VStack(spacing: EqualSpacing.s8) {
                typed(title, from: 0).equalTextStyle(.title2Em).foregroundStyle(EqualColor.textPrimary)
                typed(message, from: title.count).equalTextStyle(.body).foregroundStyle(EqualColor.textSecondary)
            }
            .multilineTextAlignment(.center)
            .frame(width: 293)
            .padding(.top, 4)
            Spacer()
            EqualButton("Let’s go", icon: .chevronRight, trailingIcon: true, fullWidth: true, action: onContinue)
                .opacity(shown >= total ? 1 : 0)
                .animation(.easeOut(duration: 0.4), value: shown >= total)
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.bottom, 45)
        }
        .equalAmbientGlow(.welcome)
        .task {
            if reduceMotion { shown = total; return }
            while shown < total {
                try? await Task.sleep(for: .milliseconds(38))
                shown += 1
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) \(message)")
    }

    /// The part of `text` revealed so far, with a 1pt caret while it types.
    private func typed(_ text: String, from start: Int) -> Text {
        let n = min(max(shown - start, 0), text.count)
        let visible = Text(String(text.prefix(n)))
        let hidden = Text(String(text.dropFirst(n))).foregroundColor(.clear)
        let typing = shown >= start && shown < start + text.count
        return visible + (typing ? Text("|").foregroundColor(EqualColor.green) : Text("")) + hidden
    }
}
