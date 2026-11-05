import SwiftUI

/// The assistant's progress line with a shimmer ("Thinking...", "Putting it together...").
public struct EqualThinkingText: View {
    let text: String
    @State private var phase: CGFloat = -1
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ text: String = "Thinking...") { self.text = text }

    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            ZStack { Circle().fill(EqualGradient.voice); EqualMark(size: 13, color: .white) }.frame(width: 24, height: 24)
            Text(text).equalTextStyle(.typing).foregroundStyle(EqualColor.textSecondary)
                .overlay {
                    if !reduceMotion {
                        LinearGradient(colors: [.clear, EqualColor.bgSurface.opacity(0.9), .clear], startPoint: .leading, endPoint: .trailing)
                            .offset(x: phase * 120)
                            .mask(Text(text).equalTextStyle(.typing))
                    }
                }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: false)) { phase = 1 }
        }
    }
}
