import SwiftUI

/// Settings: profile header with the avatar badge, the Equal GOLD membership card, the assistant
/// switch and rows, About You (noticing card + personalisation rows), Settings & Support and the
/// invite card.
///
/// Figma 26242:89397 (active), 26242:90563 (free trial, "←  Settings" row) and 26242:91729
/// (plan expired: mint header, green avatar circle, Expired card with Renew). The header runs
/// under the status bar, so the scroll view ignores the top safe area.
public struct SettingsScreen: View {
    let status: EqualMembershipCard.Status
    let onBack: (() -> Void)?
    let onMembership: () -> Void
    let onRenew: () -> Void
    @State private var assistantOn = true

    /// - Parameters:
    ///   - status: active, trial or expired plan.
    ///   - onBack: action of the "←  Settings" row (shown for trial and expired).
    ///   - onMembership: tap on the membership card (opens the subscription page or the recap).
    ///   - onRenew: the expired card's Renew pill.
    public init(status: EqualMembershipCard.Status = .active, onBack: (() -> Void)? = nil, onMembership: @escaping () -> Void = {}, onRenew: @escaping () -> Void = {}) {
        self.status = status
        self.onBack = onBack
        self.onMembership = onMembership
        self.onRenew = onRenew
    }

    public var body: some View {
        ScrollView {
            SettingsPageContent(status: status, assistantOn: $assistantOn, onBack: onBack, onMembership: onMembership, onRenew: onRenew)
        }
        .ignoresSafeArea(edges: .top)
        .equalScreenBackground()
    }
}

/// The scrollable body of `SettingsScreen` (separate so the catalog can render it without a scroll view).
struct SettingsPageContent: View {
    let status: EqualMembershipCard.Status
    @Binding var assistantOn: Bool
    let onBack: (() -> Void)?
    let onMembership: () -> Void
    let onRenew: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                EqualProfileHeader(isExpired: status == .expired, onBack: status == .active ? nil : (onBack ?? {}))
                EqualMembershipCard(status: status, onRenew: onRenew)
                    .contentShape(RoundedRectangle(cornerRadius: EqualRadius.goldCard))
                    .onTapGesture(perform: onMembership)
                    .accessibilityAddTraits(.isButton)
                    .padding(.horizontal, EqualSpacing.s24)
                    .padding(.top, 200)
            }
            VStack(spacing: EqualSpacing.s32) {
                section("Your Assistant") {
                    VStack(spacing: EqualSpacing.s12) {
                        EqualAssistantToggleCard(isOn: $assistantOn)
                        EqualSettingsGroup {
                            EqualSettingsRow("Instructions", icon: .document, subtitle: "4 active instructions", badge: "New!")
                            EqualSettingsRow("Call Handling", icon: .phoneOutline, subtitle: "Saved contacts + Unknown numbers")
                            EqualSettingsRow("Silent Mode", icon: .bellSlash, subtitle: "Mute all promotional calls")
                            EqualSettingsRow("Voice & Language", glyph: .symbol("mic"), subtitle: "Calm & Friendly · Hindi, English, Telugu", showsDivider: false)
                        }
                    }
                }
                section("About You") {
                    VStack(spacing: EqualSpacing.s12) {
                        EqualNoticingCard()
                        EqualSettingsGroup {
                            EqualSettingsRow("AI Personalisation", glyph: .symbol("sparkles"), subtitle: "See how Equal personalises your calls", badge: "New!")
                            EqualSettingsRow("Your Addresses", glyph: .symbol("mappin.and.ellipse"), subtitle: "Home, Work +2 others", badge: "New!", showsDivider: false)
                        }
                    }
                }
                section("Settings & Support") {
                    EqualSettingsGroup {
                        EqualSettingsRow("WhatsApp Updates", glyph: .whatsApp, subtitle: "Assistant and App Updates")
                        EqualSettingsRow("Account & Data", glyph: .symbol("shield", secondary: true), subtitle: "Your account and data management")
                        EqualSettingsRow("Help Center", glyph: .symbol("questionmark.circle", secondary: true), subtitle: "Your What, Why and How", showsDivider: false)
                    }
                }
                EqualInviteCard()
            }
            .padding(.horizontal, EqualSpacing.s24)
            // Sections start at y 309 (active, trial) or 379 (expired) in Figma.
            .padding(.top, status == .expired ? 27 : 20)
            .padding(.bottom, EqualSpacing.s48)
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            EqualSectionLabel(title, style: .group)
            content()
        }
    }
}

/// The subscription page behind the Settings membership card: gold hero with rays and crown,
/// the membership card with its price, What you get, Compare plans and FAQ, and a pinned bottom
/// bar.
///
/// Figma 26242:86572 (active: "Upgrade to Gold Plus" bar with billing and legal lines) and
/// 26242:95818 (expired: `EqualRenewSheet`).
public struct SubscriptionScreen: View {
    public enum Status: Sendable { case active, expired }

    let status: Status
    let onUpgrade: () -> Void
    let onRenew: () -> Void
    let onExplorePlans: () -> Void
    let onRestore: () -> Void

    public init(status: Status = .active, onUpgrade: @escaping () -> Void = {}, onRenew: @escaping () -> Void = {}, onExplorePlans: @escaping () -> Void = {}, onRestore: @escaping () -> Void = {}) {
        self.status = status
        self.onUpgrade = onUpgrade
        self.onRenew = onRenew
        self.onExplorePlans = onExplorePlans
        self.onRestore = onRestore
    }

    public var body: some View {
        ScrollView {
            SubscriptionPageContent(status: status, scrolls: true)
        }
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
        .background(Color.white.ignoresSafeArea())
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder var bottomBar: some View {
        switch status {
        case .active: SubscriptionUpgradeBar(onUpgrade: onUpgrade, onRestore: onRestore)
        case .expired: EqualRenewSheet(onRenew: onRenew, onExplore: onExplorePlans)
        }
    }
}

/// The scrollable body of `SubscriptionScreen`. `scrolls: false` lays the carousel out without a
/// scroll view (ImageRenderer cannot draw scroll views).
struct SubscriptionPageContent: View {
    let status: SubscriptionScreen.Status
    let scrolls: Bool

    struct Feature { let title: String; let message: String; let exclusive: Bool; let art: EqualImage }
    static let features: [Feature] = [
        Feature(title: "Unlimited AI calls", message: "No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.", exclusive: true, art: .crown),
        Feature(title: "Call Screening", message: "Spam, sales, or someone who actually needs you. Your assistant finds out first.", exclusive: false, art: .mascotPhoneVoice),
        Feature(title: "Handles calls from your contacts", message: "In a meeting? It takes the message and tells you what mattered.", exclusive: false, art: .contactsBook),
        Feature(title: "Speaks your language", message: "Choose from 10+ languages and 4 voices to make your assistant feel more like you.", exclusive: false, art: .letterAHindi),
        Feature(title: "Instructions", message: "Tell Equal what to do or say. It does exactly that, for any call that you want.", exclusive: false, art: .mascotReadingBook),
        Feature(title: "Saved addresses", message: "Delivery and cab drivers get it without calling you multiple times to confirm.", exclusive: false, art: .mascotMap),
        Feature(title: "Post-call Actions", message: "Take relevant actions based on your calls. Set reminder, reply on WhatsApp, mute, and more.", exclusive: false, art: .whatsappLogoGreen)
    ]

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                SubscriptionHero(status: status)
                EqualMembershipCard(status: status == .active ? .active : .expired,
                                    detail: status == .active ? "Renews 16th May, 2026" : "Expired on 16th May, 2026",
                                    price: "₹ 249/month")
                    .frame(width: 344)
                    .padding(.top, 226)
            }
            VStack(spacing: EqualSpacing.s48) {
                VStack(spacing: 0) {
                    EqualSectionLabel("What you get", style: .gold).frame(width: 328).frame(height: 18)
                    carousel.padding(.top, 24)
                    EqualPageDots(count: Self.features.count, active: 0).padding(.top, 13)
                }
                VStack(spacing: EqualSpacing.s24) {
                    EqualSectionLabel("Compare plans")
                    EqualComparePlansTable()
                }
                .padding(.horizontal, EqualSpacing.s24)
                VStack(spacing: EqualSpacing.s24) {
                    EqualSectionLabel("Frequently Asked Questions", style: .gold).frame(width: 328)
                    EqualFAQList()
                }
                .padding(.horizontal, EqualSpacing.s24)
            }
            .padding(.top, 28)
            .padding(.bottom, EqualSpacing.s32)
        }
    }

    @ViewBuilder private var carousel: some View {
        let row = HStack(alignment: .top, spacing: 28) {
            ForEach(Array(Self.features.enumerated()), id: \.offset) { _, f in
                EqualFeatureCard(title: f.title, message: f.message, isExclusive: f.exclusive, art: f.art)
            }
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.vertical, 4)
        if scrolls {
            ScrollView(.horizontal, showsIndicators: false) { row }
        } else {
            row.fixedSize().frame(width: 393, alignment: .leading).clipped()
        }
    }
}

/// Subscription hero (393×294): 547pt circle (white → #FFC927), eight soft rays, the crown and
/// the status title.
private struct SubscriptionHero: View {
    let status: SubscriptionScreen.Status

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 294)
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    Circle()
                        .fill(LinearGradient(stops: [
                            .init(color: .white, location: 172 / 547),
                            .init(color: Color(equalHex: 0xFFFEFC), location: 172 / 547),
                            .init(color: Color(equalHex: 0xFFC927), location: 1)
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: 547, height: 547)
                        .offset(x: -77, y: -253)
                    HeroRays().frame(width: 340, height: 345.91).opacity(0.6).offset(x: 24.5, y: -53.91)
                }
            }
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    EqualIllustration(.crown, size: 95.45).padding(.top, 66.27)
                    VStack(spacing: EqualSpacing.s2) {
                        Text(status == .active ? "Subscription Active" : "Subscription Expired")
                            .font(.equal(size: 18, weight: .bold))
                            .foregroundStyle(Color.black)
                        Text(status == .active ? "Assistant is handling your calls" : "Assistant has stopped handling your calls")
                            .font(.equal(size: 12)).tracking(-0.36)
                            .foregroundStyle(Color.black.opacity(0.7))
                    }
                    .padding(.top, 172 - 66.27 - 95.45)
                }
            }
            .clipped()
    }
}

/// Eight tapered rays around the crown (Figma "Group 2085664120", 340×345.9, white 0 → 50%).
private struct HeroRays: View {
    var body: some View {
        Canvas { ctx, size in
            let sx = size.width / 340, sy = size.height / 345.913
            func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * sx, y: y * sy) }
            // Each ray: four corners (outer pair first) and the gradient's outer → inner points.
            let rays: [([CGPoint], CGPoint, CGPoint)] = [
                ([p(141.913, 0), p(195.722, 0), p(181.235, 136.591), p(159.061, 136.591)], p(168.8, 0), p(168.8, 136.6)),
                ([p(340, 145.461), p(340, 199.27), p(203.409, 184.783), p(203.409, 162.609)], p(340, 172.4), p(203.4, 172.4)),
                ([p(279.945, 40.209), p(314.677, 81.308), p(200.998, 158.407), p(186.686, 141.47)], p(297.3, 60.8), p(193.0, 148.9)),
                ([p(279.945, 306.063), p(314.677, 264.964), p(200.998, 187.865), p(186.686, 204.801)], p(297.3, 285.5), p(193.0, 197.3)),
                ([p(61.341, 40.209), p(26.61, 81.308), p(140.288, 158.407), p(154.601, 141.47)], p(44.0, 60.8), p(148.3, 148.9)),
                ([p(61.341, 306.063), p(26.61, 264.964), p(140.288, 187.865), p(154.601, 204.801)], p(44.0, 285.5), p(148.3, 197.3)),
                ([p(0, 199.27), p(0, 145.461), p(136.591, 159.948), p(136.591, 182.122)], p(0, 172.4), p(136.6, 172.4)),
                ([p(141.913, 345.913), p(195.722, 345.913), p(181.235, 209.322), p(159.061, 209.322)], p(168.8, 345.9), p(168.8, 209.3))
            ]
            for (corners, from, to) in rays {
                var path = Path()
                path.addLines(corners)
                path.closeSubpath()
                ctx.fill(path, with: .linearGradient(Gradient(colors: [.white.opacity(0), .white.opacity(0.5)]), startPoint: from, endPoint: to))
            }
        }
        .accessibilityHidden(true)
    }
}

/// Active subscription bottom bar: "Upgrade to Gold Plus", billing note and legal links
/// (Figma 26242:89391, 393×128, shadow 0,-1 blur 2 @25%).
private struct SubscriptionUpgradeBar: View {
    let onUpgrade: () -> Void
    let onRestore: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EqualGoldCapsuleCTA("Upgrade to Gold Plus", action: onUpgrade)
                .padding(.horizontal, EqualSpacing.s24)
            Text("Subscribe at ₹499/month. Cancel anytime in Settings.")
                .font(.equal(size: 12)).foregroundStyle(EqualColor.legalText)
                .frame(height: 16)
                .padding(.top, 12)
            HStack(spacing: 20) {
                Text("Recurring billing")
                Text("Terms & Privacy")
                Button("Restore purchases", action: onRestore).buttonStyle(.plain)
            }
            .font(.equal(size: 11)).foregroundStyle(EqualColor.legalLink)
            .frame(height: 14)
            .padding(.top, 4)
        }
        .padding(.top, EqualSpacing.s16)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity)
        .background {
            Color.white
                .shadow(color: .black.opacity(0.25), radius: 1, y: -1)
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
        SettingsScreen(status: .trial)
        SettingsScreen(status: .expired)
        SubscriptionScreen()
        SubscriptionScreen(status: .expired)
    }
}
