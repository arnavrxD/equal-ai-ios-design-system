import SwiftUI

/// Home during the free Gold week (Empty State series 21402:64132 … 65864): header, the
/// `EqualTrialCountdownCard` for the day, search, then the empty state with "Meet Your Assistant"
/// on days 7 and 6 or the chat list from day 5. "Keep Gold" appears on days 2 and 1.
/// `showsPermissionCard` adds the Enable Permissions card under the countdown (21402:64236).
public struct TrialHomeScreen: View {
    let daysLeft: Int
    let chats: [EqualChat]
    let showsPermissionCard: Bool
    let onKeepGold: () -> Void
    let onMeetAssistant: () -> Void
    @State private var query = ""
    @State private var tab: EqualTabBar.Tab = .chats

    /// - Parameters:
    ///   - day: days of the trial left, 7...1.
    ///   - chats: defaults to none on days 7 and 6 and the sample list from day 5.
    public init(day: Int, chats: [EqualChat]? = nil, showsPermissionCard: Bool = false, onKeepGold: @escaping () -> Void = {}, onMeetAssistant: @escaping () -> Void = {}) {
        let d = min(max(day, 1), 7)
        self.daysLeft = d
        self.chats = chats ?? (d >= 6 ? [] : EqualChat.samples)
        self.showsPermissionCard = showsPermissionCard
        self.onKeepGold = onKeepGold
        self.onMeetAssistant = onMeetAssistant
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualAppHeader(badge: .goldLight)
            EqualScrollContent { page }
        }
        .overlay(alignment: .bottom) {
            EqualTabBar(selection: $tab, unread: chats.filter { $0.unread > 0 }.count)
                .padding(.top, 40)
                .frame(maxWidth: .infinity)
                .background(EqualGradient.fadeBottom.allowsHitTesting(false))
        }
        .equalScreenBackground()
    }

    var page: some View {
        VStack(spacing: 0) {
            VStack(spacing: 22) {
                VStack(spacing: EqualSpacing.s16) {
                    EqualTrialCountdownCard(daysLeft: daysLeft, onKeepGold: onKeepGold)
                    if showsPermissionCard { EqualPromoCard(.permissions) }
                }
                EqualSearchBar(query: $query)
            }
            .padding(.horizontal, 28)
            .padding(.top, 19)

            if chats.isEmpty {
                EqualEmptyState(
                    actionTitle: showsPermissionCard ? nil : "Meet Your Assistant",
                    illustrationSize: showsPermissionCard ? 117 : 160,
                    action: onMeetAssistant
                )
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.top, 47)
            } else {
                EqualChatList(chats.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) })
                    .padding(.horizontal, EqualSpacing.s24)
                    .padding(.top, 28)
            }
        }
        .padding(.bottom, 120)
    }
}

struct TrialHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        TrialHomeScreen(day: 7)
        TrialHomeScreen(day: 2)
    }
}
