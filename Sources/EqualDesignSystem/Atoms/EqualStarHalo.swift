import SwiftUI

/// The celebration halo behind the trial-started mascot: two concentric rounded 8-point star
/// outlines in white 40% (251 and 168) centred on the view, and a soft white-to-gold glow
/// (280, blur 154) sitting 74.5pt higher, as in Figma.
public struct EqualStarHalo: View {
    let size: CGFloat

    /// - Parameter size: the glow diameter; the stars scale with it (Figma 280).
    public init(size: CGFloat = 280) { self.size = size }

    public var body: some View {
        let s = size / 280
        ZStack {
            Circle()
                .fill(LinearGradient(stops: [
                    .init(color: .white, location: 0),
                    .init(color: Color(equalHex: 0xFFFEFC), location: 0.001),
                    .init(color: Color(equalHex: 0xFFC927), location: 1)
                ], startPoint: .top, endPoint: .bottom))
                .frame(width: size, height: size)
                .blur(radius: 77 * s)
                .offset(y: -74.5 * s)
            TrialStarShape(points: 8, innerRatio: 0.682, cornerRadius: 18 * s)
                .stroke(Color.white.opacity(0.4), lineWidth: 3 * s)
                .frame(width: 248 * s, height: 248 * s)
            TrialStarShape(points: 8, innerRatio: 0.682, cornerRadius: 12 * s)
                .stroke(Color.white.opacity(0.4), lineWidth: 2 * s)
                .frame(width: 166 * s, height: 166 * s)
        }
        .frame(width: size, height: size)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// A star polygon with rounded corners (Figma STAR with corner radius): `points` tips, inner
/// radius `innerRatio` of the outer radius. 4 points / 0.38 is the sparkle; 8 / 0.682 the halo.
struct TrialStarShape: Shape {
    var points: Int
    var innerRatio: CGFloat
    var cornerRadius: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2, inner = outer * innerRatio
        let n = points * 2
        let verts: [CGPoint] = (0..<n).map { i in
            let a = Double(i) / Double(n) * 2 * .pi - .pi / 2
            let r = i % 2 == 0 ? outer : inner
            return CGPoint(x: c.x + cos(a) * r, y: c.y + sin(a) * r)
        }
        func toward(_ from: CGPoint, _ to: CGPoint, _ d: CGFloat) -> CGPoint {
            let dx = to.x - from.x, dy = to.y - from.y
            let len = max(0.0001, sqrt(dx * dx + dy * dy))
            let t = min(d, len / 2) / len
            return CGPoint(x: from.x + dx * t, y: from.y + dy * t)
        }
        var p = Path()
        for i in 0..<n {
            let v = verts[i], prev = verts[(i + n - 1) % n], next = verts[(i + 1) % n]
            let a = toward(v, prev, cornerRadius), b = toward(v, next, cornerRadius)
            if i == 0 { p.move(to: a) } else { p.addLine(to: a) }
            p.addQuadCurve(to: b, control: v)
        }
        p.closeSubpath()
        return p
    }
}

struct EqualStarHalo_Previews: PreviewProvider {
    static var previews: some View {
        EqualStarHalo().padding(40).background(Color(equalHex: 0xFAFAFA))
    }
}
