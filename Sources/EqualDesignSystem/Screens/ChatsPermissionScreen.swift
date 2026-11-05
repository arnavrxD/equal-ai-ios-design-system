import SwiftUI

/// The home while permissions are missing (Figma 20365:43521 … 45404). The first carousel card
/// names what is missing — Enable Permissions (both), Notification access or Contact access —
/// and Meet Your Assistant follows. Sheet variants put a permission sheet over the home on a
/// `#000@30%` scrim; the legacy variants use the avatar header, the three-card carousel,
/// "CONVERSATIONS" and compact rows.
public struct ChatsPermissionScreen: View {
    public enum Variant: CaseIterable, Hashable, Sendable {
        /// 44071 · notifications and contacts both missing.
        case enablePermissions
        /// 44372 · notifications missing.
        case notificationAccess
        /// 44673 · contacts missing.
        case contactAccess
        /// 45404 · single Meet Your Assistant card under the Enable Permissions sheet.
        case permissionsSheet
        /// 43521 · legacy home under the notification sheet.
        case legacyNotificationSheet
        /// 43796 · legacy home under the contact sheet.
        case legacyContactSheet
    }

    let variant: Variant
    let onPromo: (EqualPromoCard.Kind) -> Void
    let onOpenSettings: () -> Void
    @State private var query = ""

    public init(_ variant: Variant = .enablePermissions, onPromo: @escaping (EqualPromoCard.Kind) -> Void = { _ in }, onOpenSettings: @escaping () -> Void = {}) {
        self.variant = variant
        self.onPromo = onPromo
        self.onOpenSettings = onOpenSettings
    }

    public var body: some View {
        switch variant {
        case .enablePermissions:
            HomeScreen(badge: .gold, trailing: .available(.compact, .glass), promos: [.permissions, .meetAssistant])
        case .notificationAccess:
            HomeScreen(badge: .gold, trailing: .available(.compact, .glass), promos: [.notificationAccess, .meetAssistant])
        case .contactAccess:
            HomeScreen(badge: .gold, trailing: .available(.compact, .glass), promos: [.contactAccess, .meetAssistant])
        case .permissionsSheet:
            HomeScreen(badge: .gold, trailing: .available(.compact, .glass), promos: [.meetAssistant], showsTabBar: false)
                .overlay { EqualPermissionSheet(.enablePermissions, showsSecondary: false, backdrop: .home, onPrimary: onOpenSettings) }
        case .legacyNotificationSheet:
            legacyHome.overlay { EqualPermissionSheet(.notificationRequired, showsSecondary: false, backdrop: .home, onPrimary: onOpenSettings) }
        case .legacyContactSheet:
            legacyHome.overlay { EqualPermissionSheet(.contactRequired, showsSecondary: false, backdrop: .home, onPrimary: onOpenSettings) }
        }
    }

    /// The older home: avatar header, three-card carousel, CONVERSATIONS and compact rows.
    private var legacyHome: some View {
        VStack(spacing: 0) {
            EqualAppHeader(badge: nil, trailing: .avatar)
            EqualScrollContent {
                VStack(spacing: 0) {
                    EqualPromoCarousel([.meetAssistant, .callPreferences, .inviteFriend], leadingInset: 24, onAction: onPromo)
                        .padding(.top, 14)
                    EqualSectionHeader().padding(.horizontal, EqualSpacing.s24).padding(.top, 14)
                    EqualChatList(EqualChat.legacySamples, style: .compact)
                        .padding(.horizontal, 18)
                        .padding(.top, 10)
                }
            }
        }
        .equalScreenBackground()
    }
}

struct ChatsPermissionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatsPermissionScreen()
        ChatsPermissionScreen(.permissionsSheet)
        ChatsPermissionScreen(.legacyContactSheet)
    }
}
