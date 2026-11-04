import SwiftUI

/// Green splash with the white lockup and the tagline.
public struct SplashScreen: View {
    public init() {}
    public var body: some View {
        VStack(spacing: EqualSpacing.s24) {
            EqualLogo(height: 44, color: .white)
            Text("Your Personal AI Call Assistant").font(.equal(size: 20, weight: .medium)).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EqualGradient.splash.ignoresSafeArea())
    }
}

struct SplashScreen_Previews: PreviewProvider { static var previews: some View { SplashScreen() } }
