import SwiftUI

/// iPhone frame used in the walkthrough: 8.5pt black bezel (outside), radius 31.8, dynamic island,
/// and a screen slot. The default screen is the iOS lock screen on the blue wallpaper.
public struct EqualPhoneMockup<Screen: View>: View {
    let width: CGFloat
    let screen: Screen

    public init(width: CGFloat = 290.5, @ViewBuilder screen: () -> Screen) {
        self.width = width
        self.screen = screen()
    }

    public var body: some View {
        let s = width / 290.5
        screen
            .frame(width: width, height: 574 * s)
            .clipShape(RoundedRectangle(cornerRadius: 31.8 * s, style: .continuous))
            .overlay(alignment: .top) {
                Capsule().fill(Color.black).frame(width: 72 * s, height: 17 * s).padding(.top, 19 * s)
            }
            .padding(8.5 * s)
            .background(RoundedRectangle(cornerRadius: (31.8 + 8.5) * s, style: .continuous).fill(Color.black))
            .accessibilityHidden(true)
    }
}

public extension EqualPhoneMockup where Screen == EqualLockScreen {
    /// The lock-screen mockup.
    init(width: CGFloat = 290.5) { self.init(width: width) { EqualLockScreen() } }
}

/// iOS lock screen: blue wallpaper, date and a large clock (DM Sans for the brand rule).
public struct EqualLockScreen: View {
    let date: String
    let time: String

    public init(date: String = "Monday, June 6", time: String = "9:41") {
        self.date = date
        self.time = time
    }

    public var body: some View {
        ZStack(alignment: .top) {
            EqualImage.iosWallpaper.image.aspectRatio(contentMode: .fill)
            Color.black.opacity(0.25)
            VStack(spacing: 0) {
                Text(date).font(.equal(size: 16.5, weight: .medium)).foregroundStyle(.white.opacity(0.8))
                Text(time).font(.equal(size: 76, weight: .semibold)).tracking(-2).foregroundStyle(.white.opacity(0.85))
            }
            .padding(.top, 62)
        }
    }
}

struct EqualPhoneMockup_Previews: PreviewProvider {
    static var previews: some View { EqualPhoneMockup().padding(24).equalScreenBackground() }
}
