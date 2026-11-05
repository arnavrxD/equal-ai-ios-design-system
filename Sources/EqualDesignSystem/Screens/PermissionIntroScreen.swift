import SwiftUI

/// The permission walkthrough (Figma 20365:41714 … 43433): the intro with the device preview and
/// every state after "Enable permissions" — the in-app consent dialog, the iOS alerts (bundled
/// screenshots), the denied / limited sheets, the iOS contact picker and the hard gate.
///
/// Flow: intro → consent → notification alert → (denied: notification sheet) → contacts alert →
/// share picker → (limited: limited sheet · denied: contact sheet → what you’re losing) →
/// tracking alert. Both denied shows the Enable Permissions sheet; "Allow access to continue"
/// is the hard gate.
public struct PermissionIntroScreen: View {
    public enum State: CaseIterable, Hashable, Sendable {
        /// 41714 · "Let us notify you on who’s calling and why", Learn more, Maybe later.
        case intro
        /// 43363 · In-app "Allow Equal to process your call data?" dialog.
        case consent
        /// 41784 · iOS "Would Like to Send You Notifications" alert over the blurred intro.
        case notificationAlert
        /// 41848 · "Notification permission required" sheet.
        case notificationDenied
        /// 41966 · "Enable Permissions" sheet (both denied).
        case bothDenied
        /// 42084 · iOS Contacts alert.
        case contactsAlert
        /// 42568 · iOS "How do you want to share contacts?" picker (full screen).
        case shareContactsPicker
        /// 42214 · "Contact permission required" sheet.
        case contactDenied
        /// 42332 · "Limited contact access enabled" sheet.
        case limitedContacts
        /// 42450 · "What you’re losing" sheet.
        case whatYoureLosing
        /// 42148 · iOS App Tracking Transparency alert.
        case trackingAlert
        /// 43433 · "Allow access to continue" hard gate (no escape link).
        case allowAccess
    }

    /// The three intro copy versions in the file.
    enum Copy { case essentials, notify, enable }

    let state: State
    let onEnable: () -> Void
    let onLater: () -> Void
    let onLearnMore: () -> Void

    public init(state: State = .intro, onEnable: @escaping () -> Void = {}, onLater: @escaping () -> Void = {}, onLearnMore: @escaping () -> Void = {}) {
        self.state = state
        self.onEnable = onEnable
        self.onLater = onLater
        self.onLearnMore = onLearnMore
    }

    public var body: some View {
        switch state {
        case .intro:
            intro(.notify)
        case .consent:
            intro(.enable).overlay { EqualConsentDialog(backdrop: true) }
        case .allowAccess:
            intro(.enable).overlay { EqualPermissionSheet(.allowAccess, backdrop: .walkthrough) }
        case .notificationAlert:
            alert(.iosAlertNotifications, size: CGSize(width: 300, height: 202), y: 298)
        case .contactsAlert:
            alert(.iosAlertContacts, size: CGSize(width: 299, height: 263), y: 298)
        case .trackingAlert:
            alert(.iosAlertTracking, size: CGSize(width: 291, height: 328), y: 272, patch: "Equal AI App")
        case .shareContactsPicker:
            EqualImage.screenshotShareContacts.image.aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
                .accessibilityLabel("iOS: How do you want to share contacts?")
        case .notificationDenied: sheet(.notificationRequired)
        case .bothDenied: sheet(.enablePermissions)
        case .contactDenied: sheet(.contactRequired)
        case .limitedContacts: sheet(.limitedContacts)
        case .whatYoureLosing: sheet(.whatYoureLosing)
        }
    }

    // MARK: Intro

    private func intro(_ copy: Copy) -> some View {
        let page = copy == .enable ? Color(equalHex: 0xF7F7F7) : Color.white
        return VStack(spacing: 0) {
            header(copy)
            Group {
                switch copy {
                case .essentials: EqualPermissionPreview(.stacked).padding(.top, 43)
                case .notify: EqualPermissionPreview(.highlighted).padding(.top, 20)
                case .enable: EqualPermissionPreview(.highlighted, title: "Ramesh", fade: page).padding(.top, 57)
                }
            }
            .frame(height: copy == .essentials ? 443 : nil, alignment: .top)
            Spacer(minLength: 0)
            EqualButton("Enable permissions", fullWidth: true, action: onEnable)
                .padding(.horizontal, 25)
                .background {
                    // Figma layers the lime glow above the preview and below the CTA.
                    Circle().fill(EqualColor.brandLime.opacity(0.28)).frame(width: 272, height: 272).blur(radius: 150)
                        .offset(y: 68).allowsHitTesting(false)
                }
            if copy == .notify {
                Button(action: onLater) {
                    Text("Maybe later").font(.equal(size: 16, weight: .semibold)).tracking(-0.42).foregroundStyle(Color(equalHex: 0x111111))
                }
                .buttonStyle(.plain)
                .padding(.top, 15)
                .padding(.bottom, 30)
            } else {
                Color.clear.frame(height: 45)
            }
        }
        .padding(.top, 52)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            page.ignoresSafeArea()
        }
        .clipped()
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder private func header(_ copy: Copy) -> some View {
        switch copy {
        case .essentials:
            VStack(spacing: 0) {
                Text("Give your assistant the essentials").font(.equal(size: 24, weight: .semibold)).tracking(-1.44)
                    .foregroundStyle(.black).frame(height: 40)
                Text("Notifications help you stay informed, while contacts help your assistant recognize who’s calling.")
                    .font(.equal(size: 16)).tracking(-0.96).foregroundStyle(Color.black.opacity(0.7))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        case .notify:
            VStack(spacing: 8) {
                Text("Let us notify you on who’s calling and why").font(.equal(size: 22, weight: .bold)).tracking(-0.57)
                    .lineSpacing(28 - 22 * 1.3).foregroundStyle(Color(equalHex: 0x111111))
                    .frame(width: 313)
                VStack(spacing: 2) {
                    Text("Enable Contacts and Notifications access to recognise callers and provide call context.")
                        .font(.equal(size: 16)).tracking(-0.42).foregroundStyle(Color(equalHex: 0x555555))
                    Button(action: onLearnMore) {
                        Text("Learn more").font(.equal(size: 17, weight: .semibold)).tracking(-0.44).foregroundStyle(EqualColor.brandGreen)
                    }
                    .buttonStyle(.plain)
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        case .enable:
            VStack(spacing: 8) {
                Text("Let us notify you on who’s calling and why").font(.equal(size: 24, weight: .semibold))
                    .foregroundStyle(Color(equalHex: 0x111111)).frame(width: 313)
                Text("Enable notifications and contact permissions").font(.equal(size: 16)).foregroundStyle(Color(equalHex: 0x555555))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        }
    }

    // MARK: Overlays

    /// An iOS system alert (bundled screenshot) over the blurred v1 intro.
    private func alert(_ image: EqualImage, size: CGSize, y: CGFloat, patch: String? = nil) -> some View {
        ZStack(alignment: .top) {
            intro(.essentials).blur(radius: 4)
            Color(equalHex: 0x1E1E1E, alpha: 0.4).ignoresSafeArea()
            image.image
                .frame(width: size.width, height: size.height)
                .overlay(alignment: .topLeading) {
                    if let patch {
                        // Figma covers the sample app name in the stock ATT screenshot.
                        Text(patch).font(.equal(size: 14.5, weight: .bold)).foregroundStyle(.black)
                            .frame(width: 99, height: 18).background(Color(equalHex: 0xD0D0D0))
                            .offset(x: 78, y: 100)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding(.top, y - 62)
                .accessibilityLabel("iOS permission alert")
        }
    }

    private func sheet(_ preset: EqualPermissionSheet.Preset) -> some View {
        intro(.essentials).overlay { EqualPermissionSheet(preset, backdrop: .walkthrough) }
    }
}

struct PermissionIntroScreen_Previews: PreviewProvider {
    static var previews: some View {
        PermissionIntroScreen()
        PermissionIntroScreen(state: .consent)
        PermissionIntroScreen(state: .notificationAlert)
        PermissionIntroScreen(state: .whatYoureLosing)
    }
}
