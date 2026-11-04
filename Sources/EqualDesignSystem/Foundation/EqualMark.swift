import SwiftUI

/// The Equal mark: two rows of three dots, as in the logo.
public struct EqualMark: View {
    let size: CGFloat
    let color: Color

    public init(size: CGFloat = 24, color: Color = EqualColor.green) {
        self.size = size
        self.color = color
    }

    public var body: some View {
        let dot = size * 0.3
        VStack(spacing: size * 0.04) {
            ForEach(0..<2, id: \.self) { _ in
                HStack(spacing: size * 0.04) {
                    ForEach(0..<3, id: \.self) { _ in
                        Ellipse().fill(color).frame(width: dot, height: dot * 0.9)
                    }
                }
            }
        }
        .frame(width: size, height: size * 0.8)
        .accessibilityLabel("Equal")
    }
}

/// The equal ai lockup: mark plus lowercase wordmark.
public struct EqualLogo: View {
    let height: CGFloat
    let color: Color

    public init(height: CGFloat = 24, color: Color = EqualColor.green) {
        self.height = height
        self.color = color
    }

    public var body: some View {
        HStack(spacing: height * 0.3) {
            EqualMark(size: height * 1.15, color: color)
            Text("equal ai")
                .font(.equal(size: height * 1.05, weight: .regular))
                .tracking(-0.02 * height)
                .foregroundStyle(color)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("equal ai")
    }
}
