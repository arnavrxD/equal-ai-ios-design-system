import SwiftUI

/// Home = AppHeader + PromoCard + SearchBar + ChatList + TabBar, with the Equal sheet on the FAB.
public struct HomeScreen: View {
    let plan: String?
    let promo: EqualPromoCard.Kind?
    let chats: [EqualChat]
    @State private var query = ""
    @State private var tab: EqualTabBar.Tab = .chats
    @State private var showsEqual = false

    public init(plan: String? = "Gold", promo: EqualPromoCard.Kind? = .trialEnding, chats: [EqualChat] = EqualChat.samples) {
        self.plan = plan
        self.promo = promo
        self.chats = chats
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualAppHeader(plan: plan, trailing: promo.map { if case .trialEnding = $0 { return .trial("1 Day Left") } else { return .availability } } ?? .availability)
            ScrollView {
                VStack(spacing: EqualSpacing.s16) {
                    if let promo { EqualPromoCard(promo) }
                    EqualSearchBar(query: $query)
                    if chats.isEmpty {
                        EqualEmptyState().padding(.top, 40)
                    } else {
                        EqualChatList(chats.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) })
                    }
                }
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.top, EqualSpacing.s16)
                .padding(.bottom, 120)
            }
        }
        .overlay(alignment: .bottom) {
            EqualTabBar(selection: $tab, unread: chats.filter { $0.unread > 0 }.count) { showsEqual = true }
                .padding(.top, 40)
                .frame(maxWidth: .infinity)
                .background(EqualGradient.fadeBottom.allowsHitTesting(false))
        }
        .equalScreenBackground()
        .sheet(isPresented: $showsEqual) {
            EqualSheet().presentationDetents([.medium, .large]).presentationDragIndicator(.hidden)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
        HomeScreen(plan: nil, promo: .goldDays(7), chats: [])
    }
}
