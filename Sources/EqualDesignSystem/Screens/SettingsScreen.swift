import SwiftUI

/// Settings = ProfileHeader + MembershipCard + AssistantToggleCard + SettingsRow groups + InviteCard.
public struct SettingsScreen: View {
    let status: EqualMembershipCard.Status
    @State private var assistantOn = true

    public init(status: EqualMembershipCard.Status = .active) { self.status = status }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                EqualProfileHeader(isExpired: status == .expired, onBack: status == .active ? nil : {})
                    .padding(.bottom, 56)
                    .overlay(alignment: .bottom) { EqualMembershipCard(status: status).padding(.horizontal, EqualSpacing.s24).offset(y: 12) }
                VStack(spacing: EqualSpacing.s32) {
                    VStack(spacing: EqualSpacing.s16) {
                        EqualSectionLabel("Your assistant", style: .group)
                        EqualAssistantToggleCard(isOn: $assistantOn)
                        EqualSettingsGroup {
                            EqualSettingsRow("Instructions", icon: .document, subtitle: "4 active instructions", badge: "New")
                            EqualSettingsRow("Call Handling", icon: .phoneOutline, subtitle: "Saved contacts + Unknown numbers")
                            EqualSettingsRow("Silent Mode", icon: .bellSlash, subtitle: "Mute all promotional calls")
                            EqualSettingsRow("Voice & Language", icon: .mic, subtitle: "Calm & Friendly · Hindi, English, Telugu", showsDivider: false)
                        }
                    }
                    VStack(spacing: EqualSpacing.s16) {
                        EqualSectionLabel("About you", style: .group)
                        EqualSettingsGroup {
                            EqualSettingsRow("Personal Details", icon: .person, subtitle: "Name, gender, language")
                            EqualSettingsRow("Your Addresses", icon: .globe, subtitle: "Home, Work", showsDivider: false)
                        }
                    }
                    VStack(spacing: EqualSpacing.s16) {
                        EqualSectionLabel("Settings & Support", style: .group)
                        EqualSettingsGroup {
                            EqualSettingsRow("WhatsApp Updates", icon: .message, subtitle: "Assistant and app updates")
                            EqualSettingsRow("Account Data", icon: .lock, subtitle: "Manage your account")
                            EqualSettingsRow("Help Center", icon: .support, subtitle: "Your what, why and how", showsDivider: false)
                        }
                    }
                    EqualInviteCard()
                }
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.top, EqualSpacing.s32)
                .padding(.bottom, 48)
            }
        }
        .equalScreenBackground()
    }
}

/// The subscription page while a plan is active: hero, membership with price, what you get, compare.
public struct SubscriptionScreen: View {
    public init() {}
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                EqualPaywallHero(title: "Subscription Active", subtitle: Text("Assistant is handling your calls"))
                EqualMembershipCard(status: .active, detail: "Renews 16th May, 2026", price: "₹249/month")
                    .padding(.horizontal, EqualSpacing.s24).offset(y: -40)
                VStack(spacing: EqualSpacing.s48) {
                    VStack(spacing: 13) {
                        EqualSectionLabel("What you get", style: .gold)
                        EqualFeatureCard()
                    }
                    VStack(spacing: EqualSpacing.s24) {
                        EqualSectionLabel("Compare plans")
                        EqualComparePlansTable()
                    }
                    EqualButton("Upgrade to Gold Plus", variant: .gold, fullWidth: true)
                }
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.bottom, 48)
            }
        }
        .background(EqualColor.grey14.ignoresSafeArea())
        .environment(\.colorScheme, .light)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
        SettingsScreen(status: .expired)
        SubscriptionScreen()
    }
}
