import SwiftUI

/// Atomic level of a catalog entry.
public enum EqualLevel: String, CaseIterable, Sendable {
    case foundations = "Foundations", atoms = "Atoms", molecules = "Molecules", organisms = "Organisms", screens = "Screens"
}

/// One browsable entry in the catalog.
public struct EqualCatalogItem: Identifiable {
    public let id: String
    public let level: EqualLevel
    public let summary: String
    let make: () -> AnyView

    /// The demo view for this entry.
    public var view: AnyView { make() }

    init<V: View>(_ name: String, _ level: EqualLevel, _ summary: String, @ViewBuilder _ make: @escaping () -> V) {
        self.id = name
        self.level = level
        self.summary = summary
        self.make = { AnyView(make()) }
    }
}

/// Every token, atom, molecule, organism and screen, browsable in-app.
///
/// ```swift
/// WindowGroup { EqualCatalogView() }
/// ```
public struct EqualCatalogView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                ForEach(EqualLevel.allCases, id: \.self) { level in
                    Section(level.rawValue) {
                        ForEach(EqualCatalog.items.filter { $0.level == level }) { item in
                            NavigationLink {
                                CatalogDetail(item: item)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.id).font(.equal(size: 16, weight: .semibold))
                                    Text(item.summary).font(.equal(size: 13)).foregroundStyle(.secondary).lineLimit(2)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Equal AI iOS")
        }
    }
}

private struct CatalogDetail: View {
    let item: EqualCatalogItem
    var body: some View {
        if item.level == .screens || item.level == .foundations {
            item.make()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(item.summary).font(.equal(size: 15)).foregroundStyle(EqualColor.textSecondary)
                    item.make()
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .equalScreenBackground()
            .navigationTitle(item.id)
        }
    }
}

/// The registry behind `EqualCatalogView`. Each area adds its entries in `Catalog/Entries`.
public enum EqualCatalog {
    public static var items: [EqualCatalogItem] {
        coreItems + goldTrialItems + paywallItems + paymentItems + homeItems + settingsItems
    }

    static let coreItems: [EqualCatalogItem] = [
        // Foundations
        EqualCatalogItem("Color", .foundations, "93 tokens: semantic light/dark, primitives, Gold, avatar tints.") { ColorTokensView() },
        EqualCatalogItem("Typography", .foundations, "32 styles: the iOS scale in DM Sans plus product accents.") { TypographyTokensView() },
        EqualCatalogItem("Spacing, radius, shadow", .foundations, "The layout scales.") { ShapeTokensView() },
        EqualCatalogItem("Icons & illustrations", .foundations, "SF Symbols mapping and the bundled 3D art.") { IconographyView() },

        // Atoms
        EqualCatalogItem("EqualButton", .atoms, "Pill actions: primary, gold, goldPill, danger, link.") {
            VStack(spacing: 12) {
                EqualButton("Next", fullWidth: true)
                EqualButton("Send OTP", fullWidth: true).disabled(true)
                EqualButton("Get Gold Plus for ₹499/month", variant: .gold, fullWidth: true)
                HStack { EqualButton("Subscribe", variant: .goldPill, size: .small); EqualButton("Continue anyway", variant: .link) }
            }
        },
        EqualCatalogItem("EqualIconButton", .atoms, "Circular icon buttons: solid, glass, frost, tile.") {
            HStack { EqualIconButton(.close, label: "Close"); EqualIconButton(.more, variant: .glass, label: "More"); EqualIconButton(.close, variant: .frost, label: "Close"); EqualIconButton(.keyboard, variant: .tile, label: "Keyboard") }
        },
        EqualCatalogItem("EqualChip", .atoms, "Post-call action chips, suggested and neutral.") {
            VStack(alignment: .leading) {
                HStack { EqualChip("Call back", variant: .suggested, emoji: "📞"); EqualChip("Mute", emoji: "🔕") }
                EqualChip("Amit Nanda") { EqualAvatar(.initials("AN"), size: 18) }
            }
        },
        EqualCatalogItem("EqualTag", .atoms, "GOLD badge, status, best value, exclusive, new, deal, category.") {
            VStack(alignment: .leading) {
                HStack { EqualTag("Gold", kind: .gold); EqualTag("Active", kind: .status); EqualTag("Expired", kind: .expired) }
                HStack { EqualTag("Best value", kind: .bestValue); EqualTag("Only in Gold Plus", kind: .exclusive); EqualTag("New", kind: .new) }
            }
        },
        EqualCatalogItem("EqualAvatar", .atoms, "Initials, category art or the Equal mark.") {
            HStack { EqualAvatar(.initials("AN"), isContact: true); EqualAvatar(.illustration(.categoryFinance), tint: .finance); EqualAvatar(.equal) }
        },
        EqualCatalogItem("EqualUnreadCount", .atoms, "Green unread badge and dot.") { HStack { EqualUnreadCount(1); EqualUnreadCount(12); EqualUnreadCount() } },
        EqualCatalogItem("EqualToggle", .atoms, "44×24 switch.") { ToggleDemo() },
        EqualCatalogItem("EqualPlanRadio", .atoms, "Plan selector radio.") { HStack { EqualPlanRadio(isSelected: false); EqualPlanRadio(isSelected: true) } },
        EqualCatalogItem("EqualCheckbox", .atoms, "Square checkbox with a caption.") { CheckboxDemo() },
        EqualCatalogItem("EqualCompareCheck", .atoms, "Included mark in the compare table.") { EqualCompareCheck() },
        EqualCatalogItem("EqualSectionLabel", .atoms, "Section headers: hairlines, gold, fixed gold rules, HOW TO CONFIRM, gold sentence, group.") {
            VStack(spacing: 14) {
                EqualSectionLabel("Compare plans")
                EqualSectionLabel("What you get", style: .gold)
                EqualSectionLabel("What you get", style: .goldFixed())
                EqualSectionLabel("How to confirm", style: .howToConfirm)
                EqualSectionLabel("Using UPI? Follow these steps:", style: .goldSentence)
                EqualSectionLabel("Using UPI? Follow these steps:", style: .goldSentenceRules)
                EqualSectionLabel("Your assistant", style: .group)
            }
        },
        EqualCatalogItem("EqualPageDots", .atoms, "Carousel position.") { EqualPageDots(count: 5, active: 0) },
        EqualCatalogItem("EqualProgressBar", .atoms, "3pt progress, green or gold.") { VStack { EqualProgressBar(value: 0.4); EqualProgressBar(value: 0.45, tone: .gold).padding().background(Color.black) } },
        EqualCatalogItem("EqualTextField", .atoms, "Phone and name inputs.") { TextFieldDemo() },
        EqualCatalogItem("EqualThinkingText", .atoms, "Assistant progress line with shimmer.") { EqualThinkingText() },
        EqualCatalogItem("EqualCrownLoader", .atoms, "160pt payment ring loader with the 3D crown.") { EqualCrownLoader().frame(maxWidth: .infinity).equalProcessingBackground() },
        EqualCatalogItem("EqualFieldMessage", .atoms, "Helper, countdown, resend link and error lines under a field.") {
            VStack(spacing: 12) {
                EqualFieldMessage(.helper("Your AI will call you ", emphasis: "‘Keshav’"))
                EqualFieldMessage(.countdown(seconds: 30))
                EqualFieldMessage(.link("Resend OTP"))
                EqualFieldMessage(.error("Incorrect OTP, try again"))
            }
        },
        EqualCatalogItem("EqualMadeInIndiaPill", .atoms, "Tricolour glass pill on the splash.") { EqualMadeInIndiaPill().padding(24).background(EqualColor.brandGreen) },

        // Molecules
        EqualCatalogItem("EqualSearchBar", .molecules, "Search pill plus the glass ⋯ button.") { EqualSearchBar(query: .constant("")) },
        EqualCatalogItem("EqualChatListItem", .molecules, "Avatar, name, summary, time, unread, action chips.") { VStack { EqualChatListItem(EqualChat.samples[0]); EqualChatListItem(EqualChat.samples[2]) } },
        EqualCatalogItem("EqualChatBubble", .molecules, "User and assistant messages.") {
            VStack { EqualChatBubble("Make a call", from: .user); EqualChatBubble("You’ve used all 30 AI calls on your Gold plan this month.", from: .assistant, showsAvatar: true, actionTitle: "Get more calls") }
        },
        EqualCatalogItem("EqualComposer", .molecules, "Keyboard button and voice button.") { EqualComposer(text: .constant("")) },
        EqualCatalogItem("EqualQuickActionTile", .molecules, "Round and square shortcut tiles.") {
            HStack { EqualQuickActionTile("Call", glyph: .icon(.phone)); EqualQuickActionTile("Talk to Equal", glyph: .equalMark, style: .square) }
        },
        EqualCatalogItem("EqualSettingsRow", .molecules, "Settings rows in a white group.") {
            EqualSettingsGroup {
                EqualSettingsRow("Instructions", icon: .document, subtitle: "4 active instructions", badge: "New")
                EqualSettingsRow("Silent Mode", icon: .bellSlash, subtitle: "Mute all promotional calls", showsDivider: false)
            }
        },
        EqualCatalogItem("EqualAssistantToggleCard", .molecules, "The AI Assistant master switch.") { EqualAssistantToggleCard(isOn: .constant(true)) },
        EqualCatalogItem("EqualPlanCard", .molecules, "Selectable plan card.") { HStack { EqualPlanCard("Gold", price: "₹249", isSelected: false); EqualPlanCard("Gold Plus", price: "₹499", isSelected: true, badge: "Best value") }.padding(.top, 12) },
        EqualCatalogItem("EqualCouponRow", .molecules, "Coupon with APPLY.") { EqualCouponRow(isApplied: .constant(false)) },
        EqualCatalogItem("EqualFAQItem", .molecules, "Accordion FAQ.") { EqualFAQList() },
        EqualCatalogItem("EqualStatRow", .molecules, "Metric row on the dark recap.") { VStack(spacing: 0) { EqualStatRow("Calls handled", value: "18", icon: .phoneOutline) }.padding().background(Color.black) },
        EqualCatalogItem("EqualPushBanner", .molecules, "iOS notification banner.") { EqualPushBanner("Only 1 day left", message: "Your trial ends tomorrow.") },
        EqualCatalogItem("EqualGenderCard", .molecules, "Gender picker card.") { HStack { EqualGenderCard(.male, isSelected: true); EqualGenderCard(.female, isSelected: false) } },
        EqualCatalogItem("EqualAvailabilityPill", .molecules, "Available / Busy header pill.") { EqualAvailabilityPill() },
        EqualCatalogItem("EqualSheetHeader", .molecules, "Top of the Equal action sheet.") { EqualSheetHeader() },
        EqualCatalogItem("EqualUpiStep", .molecules, "Numbered payment step, 16/21 or 18/22.") {
            VStack(spacing: 24) { EqualUpiStep(1, "Open your UPI app, via notifications or directly"); EqualUpiStep(2, "Review and approve the autopay request", size: .large) }.frame(maxWidth: .infinity)
        },
        EqualCatalogItem("EqualKeyValueRow", .molecules, "App Store label–value row.") { EqualKeyValueRow("Price", "₹499.00 per month") },
        EqualCatalogItem("EqualOTPField", .molecules, "One-time-code field: empty, filled, error.") {
            VStack(spacing: 12) { EqualOTPField(code: .constant("")); EqualOTPField(code: .constant("194226")); EqualOTPField(code: .constant("194226"), isError: true) }
        },
        EqualCatalogItem("EqualOnboardingHeader", .molecules, "Signup title block, plain or with an editable number.") {
            VStack(spacing: 24) { EqualOnboardingHeader("Enter phone number", subtitle: "Assistant will handle calls for this number"); EqualOnboardingHeader("Enter OTP sent to", editableValue: "+91-8172033604") }
        },
        EqualCatalogItem("EqualPhoneMockup", .molecules, "iPhone frame with the lock screen.") { EqualPhoneMockup(width: 220) },

        // Organisms
        EqualCatalogItem("EqualAppHeader", .organisms, "Logo, plan tag and availability / trial / avatar.") { VStack { EqualAppHeader(plan: "Gold"); EqualAppHeader(plan: "Gold", trailing: .trial("1 Day Left")) } },
        EqualCatalogItem("EqualTabBar", .organisms, "Chats / You capsule and the Equal FAB.") { EqualTabBar(selection: .constant(.chats), unread: 2) },
        EqualCatalogItem("EqualChatList", .organisms, "The home conversation list.") { EqualChatList() },
        EqualCatalogItem("EqualSheet", .organisms, "Greeting, shortcuts, suggestions and composer.") { EqualSheet() },
        EqualCatalogItem("EqualPermissionSheet", .organisms, "System permission ask.") { EqualPermissionSheet() },
        EqualCatalogItem("EqualPromoCard", .organisms, "Trial, Gold days, permissions and assistant banners.") { VStack(spacing: 12) { EqualPromoCard(.trialEnding); EqualPromoCard(.goldDays(7)); EqualPromoCard(.permissions); EqualPromoCard(.meetAssistant) } },
        EqualCatalogItem("EqualRecapCard", .organisms, "Free-week stats.") { EqualRecapCard() },
        EqualCatalogItem("EqualMembershipCard", .organisms, "Equal GOLD active / trial / expired.") { VStack(spacing: 12) { EqualMembershipCard(status: .active); EqualMembershipCard(status: .trial); EqualMembershipCard(status: .expired) } },
        EqualCatalogItem("EqualProfileHeader", .organisms, "Settings profile header.") { EqualProfileHeader() },
        EqualCatalogItem("EqualComparePlansTable", .organisms, "Gold vs Gold Plus.") { EqualComparePlansTable() },
        EqualCatalogItem("EqualFeatureCard", .organisms, "What-you-get carousel card.") { EqualFeatureCard() },
        EqualCatalogItem("EqualStickyPlanSheet", .organisms, "Plans, coupon and the gold CTA.") { EqualStickyPlanSheet(selection: .constant(.goldPlus)) },
        EqualCatalogItem("EqualPaywallHero", .organisms, "Crown, rays and title.") { EqualPaywallHero() },
        EqualCatalogItem("EqualValueRecapStory", .organisms, "Dark time-saved story.") { EqualValueRecapStory().frame(height: 720) },
        EqualCatalogItem("EqualAppStoreSheet", .organisms, "iOS purchase confirmation mock.") { EqualAppStoreSheet() },
        EqualCatalogItem("EqualPaymentProcessing", .organisms, "Payment wait screen body: Processing payment / Activating Equal Gold layouts.") { EqualPaymentProcessing(step: 1).frame(height: 760) },
        EqualCatalogItem("EqualSuccessState", .organisms, "Upgrade and trial-start success.") { EqualSuccessState(.upgraded("Gold Plus")) },
        EqualCatalogItem("EqualInviteCard", .organisms, "Invite a Friend.") { EqualInviteCard() },
        EqualCatalogItem("EqualLiveCallCard", .organisms, "Assistant on a live call, with Takeover.") { EqualLiveCallCard() },
        EqualCatalogItem("EqualSocialProofCard", .organisms, "Splash stats: users, rating, calls handled.") { EqualSocialProofCard().padding(.vertical, 24).frame(maxWidth: .infinity).background(EqualColor.brandGreen) },
        EqualCatalogItem("EqualWelcomeIntro", .organisms, "Welcome break with the typed greeting.") { EqualWelcomeIntro().frame(height: 760) },
        EqualCatalogItem("EqualIntroSlide", .organisms, "Walkthrough slide scaffold.") { EqualIntroSlide(isMuted: .constant(false)) { EqualLiveCallCard() }.frame(height: 800) },

        // Screens
        EqualCatalogItem("Splash", .screens, "Green splash.") { SplashScreen() },
        EqualCatalogItem("Splash · social proof", .screens, "Splash keyframe with stats and Made in India.") { SplashSocialProofScreen() },
        EqualCatalogItem("Phone number", .screens, "Signup step 1.") { PhoneNumberScreen() },
        EqualCatalogItem("OTP", .screens, "Signup step 2: code sent, countdown.") { OTPScreen() },
        EqualCatalogItem("OTP · error", .screens, "Incorrect code.") { OTPScreen(code: "194226", phase: .error) },
        EqualCatalogItem("Name & gender", .screens, "Signup step 3.") { NameGenderScreen() },
        EqualCatalogItem("Welcome", .screens, "Welcome break after signup.") { WelcomeScreen() },
        EqualCatalogItem("Intro · screening", .screens, "Walkthrough: unknown callers are screened.") { IntroScreeningScreen() },
        EqualCatalogItem("Permission", .screens, "Notification permission sheet.") { PermissionScreen() },
        EqualCatalogItem("Home", .screens, "Trial ending, chat list, tab bar.") { HomeScreen() },
        EqualCatalogItem("Home · empty", .screens, "Gold days card and empty state.") { HomeScreen(plan: nil, promo: .goldDays(7), chats: []) },
        EqualCatalogItem("Equal chat · limit", .screens, "Gold limit reached in the thread.") { EqualChatScreen() },
        EqualCatalogItem("Value recap", .screens, "Last-day story.") { ValueRecapScreen() },
        EqualCatalogItem("Paywall", .screens, "Choose your plan.") { PaywallScreen() },
        EqualCatalogItem("App Store confirmation", .screens, "Purchase sheet over the paywall.") { AppStoreConfirmationScreen() },
        EqualCatalogItem("Payment processing", .screens, "UPI autopay steps.") { PaymentProcessingScreen() },
        EqualCatalogItem("Purchase success", .screens, "You’re on Gold Plus.") { PurchaseSuccessScreen() },
        EqualCatalogItem("Settings", .screens, "Active plan.") { SettingsScreen() },
        EqualCatalogItem("Settings · expired", .screens, "Plan expired with Renew.") { SettingsScreen(status: .expired) },
        EqualCatalogItem("Subscription", .screens, "Subscription active page.") { SubscriptionScreen() }
    ]
}

private struct ToggleDemo: View { @State var on = true; var body: some View { EqualToggle("Demo", isOn: $on) } }
private struct CheckboxDemo: View { @State var on = true; var body: some View { EqualCheckbox("I want to receive updates on Whatsapp", isOn: $on) } }
private struct TextFieldDemo: View {
    @State var phone = ""
    @State var name = "Keshav"
    var body: some View {
        VStack { EqualTextField("Enter mobile number", text: $phone, kind: .phone); EqualTextField("Name", text: $name, kind: .name, helper: "Your AI will call you ‘\(name)’") }
    }
}

struct EqualCatalogView_Previews: PreviewProvider { static var previews: some View { EqualCatalogView() } }
