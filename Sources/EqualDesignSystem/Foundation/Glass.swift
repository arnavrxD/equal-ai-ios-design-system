import SwiftUI

public extension View {
    /// iOS liquid-glass surface: translucent fill, blur and a hairline.
    func equalGlass<S: Shape>(_ shape: S, fill: Color = EqualColor.glassButton) -> some View {
        background(.ultraThinMaterial, in: shape)
            .background(fill, in: shape)
            .overlay(shape.stroke(EqualColor.strokeSubtle, lineWidth: 1))
    }

    /// A screen's default background.
    func equalScreenBackground() -> some View {
        background(EqualColor.bgPrimary.ignoresSafeArea())
    }
}

/// Wraps a preview in light and dark appearances side by side.
public struct EqualPreviewPair<Content: View>: View {
    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            content().padding().background(EqualColor.bgPrimary).environment(\.colorScheme, .light)
            content().padding().background(EqualColor.bgPrimary).environment(\.colorScheme, .dark)
        }
    }
}
