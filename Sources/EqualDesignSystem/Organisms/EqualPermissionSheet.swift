import SwiftUI

/// Bottom sheet that asks for a system permission: close button, 3D illustration, title,
/// explanation, a primary button (gear icon optional) and an optional "Continue anyway" link.
///
/// Each illustration keeps its Figma visual size inside the 120pt art frame (bell 76×83, gear
/// 100, contacts book 88×103, warning triangle 88×93; the bundled renders are tightly cropped,
/// so Figma's padded 179 / 146 frames become these sizes). Use a `Preset` for the walkthrough
/// and home copy, and `backdrop` to present the sheet over a dimmed screen.
public struct EqualPermissionSheet: View {
    /// The sheets of the permission walkthrough and the home.
    public enum Preset: Sendable {
        /// Bell · "Notification permission required" · Open settings / Continue anyway.
        case notificationRequired
        /// Gear · "Enable Permissions" (both denied) · Open settings / Continue anyway.
        case enablePermissions
        /// Contacts book · "Contact permission required" · Open settings / Continue anyway.
        case contactRequired
        /// Contacts book · "Limited contact access enabled" · Update settings / Continue anyway.
        case limitedContacts
        /// Contacts book · "What you’re losing" · Update settings / Continue anyway.
        case whatYoureLosing
        /// Warning triangle · "Allow access to continue" · Allow access (no icon, no escape link).
        case allowAccess
    }

    /// Dimmed backdrop behind a presented sheet.
    public enum Backdrop: Sendable {
        /// `#1E1E1E@40%` (walkthrough).
        case walkthrough
        /// `#000@30%` (home).
        case home
        var color: Color { self == .home ? Color.black.opacity(0.3) : Color(equalHex: 0x1E1E1E, alpha: 0.4) }
    }

    let image: EqualImage
    let title: String
    let message: String
    let primaryTitle: String
    let primaryIcon: EqualIcon?
    let secondaryTitle: String?
    let backdrop: Backdrop?
    let onPrimary: () -> Void
    let onSecondary: () -> Void
    let onClose: () -> Void

    /// - Parameters:
    ///   - primaryIcon: the icon before the primary title (`nil` for "Allow access").
    ///   - secondaryTitle: the underlined link under the button; `nil` hides it.
    ///   - backdrop: when set, the sheet fills the screen bottom-aligned over that scrim.
    public init(image: EqualImage = .bell,
                title: String = "Notification permission required",
                message: String = "Allow Equal AI to send you notifications to avoid missing important updates",
                primaryTitle: String = "Open settings",
                primaryIcon: EqualIcon? = .gear,
                secondaryTitle: String? = "Continue anyway",
                backdrop: Backdrop? = nil,
                onPrimary: @escaping () -> Void = {}, onSecondary: @escaping () -> Void = {}, onClose: @escaping () -> Void = {}) {
        self.image = image; self.title = title; self.message = message
        self.primaryTitle = primaryTitle; self.primaryIcon = primaryIcon; self.secondaryTitle = secondaryTitle
        self.backdrop = backdrop
        self.onPrimary = onPrimary; self.onSecondary = onSecondary; self.onClose = onClose
    }

    /// A walkthrough or home sheet with its Figma copy.
    /// - Parameter showsSecondary: the home variants drop the "Continue anyway" link.
    public init(_ preset: Preset, showsSecondary: Bool = true, backdrop: Backdrop? = nil,
                onPrimary: @escaping () -> Void = {}, onSecondary: @escaping () -> Void = {}, onClose: @escaping () -> Void = {}) {
        let link: String? = showsSecondary ? "Continue anyway" : nil
        switch preset {
        case .notificationRequired:
            self.init(image: .bell, title: "Notification permission required",
                      message: "Allow Equal AI to send you notifications to avoid missing important updates",
                      secondaryTitle: link, backdrop: backdrop, onPrimary: onPrimary, onSecondary: onSecondary, onClose: onClose)
        case .enablePermissions:
            self.init(image: .gear, title: "Enable Permissions",
                      message: "Allow notifications and contacts access to recognise calls and update you in real time.",
                      secondaryTitle: link, backdrop: backdrop, onPrimary: onPrimary, onSecondary: onSecondary, onClose: onClose)
        case .contactRequired:
            self.init(image: .contactsBook, title: "Contact permission required",
                      message: "Allows Equal to recognise callers and provide call assistance. Without it, the assistant can’t handle calls.",
                      secondaryTitle: link, backdrop: backdrop, onPrimary: onPrimary, onSecondary: onSecondary, onClose: onClose)
        case .limitedContacts:
            self.init(image: .contactsBook, title: "Limited contact access enabled",
                      message: "Calls from contacts you haven’t shared with Equal AI will be treated as unknown calls.",
                      primaryTitle: "Update settings", secondaryTitle: link, backdrop: backdrop, onPrimary: onPrimary, onSecondary: onSecondary, onClose: onClose)
        case .whatYoureLosing:
            self.init(image: .contactsBook, title: "What you’re losing",
                      message: "Without contact permission, your assistant won’t be able to distinguish between known and unknown callers",
                      primaryTitle: "Update settings", secondaryTitle: link, backdrop: backdrop, onPrimary: onPrimary, onSecondary: onSecondary, onClose: onClose)
        case .allowAccess:
            self.init(image: .warningTriangle, title: "Allow access to continue",
                      message: "Without this permission, your AI assistant won’t be able to answer calls, provide caller insights, or protect you from unwanted calls.",
                      primaryTitle: "Allow access", primaryIcon: nil, secondaryTitle: nil, backdrop: backdrop, onPrimary: onPrimary, onSecondary: onSecondary, onClose: onClose)
        }
    }

    public var body: some View {
        if let backdrop {
            ZStack(alignment: .bottom) {
                backdrop.color.ignoresSafeArea()
                sheet
            }
        } else {
            sheet
        }
    }

    private var sheet: some View {
        VStack(spacing: EqualSpacing.s12) {
            art
            VStack(spacing: EqualSpacing.s16) {
                Text(title).equalTextStyle(.title2Em).foregroundStyle(EqualColor.textPrimary)
                Text(message).equalTextStyle(.body).foregroundStyle(EqualColor.textSecondary)
            }
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            VStack(spacing: EqualSpacing.s12) {
                EqualButton(primaryTitle, icon: primaryIcon, fullWidth: true, action: onPrimary)
                if let secondaryTitle { EqualButton(secondaryTitle, variant: .link, action: onSecondary) }
            }
            .padding(.top, EqualSpacing.s12)
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, EqualSpacing.s12)
        .padding(.bottom, EqualSpacing.s32)
        .frame(maxWidth: .infinity)
        .background(EqualColor.bgPrimary)
        .overlay(alignment: .topTrailing) {
            EqualIconButton(.close, label: "Close", action: onClose).padding(.top, 22).padding(.trailing, EqualSpacing.s24)
        }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
    }

    /// The illustration at its Figma size and offset inside the 120pt frame.
    private var art: some View {
        let spec: (w: CGFloat, h: CGFloat, x: CGFloat, y: CGFloat) = switch image.name {
        case EqualImage.bell.name: (76, 83, 0, 0)
        case EqualImage.gear.name: (100, 104, 0, 0)
        case EqualImage.contactsBook.name: (88, 103, 0, 0)
        case EqualImage.warningTriangle.name: (88, 93, 0, 0)
        default: (88, 88, 0, 0)
        }
        return image.image
            .aspectRatio(contentMode: .fit)
            .frame(width: spec.w, height: spec.h)
            .offset(x: spec.x, y: spec.y)
            .frame(width: 120, height: 120)
            .accessibilityHidden(true)
    }
}

struct EqualSheets_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) { EqualPermissionSheet(); EqualPermissionSheet(.allowAccess) }
            .background(EqualColor.bgOverlay)
    }
}
