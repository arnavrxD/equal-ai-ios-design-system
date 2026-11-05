import SwiftUI

/// The six-dot Equal mark, drawn from the logo's vector paths.
public struct EqualMark: View {
    let size: CGFloat
    let color: Color

    /// - Parameter size: the mark's width; height follows the artboard (0.86 × width).
    public init(size: CGFloat = 24, color: Color = EqualColor.green) {
        self.size = size
        self.color = color
    }

    public var body: some View {
        EqualMarkShape()
            .fill(color)
            .frame(width: size, height: size * EqualMarkShape.artboard.height / EqualMarkShape.artboard.width)
            .accessibilityLabel("Equal")
    }
}

/// The equal ai lockup: the mark plus the lowercase wordmark, both vector.
public struct EqualLogo: View {
    let height: CGFloat
    let color: Color

    /// - Parameter height: the lockup height (the Figma lockup is 270 × 57).
    public init(height: CGFloat = 24, color: Color = EqualColor.green) {
        self.height = height
        self.color = color
    }

    public var body: some View {
        let s = height / 57
        HStack(spacing: 18.54 * s) {
            EqualMarkShape().fill(color).frame(width: 65.9 * s, height: 56.86 * s)
            EqualWordmarkShape().fill(color).frame(width: 185.56 * s, height: 48.08 * s)
        }
        .frame(height: height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("equal ai")
    }
}

/// The green iOS app icon: the white mark on a brand-green rounded square.
public struct EqualAppIcon: View {
    let size: CGFloat

    public init(size: CGFloat = 60) { self.size = size }

    public var body: some View {
        RoundedRectangle(cornerRadius: size * 0.2237, style: .continuous)
            .fill(EqualColor.brandGreen)
            .overlay(EqualMark(size: size * 0.58, color: .white))
            .frame(width: size, height: size)
            .accessibilityLabel("Equal AI")
    }
}

/// The round Indian flag used beside "+91": saffron, white and green bands with the 24-spoke Ashoka Chakra.
public struct EqualFlagIndia: View {
    let size: CGFloat

    public init(size: CGFloat = 28) { self.size = size }

    public var body: some View {
        VStack(spacing: 0) {
            Color(equalHex: 0xFF9933)
            Color.white.overlay(chakra)
            Color(equalHex: 0x138808)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.black.opacity(0.08), lineWidth: 0.5))
        .accessibilityLabel("India")
    }

    private var chakra: some View {
        let d = size / 3 * 0.86
        let navy = Color(equalHex: 0x000080)
        return ZStack {
            Circle().stroke(navy, lineWidth: max(0.6, d * 0.08))
            Path { p in
                for i in 0..<24 {
                    let a = Double(i) * .pi / 12
                    p.move(to: CGPoint(x: d / 2, y: d / 2))
                    p.addLine(to: CGPoint(x: d / 2 + cos(a) * d / 2, y: d / 2 + sin(a) * d / 2))
                }
            }
            .stroke(navy, lineWidth: max(0.4, d * 0.04))
            Circle().fill(navy).frame(width: d * 0.18, height: d * 0.18)
        }
        .frame(width: d, height: d)
    }
}
