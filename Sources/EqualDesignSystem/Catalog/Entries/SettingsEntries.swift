import SwiftUI

// Settings, subscription, membership and renew.
extension EqualCatalog {
    static let settingsItems: [EqualCatalogItem] = [
        EqualCatalogItem("EqualProfileAvatarBadge", .atoms, "Settings avatar: gold scalloped star (active, trial) or green circle (expired).") {
            HStack(spacing: 24) {
                EqualProfileAvatarBadge(.gold)
                EqualProfileAvatarBadge(.expired)
            }
            .padding(16)
            .background(Color(equalHex: 0xFFE9A6), in: RoundedRectangle(cornerRadius: EqualRadius.m))
        },
        EqualCatalogItem("EqualNoticingCard", .molecules, "\"Equal is noticing…\" card under About You, with the coded neural-network art.") {
            EqualNoticingCard()
        },
        EqualCatalogItem("EqualRenewSheet", .organisms, "Expired subscription bottom sheet: Renew Plan and Explore other plans.") {
            EqualRenewSheet().padding(.horizontal, -24).padding(.bottom, -24)
        },
        EqualCatalogItem("Settings · trial", .screens, "Free trial: back row, Free Trial tag.") { SettingsScreen(status: .trial) },
        EqualCatalogItem("Subscription · expired", .screens, "Subscription expired with the Renew sheet.") { SubscriptionScreen(status: .expired) },
    ]
}
