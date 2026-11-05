import SwiftUI

/// "Equal is noticing…" card under About You: a soft grey card with a glowing neural-network
/// line drawing, green and lime blur blobs, a header row with the Equal dot and a share button,
/// two lines of copy and the mascot with floating feature cards.
///
/// Figma 26242:89472 (Component 250), 345×204. The network (86 connections, 37 nodes) and the
/// glows are drawn in code; only the mascot is an image (`EqualImage.mascotFeaturesCards`).
public struct EqualNoticingCard: View {
    let title: String
    let message: String
    let onShare: () -> Void

    public init(title: String = "Check back in a few weeks to see what I've learnt...", message: String = "The more I know, the better your calls will be handled.", onShare: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.onShare = onShare
    }

    public var body: some View {
        Color(equalHex: 0xF8F8F8)
            .frame(maxWidth: .infinity)
            .frame(height: 204)
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    blob(EqualColor.brandGreen, size: 89, blur: 50).offset(x: 291, y: 151)
                    EqualNeuralNetwork().frame(width: 546.7, height: 303.72).offset(x: -111.95, y: 17.28)
                    blob(EqualColor.brandGreen, size: 68, blur: 50).offset(x: -11, y: 168)
                    blob(EqualColor.brandLime, size: 130, blur: 65).offset(x: 108, y: 46)
                    EqualImage.mascotFeaturesCards.image
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 227.66, height: 227.66)
                        .offset(x: 189.17, y: 18.44)
                        .accessibilityHidden(true)
                }
                .allowsHitTesting(false)
            }
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                        Text(title)
                            .font(.equal(size: 15, weight: .semibold)).tracking(-0.39)
                            .foregroundStyle(EqualColor.grey01)
                        Text(message)
                            .font(.equal(size: 12)).tracking(-0.312)
                            .foregroundStyle(EqualColor.grey05)
                            .frame(width: 160, alignment: .leading)
                    }
                    .frame(width: 184, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 36)
                }
                .padding(17)
            }
            .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
            .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(Color(equalHex: 0xF8F8F8)).shadow(color: .black.opacity(0.12), radius: 2))
            .environment(\.colorScheme, .light)
    }

    private var header: some View {
        HStack(spacing: EqualSpacing.s10) {
            HStack(spacing: EqualSpacing.s4) {
                Circle()
                    .fill(LinearGradient(colors: [EqualColor.brandLime, EqualColor.brandGreen], startPoint: UnitPoint(x: 0, y: -1.5), endPoint: .bottomTrailing))
                    .frame(width: 18, height: 18)
                    .overlay(EqualMark(size: 9, color: .white))
                    .accessibilityHidden(true)
                Text("Equal is noticing...")
                    .font(.equal(size: 11, weight: .bold)).tracking(-0.286)
                    .foregroundStyle(Color.black.opacity(0.8))
                    .opacity(0.8)
            }
            Spacer(minLength: 0)
            Button(action: onShare) {
                EqualIconView(.share, size: 12, weight: .medium)
                    .foregroundStyle(EqualColor.brandGreen)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color.white))
                    .opacity(0.32)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Share")
        }
        .frame(height: 24)
    }

    private func blob(_ color: Color, size: CGFloat, blur: CGFloat) -> some View {
        Circle().fill(color.opacity(0.2)).frame(width: size, height: size).blur(radius: blur)
    }
}

/// The white line-art network behind the noticing card (Figma "Neural Network", 546.7×303.7):
/// hairline connections and small glowing nodes.
struct EqualNeuralNetwork: View {
    var body: some View {
        Canvas { ctx, size in
            let sx = size.width / 546.7, sy = size.height / 303.72
            for l in Self.lines {
                var p = Path()
                p.move(to: CGPoint(x: l.0 * sx, y: l.1 * sy))
                p.addLine(to: CGPoint(x: l.2 * sx, y: l.3 * sy))
                ctx.stroke(p, with: .color(.white), lineWidth: l.4)
            }
            // Node glow: #E5EBFF @80%, spread 1.85, blur 7.
            ctx.drawLayer { glow in
                glow.addFilter(.blur(radius: 7))
                for n in Self.nodes {
                    let r = n.2 / 2 + 1.85
                    glow.fill(Path(ellipseIn: CGRect(x: n.0 * sx - r, y: n.1 * sy - r, width: r * 2, height: r * 2)), with: .color(Color(equalHex: 0xE5EBFF, alpha: 0.8)))
                }
            }
            for n in Self.nodes {
                let r = n.2 / 2
                ctx.fill(Path(ellipseIn: CGRect(x: n.0 * sx - r, y: n.1 * sy - r, width: r * 2, height: r * 2)), with: .color(.white))
            }
        }
        .accessibilityHidden(true)
    }

    /// Connections: (x1, y1, x2, y2, stroke width), in the 546.7×303.7 artboard.
    static let lines: [(CGFloat, CGFloat, CGFloat, CGFloat, CGFloat)] = [
        (55.7, 38.8, 122.1, 47.6, 0.68),
        (55.7, 38.8, 111.6, 116.7, 1.02),
        (49.0, 127.5, 111.6, 116.7, 1.21),
        (49.0, 127.5, 110.9, 194.8, 1.20),
        (122.1, 47.6, 210.9, 59.7, 0.69),
        (111.6, 116.7, 210.9, 59.7, 0.83),
        (111.6, 116.7, 193.8, 116.1, 0.63),
        (111.6, 116.7, 194.3, 183.6, 0.94),
        (110.9, 194.8, 193.8, 116.1, 0.71),
        (110.9, 194.8, 194.4, 183.6, 0.91),
        (122.7, 259.4, 194.3, 183.6, 0.70),
        (210.9, 59.7, 193.8, 116.1, 1.09),
        (210.9, 59.7, 288.1, 104.2, 0.76),
        (193.8, 116.1, 288.1, 104.2, 0.74),
        (193.8, 116.1, 288.2, 183.7, 0.81),
        (194.4, 183.6, 288.1, 104.2, 1.06),
        (194.4, 183.6, 288.2, 183.7, 0.86),
        (264.1, 30.4, 288.1, 104.2, 1.19),
        (288.1, 104.2, 338.6, 54.2, 0.96),
        (288.1, 104.2, 337.3, 106.5, 0.88),
        (288.1, 104.2, 348.9, 181.2, 0.99),
        (288.2, 183.7, 337.3, 106.5, 1.18),
        (288.2, 183.7, 348.9, 181.3, 0.91),
        (338.6, 54.2, 428.2, 44.4, 0.89),
        (338.6, 54.2, 422.2, 134.4, 0.66),
        (337.3, 106.5, 348.9, 181.2, 1.07),
        (337.3, 106.5, 422.2, 134.3, 0.70),
        (337.3, 106.5, 430.5, 198.2, 0.95),
        (348.9, 181.2, 422.2, 134.3, 0.98),
        (348.9, 181.3, 430.5, 198.2, 0.82),
        (348.9, 181.3, 418.5, 253.1, 0.84),
        (422.2, 134.3, 418.5, 253.1, 0.74),
        (422.2, 134.3, 497.8, 31.1, 1.10),
        (422.2, 134.4, 496.5, 120.6, 0.90),
        (430.5, 198.2, 495.4, 178.6, 1.00),
        (418.5, 253.1, 495.4, 178.6, 0.92),
        (122.1, 47.6, 49.0, 127.5, 0.62),
        (122.1, 47.6, 210.9, 59.7, 0.79),
        (111.6, 116.7, 158.6, 222.7, 0.61),
        (110.9, 194.8, 111.6, 116.7, 0.77),
        (110.9, 194.8, 193.8, 116.1, 0.90),
        (110.9, 194.8, 158.6, 222.7, 0.95),
        (210.9, 59.7, 150.0, 87.8, 0.50),
        (193.8, 116.2, 194.3, 183.6, 1.05),
        (193.8, 116.1, 288.1, 104.2, 0.67),
        (193.8, 116.1, 288.2, 183.7, 0.80),
        (194.4, 183.6, 110.9, 194.8, 0.90),
        (194.4, 183.6, 156.3, 147.0, 0.93),
        (194.4, 183.6, 235.7, 145.0, 0.70),
        (288.1, 104.2, 193.8, 116.1, 0.93),
        (288.1, 104.2, 264.1, 30.4, 0.51),
        (288.1, 104.2, 348.9, 181.2, 0.50),
        (288.2, 183.7, 348.9, 181.3, 0.57),
        (338.6, 54.2, 428.2, 44.4, 0.85),
        (337.3, 106.5, 338.6, 54.2, 0.74),
        (348.9, 181.2, 401.2, 88.1, 0.86),
        (348.9, 181.2, 235.7, 145.0, 0.83),
        (428.2, 44.4, 496.5, 120.6, 1.14),
        (422.2, 134.3, 348.9, 181.2, 0.93),
        (422.2, 134.4, 430.5, 198.2, 0.61),
        (430.5, 198.2, 418.5, 253.1, 0.78),
        (430.5, 198.2, 496.5, 120.6, 0.86),
        (418.5, 253.1, 348.9, 181.3, 0.52),
        (497.8, 31.1, 496.5, 120.6, 1.07),
        (495.4, 178.6, 496.5, 120.6, 0.65),
        (191.3, 265.1, 122.7, 259.4, 0.87),
        (191.3, 265.1, 78.2, 240.7, 0.56),
        (36.0, 266.3, 122.7, 259.4, 0.52),
        (490.2, 260.0, 430.5, 198.2, 0.63),
        (58.8, 190.4, 111.6, 116.7, 0.51),
        (58.8, 190.4, 36.0, 266.3, 0.91),
        (243.7, 253.1, 158.6, 222.7, 1.13),
        (314.4, 255.0, 288.2, 183.7, 0.63),
        (314.4, 255.0, 243.7, 253.1, 0.52),
        (158.6, 222.7, 122.7, 259.4, 0.90),
        (158.6, 222.7, 78.2, 240.7, 0.95),
        (156.2, 147.0, 122.7, 259.4, 1.12),
        (156.2, 147.0, 210.9, 59.7, 0.58),
        (156.3, 147.0, 194.4, 183.6, 1.18),
        (78.2, 240.7, 191.3, 265.1, 0.97),
        (78.2, 240.7, 158.6, 222.7, 0.91),
        (235.7, 145.0, 210.9, 59.7, 0.68),
        (235.7, 145.0, 264.1, 30.4, 1.08),
        (235.7, 145.0, 288.1, 104.2, 0.56),
        (198.4, 222.1, 194.3, 183.6, 0.99),
        (198.4, 222.1, 243.7, 253.1, 1.03)
    ]

    /// Nodes: (centre x, centre y, diameter).
    static let nodes: [(CGFloat, CGFloat, CGFloat)] = [
        (55.6, 38.8, 4.64),
        (49.0, 127.5, 4.13),
        (122.1, 47.6, 4.09),
        (111.6, 116.7, 5.31),
        (110.9, 194.8, 3.59),
        (122.7, 259.4, 4.03),
        (210.9, 59.7, 5.46),
        (193.8, 116.1, 4.17),
        (194.4, 183.6, 5.29),
        (264.1, 30.4, 7.23),
        (288.1, 104.2, 6.02),
        (288.2, 183.7, 5.95),
        (338.6, 54.2, 6.46),
        (337.3, 106.5, 4.65),
        (348.9, 181.2, 7.22),
        (428.2, 44.4, 5.02),
        (422.2, 134.3, 4.40),
        (430.5, 198.2, 6.55),
        (418.5, 253.1, 4.94),
        (497.8, 31.1, 3.08),
        (496.5, 120.6, 3.57),
        (495.4, 178.6, 4.59),
        (191.3, 265.1, 4.65),
        (36.0, 266.3, 5.20),
        (490.3, 260.0, 5.64),
        (58.8, 190.4, 3.52),
        (243.7, 253.1, 3.60),
        (314.4, 255.0, 2.72),
        (158.6, 222.7, 6.34),
        (401.2, 88.1, 2.98),
        (464.3, 79.4, 2.79),
        (150.1, 87.8, 5.60),
        (156.2, 147.0, 4.82),
        (78.2, 240.7, 3.67),
        (235.7, 145.0, 7.12),
        (198.4, 222.1, 6.27),
        (23.0, 202.0, 68.00)
    ]
}

struct EqualNoticingCard_Previews: PreviewProvider {
    static var previews: some View {
        EqualNoticingCard().padding(24).equalScreenBackground()
    }
}
