import SwiftUI

/// Green splash: brand-green base with blurred lime blobs, the doodle pattern at 8%, the white
/// lockup and the tagline.
public struct SplashScreen: View {
    public init() {}
    public var body: some View {
        VStack(spacing: EqualSpacing.s24) {
            EqualLogo(height: 59, color: .white)
            Text("Your Personal AI Call Assistant").font(.equal(size: 20, weight: .semibold)).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EqualSplashBackground())
    }
}

/// The splash keyframe after launch: the lockup moves up, the tagline grows to 24pt, then the
/// social-proof card and the "Made in India" pill appear.
public struct SplashSocialProofScreen: View {
    public init() {}
    public var body: some View {
        VStack(spacing: 0) {
            EqualLogo(height: 52.8, color: .white).padding(.top, 182)
            Text("Your Personal AI Call Assistant").font(.equal(size: 24, weight: .semibold)).tracking(-1.44).foregroundStyle(.white).padding(.top, 17)
            EqualSocialProofCard().padding(.top, 62)
            Spacer()
            EqualMadeInIndiaPill().padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EqualSplashBackground())
    }
}

/// Brand-green field with three blurred lime blobs and the 8% doodle pattern.
public struct EqualSplashBackground: View {
    public init() {}
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                EqualColor.brandGreen
                Ellipse().fill(EqualColor.brandLime).frame(width: 493, height: 772).blur(radius: 150).offset(x: 80, y: 260)
                Ellipse().fill(EqualColor.brandLime).frame(width: 369, height: 578).blur(radius: 150).offset(x: -150, y: 500)
                Ellipse().fill(EqualColor.brandLime.opacity(0.7)).frame(width: 369, height: 577).blur(radius: 150).offset(x: 220, y: -260)
                EqualDoodlePattern(color: Color(equalHex: 0x737373)).opacity(0.08)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .ignoresSafeArea()
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View { SplashScreen(); SplashSocialProofScreen() }
}
