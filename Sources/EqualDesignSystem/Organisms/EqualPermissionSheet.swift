import SwiftUI

/// Bottom sheet that asks for a system permission: close button, 3D illustration, title,
/// explanation, a primary "Open settings" button and a "Continue anyway" link.
public struct EqualPermissionSheet: View {
    let image: EqualImage
    let title: String
    let message: String
    let primaryTitle: String
    let secondaryTitle: String?
    let onPrimary: () -> Void
    let onSecondary: () -> Void
    let onClose: () -> Void

    public init(image: EqualImage = .bell,
                title: String = "Notification permission required",
                message: String = "Allow Equal AI to send you notifications to avoid missing important updates",
                primaryTitle: String = "Open settings",
                secondaryTitle: String? = "Continue anyway",
                onPrimary: @escaping () -> Void = {}, onSecondary: @escaping () -> Void = {}, onClose: @escaping () -> Void = {}) {
        self.image = image; self.title = title; self.message = message
        self.primaryTitle = primaryTitle; self.secondaryTitle = secondaryTitle
        self.onPrimary = onPrimary; self.onSecondary = onSecondary; self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            EqualIllustration(image, size: 88).frame(width: 120, height: 120)
            VStack(spacing: EqualSpacing.s16) {
                Text(title).equalTextStyle(.title2Em).foregroundStyle(EqualColor.textPrimary)
                Text(message).equalTextStyle(.body).foregroundStyle(EqualColor.textSecondary)
            }
            .multilineTextAlignment(.center)
            VStack(spacing: EqualSpacing.s12) {
                EqualButton(primaryTitle, icon: .gear, fullWidth: true, action: onPrimary)
                if let secondaryTitle { EqualButton(secondaryTitle, variant: .link, action: onSecondary) }
            }
            .padding(.top, EqualSpacing.s12)
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, EqualSpacing.s12)
        .padding(.bottom, EqualSpacing.s32)
        .frame(maxWidth: .infinity)
        .background(EqualColor.bgPrimary)
        .overlay(alignment: .topTrailing) { EqualIconButton(.close, label: "Close", action: onClose).padding(EqualSpacing.s24) }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
        .equalShadow(.sheet)
    }
}

struct EqualSheets_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) { EqualSheet(); EqualPermissionSheet() }
            .background(EqualColor.bgOverlay)
    }
}
