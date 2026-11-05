import SwiftUI

/// The curved tail on the first assistant bubble of a run (18×15, Figma "Vector 39"), drawn from
/// design/icons/bubble-tail-curved.svg. Its right edge joins the bubble's top-left corner.
public struct EqualBubbleTail: Shape {
    public static let artboard = CGSize(width: 17.5, height: 15.1)
    public init() {}

    public func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 1.6))
        p.addCurve(to: CGPoint(x: 17.5, y: 3.1), control1: CGPoint(x: 7.23, y: -1.26), control2: CGPoint(x: 10.68, y: 0.01))
        p.addLine(to: CGPoint(x: 17.5, y: 15.1))
        p.addCurve(to: CGPoint(x: 0, y: 1.6), control1: CGPoint(x: 11.98, y: 9.5), control2: CGPoint(x: 9.12, y: 4.93))
        p.closeSubpath()
        return p.fitted(Self.artboard, in: rect)
    }
}

struct EqualBubbleTail_Previews: PreviewProvider {
    static var previews: some View {
        EqualBubbleTail().fill(Color.white).frame(width: 36, height: 30).padding(24).background(Color(equalHex: 0xE8E8E8))
    }
}
