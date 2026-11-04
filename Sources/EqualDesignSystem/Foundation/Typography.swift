import SwiftUI

/// Applies an `EqualTextStyle`: font, tracking and line height.
public struct EqualTextStyleModifier: ViewModifier {
    let style: EqualTextStyle

    public func body(content: Content) -> some View {
        content
            .font(.equal(style))
            .tracking(style.trackingEm * style.size)
            // DM Sans' natural line height is ~1.3em; the remainder becomes line spacing.
            .lineSpacing(max(0, style.lineHeight - style.size * 1.3))
    }
}

public extension View {
    /// Sets text in one of the system's text styles, e.g. `.equalTextStyle(.headlineEm)`.
    func equalTextStyle(_ style: EqualTextStyle) -> some View {
        modifier(EqualTextStyleModifier(style: style))
    }
}

public extension Text {
    /// A `Text` already styled, e.g. `Text.equal("Amit Nanda", .headlineEm)`.
    static func equal(_ string: String, _ style: EqualTextStyle, color: Color = EqualColor.textPrimary) -> some View {
        Text(string).equalTextStyle(style).foregroundStyle(color)
    }
}
