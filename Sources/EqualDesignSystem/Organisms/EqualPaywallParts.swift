import SwiftUI

/// "What you get" carousel card (280 wide, radius 20). **Exclusive** (Gold Plus only) has a gold
/// border, cream art panel with the crown and a "30 calls a month → Unlimited" strip.
public struct EqualFeatureCard: View {
    let title: String
    let message: String
    let isExclusive: Bool
    let art: EqualImage

    public init(title: String = "Unlimited AI calls", message: String = "No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.", isExclusive: Bool = true, art: EqualImage = .crown) {
        self.title = title
        self.message = message
        self.isExclusive = isExclusive
        self.art = art
    }

    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: EqualSpacing.s12) {
                EqualIllustration(art, size: 84)
                if isExclusive {
                    HStack(spacing: EqualSpacing.s10) {
                        Text("30 calls a month").strikethrough().font(.equal(size: 13)).foregroundStyle(EqualColor.legalText)
                            .padding(.horizontal, 12).padding(.vertical, 4)
                            .background(Capsule().fill(.white)).overlay(Capsule().stroke(EqualColor.strokeMedium))
                        Text("→").foregroundStyle(EqualColor.goldInk).font(.system(size: 18))
                        Text("Unlimited").font(.equal(size: 13, weight: .semibold)).foregroundStyle(EqualColor.grey01)
                            .padding(.horizontal, 12).padding(.vertical, 4)
                            .background(Capsule().fill(Color(equalHex: 0xE3FFDA))).overlay(Capsule().stroke(Color(equalHex: 0x95DC00)))
                    }
                }
            }
            .frame(maxWidth: .infinity).frame(height: 192)
            .background(isExclusive ? AnyShapeStyle(LinearGradient(colors: [Color(equalHex: 0xFFF3C9), Color(equalHex: 0xFBF8EE)], startPoint: .top, endPoint: .bottom)) : AnyShapeStyle(EqualColor.grey14))
            .overlay(alignment: .topLeading) {
                EqualTag(isExclusive ? "Only in Gold Plus" : "Both plans", kind: isExclusive ? .exclusive : .bothPlans).padding(EqualSpacing.s12)
            }

            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text(title).font(.equal(size: 18, weight: .semibold)).foregroundStyle(EqualColor.grey01)
                Text(message).font(.equal(size: 12)).foregroundStyle(EqualColor.grey05)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EqualSpacing.s18)
        }
        .frame(width: 280)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.l))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.l).stroke(isExclusive ? EqualColor.goldBorder : EqualColor.strokeMedium, lineWidth: 1))
    }
}

/// The paywall's pinned bottom sheet: plan cards, coupon, trial note, the gold CTA whose label
/// follows the selected plan, the billing line and legal links.
public struct EqualStickyPlanSheet: View {
    public enum Plan: Sendable { case gold, goldPlus }

    @Binding var selection: Plan
    @State private var couponApplied = false
    let note: String
    let onPurchase: (Plan) -> Void

    public init(selection: Binding<Plan>, note: String = "Subscribing now ends your free trial immediately.", onPurchase: @escaping (Plan) -> Void = { _ in }) {
        self._selection = selection
        self.note = note
        self.onPurchase = onPurchase
    }

    private var price: String { selection == .goldPlus ? "₹499" : "₹249" }
    private var planName: String { selection == .goldPlus ? "Gold Plus" : "Gold" }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            HStack(spacing: EqualSpacing.s12) {
                EqualPlanCard("Gold", price: "₹249", isSelected: selection == .gold) { selection = .gold }
                EqualPlanCard("Gold Plus", price: "₹499", isSelected: selection == .goldPlus, badge: "Best value") { selection = .goldPlus }
            }
            .padding(.top, 6)
            EqualCouponRow(isApplied: $couponApplied)
            Text(note).font(.equal(size: 12.5)).foregroundStyle(EqualColor.legalText)
            EqualButton("Get \(planName) for \(price)/month", variant: .gold, fullWidth: true) { onPurchase(selection) }
            Text("Subscribe at \(price)/month. Cancel anytime in Settings.").font(.equal(size: 12)).foregroundStyle(EqualColor.legalText)
            HStack(spacing: EqualSpacing.s16) {
                Text("Recurring billing"); Text("Terms & Privacy"); Text("Restore purchases")
            }
            .font(.equal(size: 11)).foregroundStyle(EqualColor.legalLink)
            .lineLimit(1).minimumScaleFactor(0.8)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, EqualSpacing.s24)
        .padding(.bottom, EqualSpacing.s16)
        .background(Color.white)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.sheet, topTrailingRadius: EqualRadius.sheet))
        .equalShadow(.sticky)
        .environment(\.colorScheme, .light)
    }
}

/// Paywall top: gold glow with sun rays, frost close button, "Restore purchases", crown, title.
public struct EqualPaywallHero: View {
    let title: String
    let subtitle: Text
    let onClose: () -> Void
    let onRestore: () -> Void

    public init(title: String = "Choose your plan", subtitle: Text = Text("1 day").bold() + Text(" left in your free trial"), onClose: @escaping () -> Void = {}, onRestore: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.onClose = onClose
        self.onRestore = onRestore
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s4) {
            HStack {
                EqualIconButton(.close, variant: .frost, label: "Close", action: onClose)
                Spacer()
                Button(action: onRestore) {
                    Text("Restore purchases").font(.equal(size: 13, weight: .medium)).foregroundStyle(EqualColor.grey01)
                        .padding(.horizontal, EqualSpacing.s12).frame(height: 35)
                        .background(Capsule().fill(Color.white.opacity(0.6)))
                        .overlay(Capsule().stroke(Color.white.opacity(0.8)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, EqualSpacing.s16)
            EqualIllustration(.crown, size: 90).padding(.top, 2)
            Text(title).font(.equal(size: 28, weight: .bold)).tracking(-0.73).foregroundStyle(EqualColor.grey01)
            subtitle.font(.equal(size: 15)).foregroundStyle(EqualColor.grey03)
        }
        .padding(.bottom, 60)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                EqualGradient.goldHero
                SunRays().fill(Color.white.opacity(0.45)).mask(RadialGradient(colors: [.white, .clear], center: .center, startRadius: 10, endRadius: 220))
            }
            .ignoresSafeArea()
        }
    }
}

/// Sixteen soft rays behind the crown.
struct SunRays: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY * 0.9)
        let r = max(rect.width, rect.height)
        for i in 0..<16 {
            let a = Double(i) / 16 * 2 * .pi
            let w = 0.09
            p.move(to: c)
            p.addLine(to: CGPoint(x: c.x + r * cos(a - w), y: c.y + r * sin(a - w)))
            p.addLine(to: CGPoint(x: c.x + r * cos(a + w), y: c.y + r * sin(a + w)))
            p.closeSubpath()
        }
        return p
    }
}

struct EqualPaywallParts_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                EqualPaywallHero()
                ScrollView(.horizontal) { HStack(spacing: 24) { EqualFeatureCard(); EqualFeatureCard(title: "Call Screening", message: "Spam, sales or someone who actually needs you. Your assistant finds out first.", isExclusive: false, art: .mascot) }.padding() }
                EqualStickyPlanSheet(selection: .constant(.goldPlus))
            }
        }
        .equalScreenBackground()
    }
}
