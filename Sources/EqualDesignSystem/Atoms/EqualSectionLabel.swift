import SwiftUI

/// Uppercase section header. `.hairlines` centres it between fading rules ("COMPARE PLANS"),
/// `.gold` uses warm gold rules ("WHAT YOU GET"), `.group` is the left-aligned settings label.
public struct EqualSectionLabel: View {
    public enum Style: Sendable { case hairlines, gold, group }
    let text: String
    let style: Style

    public init(_ text: String, style: Style = .hairlines) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        if style == .group {
            Text(text.uppercased()).font(.equal(size: 14, weight: .semibold)).tracking(0.84)
                .foregroundStyle(EqualColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            let line = style == .gold ? Color(equalHex: 0xA37135, alpha: 0.5) : Color.black.opacity(0.14)
            HStack(spacing: EqualSpacing.s8) {
                LinearGradient(colors: [line.opacity(0), line], startPoint: .leading, endPoint: .trailing).frame(height: 1)
                Text(text.uppercased())
                    .font(.equal(size: style == .gold ? 14 : 13, weight: .bold)).tracking(0.52)
                    .foregroundStyle(style == .gold ? EqualColor.textSecondary : EqualColor.legalText)
                    .fixedSize()
                LinearGradient(colors: [line, line.opacity(0)], startPoint: .leading, endPoint: .trailing).frame(height: 1)
            }
        }
    }
}
