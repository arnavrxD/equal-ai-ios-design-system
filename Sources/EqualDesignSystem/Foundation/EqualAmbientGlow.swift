import SwiftUI

/// The soft blurred colour blobs behind the light onboarding screens (272pt ellipses at 28%,
/// Figma layer blur 300).
public enum EqualGlowLayout: Sendable {
    /// One lime blob low-left (phone, OTP, name screens).
    case signup
    /// Lime low-right and cyan top-left (walkthrough slides).
    case intro
    /// Intro plus a second lime blob mid-right (welcome break).
    case welcome
}

public extension View {
    /// Places the ambient onboarding glow behind the content, on `bgPrimary`.
    func equalAmbientGlow(_ layout: EqualGlowLayout) -> some View {
        background {
            GeometryReader { geo in
                let sx = geo.size.width / 393, sy = geo.size.height / 852
                ZStack(alignment: .topLeading) {
                    EqualColor.bgPrimary
                    ForEach(Array(blobs(layout).enumerated()), id: \.offset) { _, b in
                        Circle().fill(b.color.opacity(0.28))
                            .frame(width: 272, height: 272)
                            .blur(radius: 150)
                            .offset(x: b.x * sx, y: b.y * sy)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

private struct Blob { let x: CGFloat; let y: CGFloat; let color: Color }

private func blobs(_ layout: EqualGlowLayout) -> [Blob] {
    let lime = EqualColor.brandLime, cyan = Color(equalHex: 0x62F7FF)
    switch layout {
    case .signup: return [Blob(x: 60, y: 396, color: lime)]
    case .intro: return [Blob(x: 226, y: 610, color: lime), Blob(x: -63, y: -21, color: cyan)]
    case .welcome: return [Blob(x: 226, y: 610, color: lime), Blob(x: 225, y: 328, color: lime), Blob(x: -63, y: -21, color: cyan)]
    }
}
