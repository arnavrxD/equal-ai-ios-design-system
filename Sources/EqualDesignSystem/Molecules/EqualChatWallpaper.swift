import SwiftUI

/// The doodle wallpaper behind the Equal chat sheet: `#E8E8E8` with the doodle pattern in black
/// at 32% inside a 16% layer (≈5% ink). **full** fills its frame; **strip** is the 392×165
/// extension ("BG pattern 6") that continues the art below a full panel.
public struct EqualChatWallpaper: View {
    public enum Style: Sendable {
        /// Fills the available space (392×446 in the chat sheet).
        case full
        /// A 165pt band of the same art.
        case strip
    }

    let style: Style
    let opacity: Double

    /// - Parameter opacity: layer opacity of the pattern (Figma 0.16).
    public init(_ style: Style = .full, opacity: Double = 0.16) {
        self.style = style
        self.opacity = opacity
    }

    public var body: some View {
        Color(equalHex: 0xE8E8E8)
            .overlay(alignment: .top) {
                GeometryReader { geo in
                    let w = max(geo.size.width, 392) * 1.05, h = w * 1478 / 1300
                    // Tiles vertically so tall sheets stay covered.
                    VStack(spacing: 0) {
                        ForEach(0..<max(1, Int((geo.size.height / h).rounded(.up))), id: \.self) { _ in
                            EqualDoodlePattern(color: Color.black.opacity(0.32)).frame(width: w, height: h)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                    .clipped()
                }
                .opacity(opacity)
            }
            .frame(height: style == .strip ? 165 : nil)
            .clipped()
            .accessibilityHidden(true)
    }
}

struct EqualChatWallpaper_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) { EqualChatWallpaper().frame(width: 392, height: 446); EqualChatWallpaper(.strip).frame(width: 392) }
    }
}
