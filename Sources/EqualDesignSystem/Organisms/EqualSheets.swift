import SwiftUI

/// The sheet the Equal FAB opens: handle, green Equal disc, a greeting with the user's name in
/// green, three square shortcuts, suggested chips from recent calls and the composer.
public struct EqualSheet: View {
    let name: String
    let suggestions: [EqualChatAction]
    @State private var text = ""

    public init(name: String = "Keshav", suggestions: [EqualChatAction] = [EqualChatAction("Reply Amit on WhatsApp", emoji: "💬"), EqualChatAction("Set reminder", emoji: "🔔")]) {
        self.name = name
        self.suggestions = suggestions
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s16) {
            Capsule().fill(Color(equalHex: 0xADADAD)).frame(width: 89, height: 5)
            EqualMark(size: 32, color: .white).frame(width: 64, height: 64).background(Circle().fill(EqualColor.green))
            VStack(spacing: 4) {
                (Text("Good morning, ") + Text(name).foregroundColor(EqualColor.green))
                    .font(.equal(size: 22, weight: .bold)).foregroundStyle(EqualColor.textPrimary)
                Text("What can I help you with today?").font(.equal(size: 15)).foregroundStyle(EqualColor.textSecondary)
            }
            HStack(spacing: EqualSpacing.s12) {
                EqualQuickActionTile("Talk to Equal", glyph: .equalMark, style: .square)
                EqualQuickActionTile("Set Instruction", glyph: .icon(.wand), style: .square)
                EqualQuickActionTile("Make a Call", glyph: .icon(.phone), style: .square)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: EqualSpacing.s12) {
                    ForEach(suggestions) { EqualChip($0.title, variant: .suggested, emoji: $0.emoji, showsChevron: false, tall: true) }
                }
                .padding(1)
            }
            EqualComposer(text: $text)
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, EqualSpacing.s12)
        .padding(.bottom, EqualSpacing.s32)
        .background(EqualColor.bgSurface)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
        .equalShadow(.sheet)
    }
}

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
