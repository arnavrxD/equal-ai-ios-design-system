import SwiftUI

/// Payment loader: the large `EqualRingLoader` (160pt frame, 133pt ring, 6.65pt `#5E460C` quarter
/// arc on a black 12% track; dark `#C88D00` on white 18%) with the 3D crown centred inside.
///
/// The crown is 95pt in a 90pt box at the 160pt size (0.59 × the frame); everything scales with `size`.
public struct EqualCrownLoader: View {
    let size: CGFloat

    /// - Parameter size: frame side (Figma: 160).
    public init(size: CGFloat = 160) { self.size = size }

    public var body: some View {
        EqualRingLoader(.large, size: size) {
            EqualIllustration(.crown, size: size * 90 / 160)
        }
        .accessibilityLabel("Processing")
    }
}

struct EqualCrownLoader_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 24) {
            EqualCrownLoader()
            EqualCrownLoader(size: 80)
        }
        .padding(24)
        .background(EqualGradient.processing)
    }
}
