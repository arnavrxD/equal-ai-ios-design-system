import SwiftUI

// Home, chats, permissions, Equal sheet and limit-flow chats.
extension EqualCatalog {
    static let homeItems: [EqualCatalogItem] = homeComponents + homeScreens

    private static let homeComponents: [EqualCatalogItem] = [
        // Atoms
        EqualCatalogItem("EqualPlanBadge", .atoms, "Header plan badge: GOLD, light GOLD, GOLD PLUS, TRIAL, TRIAL ENDED, EXPIRED.") {
            VStack(alignment: .leading, spacing: 12) {
                HStack { EqualPlanBadge(.gold); EqualPlanBadge(.goldLight); EqualPlanBadge(.goldPlus) }
                HStack { EqualPlanBadge(.trial); EqualPlanBadge(.trialEnded); EqualPlanBadge(.expired) }
            }
            .padding(12).background(Color.white)
        },
        EqualCatalogItem("EqualGoldWordmark", .atoms, "Vector GOLD wordmark for plan badges.") {
            HStack(spacing: 16) {
                EqualGoldWordmark(width: 60).padding(10).background(Color.black)
                EqualGoldWordmark(width: 60, color: Color(equalHex: 0xB88D1A)).padding(10).background(Color.white)
            }
        },
        EqualCatalogItem("EqualNotificationSkeleton", .atoms, "Placeholder lock-screen notification, primary and faded.") {
            VStack(spacing: 21) { EqualNotificationSkeleton(); EqualNotificationSkeleton(.faded) }
                .padding(16).background(LinearGradient(colors: [Color(equalHex: 0x6C8FB8), .white], startPoint: .top, endPoint: .bottom))
        },
        EqualCatalogItem("EqualBubbleTail", .atoms, "Curved tail on the first assistant bubble.") {
            EqualBubbleTail().fill(Color.white).frame(width: 35, height: 30).padding(16).background(Color(equalHex: 0xE8E8E8))
        },

        // Molecules
        EqualCatalogItem("EqualLockScreenNotification", .molecules, "Light frosted lock-screen notification, large and small.") {
            VStack(spacing: 16) {
                EqualLockScreenNotification()
                EqualLockScreenNotification("Equal AI", message: "Missed call from Mom", detail: "Mom said she’d be late getting home and asked you to call her back when free.", size: .small)
            }
            .padding(.vertical, 16).frame(maxWidth: .infinity).background(Color(equalHex: 0x4E6E96))
        },
        EqualCatalogItem("EqualSectionHeader", .molecules, "CONVERSATIONS header with the glass ⋯ button.") { EqualSectionHeader() },
        EqualCatalogItem("EqualChatWallpaper", .molecules, "Doodle wallpaper behind the chat sheet, full and strip.") {
            VStack(spacing: 0) { EqualChatWallpaper().frame(height: 300); EqualChatWallpaper(.strip) }
        },

        // Organisms
        EqualCatalogItem("EqualPermissionPreview", .organisms, "Phone with the lock screen and an Equal notification.") {
            VStack(spacing: 16) { EqualPermissionPreview(); EqualPermissionPreview(.stacked).scaleEffect(0.9) }
                .frame(maxWidth: .infinity).background(Color.white)
        },
        EqualCatalogItem("EqualConsentDialog", .organisms, "Allow Equal to process your call data?") { EqualConsentDialog().frame(maxWidth: .infinity) },
        EqualCatalogItem("EqualPromoCarousel", .organisms, "Paging promo cards with the next one peeking and page dots.") {
            EqualPromoCarousel([.permissions, .meetAssistant]).padding(.horizontal, -24)
        }
    ]

    private static let homeScreens: [EqualCatalogItem] = {
        var items: [EqualCatalogItem] = [
            EqualCatalogItem("Home · first", .screens, "Permission carousel, GOLD header, chat list.") { HomeScreen(.firstHome) },
            EqualCatalogItem("Home · permissions granted", .screens, "Light GOLD badge, no promo card.") { HomeScreen(.permissionsGranted) },
            EqualCatalogItem("Home · plan expired", .screens, "EXPIRED badge and the Renew Gold card.") { HomeScreen(.planExpired) },
            EqualCatalogItem("Home · no chats", .screens, "Meet Your Assistant and the empty state.") { HomeScreen(.empty) }
        ]
        let states: [(PermissionIntroScreen.State, String, String)] = [
            (.intro, "Permission intro", "Let us notify you on who’s calling and why."),
            (.consent, "Permission · consent", "In-app call-data consent dialog."),
            (.notificationAlert, "Permission · notification alert", "iOS notification alert over the intro."),
            (.notificationDenied, "Permission · notification denied", "Notification permission required."),
            (.bothDenied, "Permission · both denied", "Enable Permissions sheet."),
            (.contactsAlert, "Permission · contacts alert", "iOS Contacts alert."),
            (.shareContactsPicker, "Permission · share picker", "iOS limited-access contact picker."),
            (.contactDenied, "Permission · contact denied", "Contact permission required."),
            (.limitedContacts, "Permission · limited contacts", "Limited contact access enabled."),
            (.whatYoureLosing, "Permission · what you’re losing", "Without contacts, callers look unknown."),
            (.trackingAlert, "Permission · tracking alert", "iOS App Tracking Transparency alert."),
            (.allowAccess, "Permission · allow access", "Hard gate: Allow access to continue.")
        ]
        items += states.map { s in EqualCatalogItem(s.1, .screens, s.2) { PermissionIntroScreen(state: s.0) } }
        let chats: [(ChatsPermissionScreen.Variant, String, String)] = [
            (.enablePermissions, "Chats permission · both", "Enable Permissions card first in the carousel."),
            (.notificationAccess, "Chats permission · notifications", "Notification access card."),
            (.contactAccess, "Chats permission · contacts", "Contact access card."),
            (.permissionsSheet, "Chats permission · sheet", "Enable Permissions sheet over the home."),
            (.legacyNotificationSheet, "Chats permission · legacy notification", "Legacy home under the notification sheet."),
            (.legacyContactSheet, "Chats permission · legacy contact", "Legacy home under the contact sheet.")
        ]
        items += chats.map { c in EqualCatalogItem(c.1, .screens, c.2) { ChatsPermissionScreen(c.0) } }
        let steps: [(LimitFlowChatScreen.Step, String)] = [(.equalSheet, "Equal sheet"), (.limitMessage, "limit message"), (.backInChat, "back in chat"), (.backInChatScrolled, "full thread")]
        for flow in EqualLimitFlow.allCases {
            for step in steps {
                items.append(EqualCatalogItem("Limit chat · \(flow.title) · \(step.1)", .screens, "\(flow.title) flow, \(step.1).") {
                    LimitFlowChatScreen(flow: flow, step: step.0)
                })
            }
        }
        return items
    }()
}
