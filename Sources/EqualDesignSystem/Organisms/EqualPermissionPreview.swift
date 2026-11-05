import SwiftUI

/// The device preview on the permission intro: an iPhone 17 Pro Max (image) showing the blue lock
/// screen, faded to the page colour at the bottom, with a frosted Equal notification on top.
/// **highlighted** (340×463): a large notification breaking out of the phone plus two skeletons.
/// **stacked** (345×515): a bigger phone with the small "Missed call from Mom" notification.
public struct EqualPermissionPreview: View {
    public enum Style: Sendable {
        /// Large notification over the phone edge and two placeholder notifications (v2/v3 intro).
        case highlighted
        /// Small notification inside the phone (v1 intro, behind the system alerts).
        case stacked
    }

    let style: Style
    let title: String
    let message: String
    let fade: Color

    /// - Parameters:
    ///   - title: the notification title ("Vishnu Office", "Ramesh"; the stacked style always shows "Equal AI").
    ///   - message: the notification body.
    ///   - fade: the page colour the phone fades into (white, or `#F7F7F7` on grey screens).
    public init(_ style: Style = .highlighted, title: String = "Vishnu Office", message: String = "Called to confirm lunch plan", fade: Color = .white) {
        self.style = style
        self.title = title
        self.message = message
        self.fade = fade
    }

    public var body: some View {
        switch style {
        case .highlighted:
            ZStack(alignment: .topLeading) {
                device(width: 274, height: 435).offset(x: 33, y: 12)
                LinearGradient(colors: [fade.opacity(0), fade], startPoint: .top, endPoint: .bottom)
                    .frame(width: 339, height: 292).offset(y: 171)
                EqualLockScreenNotification(title, message: message).offset(x: 1, y: 167)
                EqualNotificationSkeleton().offset(x: 48, y: 260)
                EqualNotificationSkeleton(.faded).offset(x: 48, y: 333)
            }
            .frame(width: 340, height: 463, alignment: .topLeading)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Preview: \(title), \(message)")
        case .stacked:
            ZStack(alignment: .topLeading) {
                device(width: 314, height: 499).offset(x: 16)
                LinearGradient(colors: [fade.opacity(0), fade], startPoint: .top, endPoint: .bottom)
                    .frame(width: 345, height: 297).offset(y: 218)
                EqualLockScreenNotification("Equal AI", message: "Missed call from Mom",
                                            detail: "Mom said she’d be late getting home and asked you to call her back when free.", size: .small)
                    .offset(x: 39, y: 187)
            }
            .frame(width: 345, height: 515, alignment: .topLeading)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Preview: Equal AI, missed call from Mom")
        }
    }

    /// The phone frame image over the lock screen, clipped at `height`.
    private func device(width: CGFloat, height: CGFloat) -> some View {
        let s = width / 274
        let phoneHeight = width * 1429 / 700
        return ZStack(alignment: .top) {
            lockScreen(scale: s)
                .frame(width: width - 28 * s, height: phoneHeight - 2 * 24.6 * s)
                .clipShape(RoundedRectangle(cornerRadius: 37 * s, style: .continuous))
                .padding(.top, 24.6 * s)
            EqualImage.iphone17ProMaxMockup.image
                .frame(width: width, height: phoneHeight)
                .padding(.top, 9 * s)
        }
        .frame(width: width, height: height, alignment: .top)
        .clipped()
    }

    private func lockScreen(scale s: CGFloat) -> some View {
        Color.black
            .overlay(alignment: .top) {
                // Figma: wallpaper 283×662 starting 20pt above the screen's top edge.
                EqualImage.iosWallpaper.image.aspectRatio(contentMode: .fill)
                    .frame(width: 283 * s, height: 662 * s)
                    .offset(y: -20 * s)
            }
            .overlay(Color.black.opacity(0.25))
            .overlay(LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottom).opacity(0.05))
            .overlay(alignment: .top) { lockContent(scale: s) }
            .clipped()
    }

    private func lockContent(scale s: CGFloat) -> some View {
            VStack(spacing: 0) {
                HStack {
                    Text("9:41").font(.equal(size: 11 * s, weight: .semibold))
                    Spacer()
                    HStack(spacing: 3 * s) {
                        Image(systemName: "cellularbars")
                        Image(systemName: "wifi")
                        Image(systemName: "battery.100")
                    }
                    .font(.system(size: 9 * s, weight: .semibold))
                }
                .foregroundStyle(Color.white.opacity(0.85))
                .padding(.horizontal, 22 * s)
                .padding(.top, 8 * s)
                Text("Monday, June 6").font(.equal(size: 14.4 * s, weight: .medium))
                    .padding(.top, 12 * s)
                Text("9:41").font(.equal(size: 64 * s, weight: .semibold)).tracking(-2 * s)
                    .padding(.top, -6 * s)
            }
            .foregroundStyle(Color.white.opacity(0.8))
    }
}

struct EqualPermissionPreview_Previews: PreviewProvider {
    static var previews: some View {
        HStack(alignment: .top) {
            EqualPermissionPreview()
            EqualPermissionPreview(.stacked)
        }
        .padding(24)
        .background(Color.white)
    }
}
