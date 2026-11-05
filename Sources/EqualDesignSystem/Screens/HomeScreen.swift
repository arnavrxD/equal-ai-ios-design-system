import SwiftUI

/// Home = AppHeader + promo card or carousel + SearchBar + ChatList + TabBar, with the Equal
/// sheet on the FAB. Variants cover the first home (permission carousel), the home after
/// permissions (light GOLD badge, no promo), the empty list, the trial's last day and an
/// expired plan.
public struct HomeScreen: View {
    /// Home states from the Figma file.
    public enum Variant: Sendable {
        /// 20365:44071 — GOLD, compact availability pill, Enable Permissions + Meet Your Assistant carousel.
        case firstHome
        /// 24812:191992 — permissions granted: light GOLD badge, no promo card.
        case permissionsGranted
        /// No conversations yet: Meet Your Assistant card and the empty state.
        case empty
        /// 26242:22960 — last trial day: trial pill and the trial-ending card.
        case trialEnding
        /// 21402:67514 — plan expired: EXPIRED badge and the "Your plan has expired" card.
        case planExpired
    }

    let badge: EqualPlanBadge.Kind?
    let trailing: EqualAppHeader.Trailing
    let promos: [EqualPromoCard.Kind]
    let chats: [EqualChat]
    let showsTabBar: Bool
    @State private var query = ""
    @State private var tab: EqualTabBar.Tab = .chats
    @State private var showsEqual = false

    /// The original API: a plan name, one promo card and the chats.
    public init(plan: String? = "Gold", promo: EqualPromoCard.Kind? = .trialEnding, chats: [EqualChat] = EqualChat.samples) {
        let header = EqualAppHeader(plan: plan)
        self.badge = header.badge
        if case .trialEnding? = promo { self.trailing = .trial("1 Day Left") } else { self.trailing = .availability }
        self.promos = promo.map { [$0] } ?? []
        self.chats = chats
        self.showsTabBar = true
    }

    /// A home with an explicit header badge, trailing control and promo cards (two or more page
    /// in a carousel).
    public init(badge: EqualPlanBadge.Kind?, trailing: EqualAppHeader.Trailing = .availability, promos: [EqualPromoCard.Kind] = [],
                chats: [EqualChat] = EqualChat.samples, showsTabBar: Bool = true) {
        self.badge = badge
        self.trailing = trailing
        self.promos = promos
        self.chats = chats
        self.showsTabBar = showsTabBar
    }

    /// One of the Figma home states.
    public init(_ variant: Variant) {
        switch variant {
        case .firstHome:
            self.init(badge: .gold, trailing: .available(.compact, .glass), promos: [.permissions, .meetAssistant])
        case .permissionsGranted:
            self.init(badge: .goldLight)
        case .empty:
            self.init(badge: .goldLight, promos: [.meetAssistant], chats: [])
        case .trialEnding:
            self.init(badge: .gold, trailing: .trial("1 Day Left"), promos: [.trialEnding])
        case .planExpired:
            self.init(badge: .expired, promos: [.planExpired])
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualAppHeader(badge: badge, trailing: trailing)
            EqualScrollContent {
                VStack(spacing: 0) {
                    if promos.count > 1 {
                        EqualPromoCarousel(promos)
                            .padding(.top, 14)
                    } else if let promo = promos.first {
                        EqualPromoCard(promo).padding(.horizontal, EqualSpacing.s24).padding(.top, 18)
                    }
                    EqualSearchBar(query: $query)
                        .padding(.horizontal, EqualSpacing.s24)
                        .padding(.top, promos.isEmpty ? 23 : 18)
                    if chats.isEmpty {
                        EqualEmptyState().padding(.top, 40)
                    } else {
                        EqualChatList(chats.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) })
                            .padding(.horizontal, EqualSpacing.s24)
                            .padding(.top, 28)
                    }
                }
                .padding(.bottom, 120)
            }
        }
        .overlay(alignment: .bottom) {
            if showsTabBar {
                EqualTabBar(selection: $tab, unread: chats.filter { $0.unread > 0 }.count) { showsEqual = true }
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                    .background(EqualGradient.fadeBottom.allowsHitTesting(false))
            }
        }
        .equalScreenBackground()
        .sheet(isPresented: $showsEqual) {
            EqualSheet().presentationDetents([.medium, .large]).presentationDragIndicator(.hidden)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(.firstHome)
        HomeScreen(.permissionsGranted)
        HomeScreen(.empty)
        HomeScreen()
    }
}
