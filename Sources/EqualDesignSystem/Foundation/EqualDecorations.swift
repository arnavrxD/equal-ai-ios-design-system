import SwiftUI

/// Concentric hairline rings fading out, used on the membership and recap cards (4 rings, 82–152pt).
public struct EqualConcentricRings: View {
    let diameters: [CGFloat]
    let color: Color

    public init(diameters: [CGFloat] = [82, 111, 134, 152], color: Color = .white) {
        self.diameters = diameters
        self.color = color
    }

    public var body: some View {
        ZStack {
            ForEach(Array(diameters.enumerated()), id: \.offset) { i, d in
                Circle().stroke(color.opacity(0.18 - Double(i) * 0.035), lineWidth: 1).frame(width: d, height: d)
            }
        }
        .frame(width: diameters.max() ?? 0, height: diameters.max() ?? 0)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// A scalloped star / seal outline (the badge behind the profile avatar and the success mascot).
public struct EqualScallopedStar: Shape {
    let points: Int
    let depth: CGFloat

    /// - Parameters:
    ///   - points: number of scallops.
    ///   - depth: inner radius as a fraction of the outer radius.
    public init(points: Int = 12, depth: CGFloat = 0.86) {
        self.points = points
        self.depth = depth
    }

    public func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let R = min(rect.width, rect.height) / 2, r = R * depth
        var p = Path()
        let n = points * 2
        for i in 0...n {
            let a = Double(i) / Double(n) * 2 * .pi - .pi / 2
            let rad = i % 2 == 0 ? R : r
            let pt = CGPoint(x: c.x + cos(a) * rad, y: c.y + sin(a) * rad)
            if i == 0 { p.move(to: pt) } else {
                let ma = (Double(i) - 0.5) / Double(n) * 2 * .pi - .pi / 2
                let ctrl = CGPoint(x: c.x + cos(ma) * (R + r) / 2 * 1.04, y: c.y + sin(ma) * (R + r) / 2 * 1.04)
                p.addQuadCurve(to: pt, control: ctrl)
            }
        }
        p.closeSubpath()
        return p
    }
}

/// A soft blurred colour glow (gold behind crowns, green behind mascots).
public struct EqualGlow: View {
    let color: Color
    let size: CGFloat
    let opacity: Double

    public init(_ color: Color = Color(equalHex: 0xFFC927), size: CGFloat = 160, opacity: Double = 0.45) {
        self.color = color
        self.size = size
        self.opacity = opacity
    }

    public var body: some View {
        Circle().fill(color).frame(width: size, height: size).blur(radius: size / 3).opacity(opacity)
            .allowsHitTesting(false).accessibilityHidden(true)
    }
}
