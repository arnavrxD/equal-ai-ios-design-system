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
        EqualCatalogItem("EqualButton", .atoms, "Pill actions: primary, gold, goldPill, danger, link; paywall CTAs with the light streak.") {
            VStack(spacing: 12) {
                EqualButton("Next", fullWidth: true)
                EqualButton("Send OTP", fullWidth: true).disabled(true)
                EqualButton("Get Gold Plus for ₹499/month", variant: .gold, fullWidth: true)
                EqualButton("Upgrade to Gold Plus for ₹499", variant: .gold, fullWidth: true, showsStreak: false)
                EqualButton("Renew – ₹249/month", size: .cta, fullWidth: true, showsStreak: true)
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
                HStack { EqualTag("Gold", kind: .gold); EqualTag("Gold", kind: .goldLight); EqualTag("Active", kind: .status); EqualTag("Expired", kind: .expired) }
                HStack { EqualTag("Best value", kind: .bestValue); EqualTag("Only in Gold Plus", kind: .exclusive); EqualTag("New", kind: .new) }
                HStack { EqualTag("Limited time deal", kind: .deal); EqualTag("Promotional", kind: .category) }
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
        EqualCatalogItem("EqualChatListItem", .molecules, "Avatar, name, summary, time, unread, action chips; compact legacy row.") { VStack(spacing: 16) { EqualChatListItem(EqualChat.samples[0]); EqualChatListItem(EqualChat.samples[2]); EqualChatListItem(EqualChat.legacySamples[0], style: .compact); EqualChatListItem(EqualChat.legacySamples[2], style: .compact) } },
        EqualCatalogItem("EqualChatBubble", .molecules, "User and assistant messages.") {
            VStack(spacing: 6) { EqualChatBubble("Make a call", from: .user); EqualChatBubble("You’ve used all 30 AI calls on your Gold plan this month.", from: .assistant, showsAvatar: true); EqualChatBubble("Pick a plan to keep making calls with Equal.", from: .assistant, actionTitle: "See plans", actionIcon: .star) }.padding(12).background(Color(equalHex: 0xE8E8E8))
        },
        EqualCatalogItem("EqualComposer", .molecules, "Keyboard button and voice button.") { EqualComposer(text: .constant("")) },
        EqualCatalogItem("EqualQuickActionTile", .molecules, "Round and square shortcut tiles.") {
            HStack { EqualQuickActionTile("Call", glyph: .icon(.phone)); EqualQuickActionTile("Talk to Equal", glyph: .equalMark, style: .square) }
        },
        EqualCatalogItem("EqualSettingsRow", .molecules, "Settings rows in a white group.") {
            EqualSettingsGroup {
                EqualSettingsRow("Instructions", icon: .document, subtitle: "4 active instructions", badge: "New!")
                EqualSettingsRow("WhatsApp Updates", glyph: .whatsApp, subtitle: "Assistant and App Updates", showsDivider: false)
            }
        },
        EqualCatalogItem("EqualAssistantToggleCard", .molecules, "The AI Assistant master switch.") { EqualAssistantToggleCard(isOn: .constant(true)) },
        EqualCatalogItem("EqualPlanCard", .molecules, "Selectable plan card: sheet, inline (#C29200) and limit (81pt, Your plan tag).") {
            VStack(spacing: 28) {
                HStack(spacing: 13) { EqualPlanCard("Gold", price: "₹249", isSelected: false); EqualPlanCard("Gold Plus", price: "₹499", isSelected: true, badge: "Best value") }
                HStack(spacing: 13) { EqualPlanCard("Gold", price: "₹187", isSelected: false, originalPrice: "₹249", style: .inline); EqualPlanCard("Gold Plus", price: "₹374", isSelected: true, badge: "Best value", originalPrice: "₹499", style: .inline) }
                HStack(spacing: 14) { EqualPlanCard("Gold", price: "₹249", isSelected: false, currentPlanTag: "Your plan", style: .limit); EqualPlanCard("Gold Plus", price: "₹499", isSelected: true, badge: "Best value", style: .limit) }
            }
            .padding(.top, 12)
        },
        EqualCatalogItem("EqualCouponRow", .molecules, "Coupon: overhanging APPLY, inset, compact limit field, soft-paywall card, applied.") {
            VStack(spacing: 14) {
                EqualCouponRow(isApplied: .constant(false))
                EqualCouponRow(style: .inset, isApplied: .constant(false))
                EqualCouponRow(style: .compact, isApplied: .constant(false))
                EqualCouponRow(style: .card, isApplied: .constant(false))
                EqualCouponRow(isApplied: .constant(true))
            }
        },
        EqualCatalogItem("EqualFAQItem", .molecules, "Accordion FAQ: light, dark and expired styles.") { VStack(spacing: 24) { EqualFAQList(); EqualFAQList(style: .dark) } },
        EqualCatalogItem("EqualStatRow", .molecules, "Metric row on the dark recap.") {
            VStack(spacing: 0) { EqualStatRow("Calls handled", value: "18", icon: .phoneOutline); EqualStatRow("Spam and sales stopped", value: "7", icon: .shield) }
                .padding().background(Color(equalHex: 0x0B0B0A))
        },
        EqualCatalogItem("EqualPushBanner", .molecules, "iOS notification banner.") { EqualPushBanner("Only 1 day left", message: "Your trial ends tomorrow.") },
        EqualCatalogItem("EqualGenderCard", .molecules, "Gender picker card.") { HStack { EqualGenderCard(.male, isSelected: true); EqualGenderCard(.female, isSelected: false) } },
        EqualCatalogItem("EqualAvailabilityPill", .molecules, "Available / Busy header pill: glass 36 / 31, plain white.") { VStack(spacing: 12) { EqualAvailabilityPill(); EqualAvailabilityPill(size: .compact); EqualAvailabilityPill(style: .plain) } },
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
        EqualCatalogItem("EqualAppHeader", .organisms, "Logo, plan badge and availability / trial / avatar.") { VStack { EqualAppHeader(plan: "Gold"); EqualAppHeader(badge: .trialEnded); EqualAppHeader(plan: "Gold Plus", trailing: .available(.regular, .plain)); EqualAppHeader(plan: "Gold", trailing: .trial("1 Day Left")); EqualAppHeader(trailing: .avatar) }.padding(.horizontal, -24) },
        EqualCatalogItem("EqualTabBar", .organisms, "Chats / You capsule and the Equal FAB.") { EqualTabBar(selection: .constant(.chats), unread: 2) },
        EqualCatalogItem("EqualChatList", .organisms, "The home conversation list.") { EqualChatList() },
        EqualCatalogItem("EqualSheet", .organisms, "Greeting, shortcuts, suggestions and composer.") { EqualSheet().padding(.horizontal, -24) },
        EqualCatalogItem("EqualPermissionSheet", .organisms, "System permission ask: walkthrough and home presets.") { VStack(spacing: 16) { EqualPermissionSheet(); EqualPermissionSheet(.allowAccess) }.padding(.horizontal, -24) },
        EqualCatalogItem("EqualPromoCard", .organisms, "Home banners: permissions, assistant, call preferences, invite, trial ending, plan expired.") { VStack(spacing: 16) { EqualPromoCard(.permissions); EqualPromoCard(.notificationAccess); EqualPromoCard(.contactAccess); EqualPromoCard(.meetAssistant); EqualPromoCard(.callPreferences); EqualPromoCard(.inviteFriend); EqualPromoCard(.trialEnding); EqualPromoCard(.planExpired); EqualPromoCard(.goldDays(7)) } },
        EqualCatalogItem("EqualRecapCard", .organisms, "Free-week stats with replay, rings and glow.") { EqualRecapCard() },
        EqualCatalogItem("EqualMembershipCard", .organisms, "Equal GOLD active / trial / expired, and the subscription-page price variant.") { VStack(spacing: 12) { EqualMembershipCard(status: .active); EqualMembershipCard(status: .trial); EqualMembershipCard(status: .expired); EqualMembershipCard(status: .active, detail: "Renews 16th May, 2026", price: "₹ 249/month") } },
        EqualCatalogItem("EqualProfileHeader", .organisms, "Settings profile header: gold, trial (back row) and expired (mint).") { VStack(spacing: 12) { EqualProfileHeader(); EqualProfileHeader(isExpired: true, onBack: {}) }.padding(.horizontal, -24) },
        EqualCatalogItem("EqualComparePlansTable", .organisms, "Gold vs Gold Plus; highlight follows the selected plan; standard and dark checks.") {
            VStack(spacing: 16) { EqualComparePlansTable(); EqualComparePlansTable(selected: .gold, style: .dark) }
        },
        EqualCatalogItem("EqualFeatureCard", .organisms, "What-you-get card: exclusive, standard, trial and full-bleed hero.") {
            VStack(alignment: .leading, spacing: 20) {
                EqualFeatureCard()
                EqualFeatureCard(EqualFeatureCard.Content.paywall[1]).frame(width: 303)
                EqualFeatureCard(EqualFeatureCard.Content.paywall[3], style: .trial).frame(width: 303)
                EqualFeatureCard(EqualFeatureCard.Content.paywall[1], style: .hero).frame(width: 345).clipped()
            }
        },
        EqualCatalogItem("EqualStickyPlanSheet", .organisms, "Plans, coupon and the CTA that follows the plan: full, CTA-only and limit.") {
            VStack(spacing: 20) {
                EqualStickyPlanSheet(selection: .constant(.goldPlus))
                EqualStickyPlanSheet(selection: .constant(.gold), couponApplied: .constant(false), layout: .ctaOnly)
                EqualStickyPlanSheet(selection: .constant(.goldPlus), couponApplied: .constant(false), flow: .goldLimit)
            }
            .padding(.horizontal, -24)
        },
        EqualCatalogItem("EqualPaywallHero", .organisms, "Gold hero shapes A–E, rays, crown, top bar, limit pre-title.") {
            VStack(spacing: 8) {
                EqualPaywallHero()
                EqualPaywallHero(shape: .compactArc)
                EqualPaywallHero(shape: .shallowArc, showsTopBar: false)
                EqualPaywallHero(shape: .roundedBottom(28))
                EqualPaywallHero(shape: .roundedBottom(48))
                EqualPaywallHero(title: "Now go unlimited", preTitle: "Equal made 30 calls for you", shape: .roundedBottom(48), tint: .sunrise)
                EqualPaywallHero(title: "Make it yours", preTitle: "Trial over. Liked having an assistant?", shape: .circle, tint: .warm)
            }
            .padding(.horizontal, -24)
        },
        EqualCatalogItem("EqualValueRecapStory", .organisms, "Dark time-saved story.") { EqualValueRecapStory().frame(height: 720).padding(.horizontal, -24) },
        EqualCatalogItem("EqualAppStoreSheet", .organisms, "iOS purchase confirmation mock in DM Sans, per flow.") {
            VStack(spacing: 16) { EqualAppStoreSheet(); EqualAppStoreSheet(flow: .planExpired, plan: .gold) }.padding(.horizontal, -16)
        },
        EqualCatalogItem("EqualPaymentProcessing", .organisms, "Payment wait screen body: Processing payment / Activating Equal Gold layouts.") { EqualPaymentProcessing(step: 1).frame(height: 760) },
        EqualCatalogItem("EqualSuccessState", .organisms, "Upgraded, welcome back and trial started, with glow, star outline and check.") {
            VStack(spacing: 140) { EqualSuccessState(.upgraded("Gold Plus")); EqualSuccessState(.welcomeBack()); EqualSuccessState(.trialStarted(days: 7)) }
                .padding(.vertical, 100).frame(maxWidth: .infinity).clipped()
        },
        EqualCatalogItem("EqualInviteCard", .organisms, "Invite a Friend.") { EqualInviteCard() },
        EqualCatalogItem("EqualLiveCallCard", .organisms, "Assistant on a live call, with Takeover.") { EqualLiveCallCard() },
        EqualCatalogItem("EqualSocialProofCard", .organisms, "Splash stats: users, rating, calls handled.") { EqualSocialProofCard().padding(.vertical, 24).frame(maxWidth: .infinity).background(EqualColor.brandGreen) },
        EqualCatalogItem("EqualWelcomeIntro", .organisms, "Welcome break with the typed greeting.") { EqualWelcomeIntro().frame(height: 760) },
        EqualCatalogItem("EqualIntroSlide", .organisms, "Walkthrough slide scaffold.") { EqualIntroSlide(isMuted: .constant(false)) { EqualLiveCallCard() }.frame(height: 800) },

        // Screens
        EqualCatalogItem("Splash", .screens, "Green splash.") { SplashScreen() },
        EqualCatalogItem("Splash · social proof", .screens, "Splash keyframe with stats and Made in India.") { SplashSocialProofScreen() },
        EqualCatalogItem("Phone number", .screens, "Signup step 1, number entered.") { PhoneNumberScreen(phone: "8172033604") },
        EqualCatalogItem("OTP", .screens, "Signup step 2: code sent, countdown.") { OTPScreen() },
        EqualCatalogItem("OTP · error", .screens, "Incorrect code.") { OTPScreen(code: "194226", phase: .error) },
        EqualCatalogItem("Name & gender", .screens, "Signup step 3, name and gender picked.") { NameGenderScreen(name: "Keshav", gender: .male) },
        EqualCatalogItem("Welcome", .screens, "Welcome break after signup.") { WelcomeScreen() },
        EqualCatalogItem("Intro · screening", .screens, "Walkthrough: unknown callers are screened.") { IntroScreeningScreen() },
        EqualCatalogItem("Permission", .screens, "Notification permission sheet.") { PermissionScreen() },
        EqualCatalogItem("Home", .screens, "Trial ending, chat list, tab bar.") { HomeScreen() },
        EqualCatalogItem("Home · empty", .screens, "Gold days card and empty state.") { HomeScreen(plan: nil, promo: .goldDays(7), chats: []) },
        EqualCatalogItem("Equal chat · limit", .screens, "Gold limit reached in the thread.") { EqualChatScreen() },
        EqualCatalogItem("Value recap", .screens, "Last-day story.") { ValueRecapScreen(startProgress: 0.45) },
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
