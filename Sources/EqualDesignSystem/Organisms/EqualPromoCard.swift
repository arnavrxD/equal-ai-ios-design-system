import SwiftUI

/// Home banner cards: 160pt tall, radius 18, a tinted fill with a 1pt gradient stroke outside
/// (tint → white → tint), a soft shadow, a decorative circle and glow at the top-right, a 172pt
/// text column with a pill CTA, the 3D art on the right and a 20% dismiss ✕.
/// They fill the width they are given (322 in `EqualPromoCarousel`, 338–345 alone).
public struct EqualPromoCard: View {
    public enum Kind: Hashable, Sendable {
        /// "Only 1 day of Gold left": white with a 10% red wash, gold crown, glows and sparkles, gold Subscribe pill.
        case trialEnding
        /// Day-count ring + "7 days of Gold, on us" (Gold trial area).
        case goldDays(Int)
        /// Orange "Enable Permissions" with a 3D gear (notifications and contacts both missing).
        case permissions
        /// Orange "Notification access" with the gold bell.
        case notificationAccess
        /// Orange "Contact access" with the contacts book.
        case contactAccess
        /// Green "Meet Your Assistant" with the mascot and "Call me".
        case meetAssistant
        /// Blue "Call Preferences" with the muted-call bell and "Explore".
        case callPreferences
        /// Indigo "Invite a Friend" with the high-five hands and "Share now".
        case inviteFriend
        /// Red-to-gold "Your plan has expired" with the crossed crown and "Renew Gold".
        case planExpired
    }

    let kind: Kind
    let onDismiss: (() -> Void)?
    let action: () -> Void

    /// - Parameters:
    ///   - onDismiss: called by the ✕ in the top-right corner.
    ///   - action: the CTA.
    public init(_ kind: Kind, onDismiss: (() -> Void)? = nil, action: @escaping () -> Void = {}) {
        self.kind = kind
        self.onDismiss = onDismiss
        self.action = action
    }

    public var body: some View {
        if case .goldDays(let d) = kind {
            goldDaysCard(d)
        } else {
            banner(Spec(kind))
        }
    }

    // MARK: Banner

    private func banner(_ s: Spec) -> some View {
        let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)
        return ZStack(alignment: .topLeading) {
            // decorative circle 137 at (214,-40) and glow 118 at (250,85), anchored to the right edge
            Color.clear
                .overlay(alignment: .topTrailing) {
                    if let circle = s.circle { Circle().fill(circle).frame(width: 137, height: 137).offset(x: 29, y: -40) }
                }
                .overlay(alignment: .topTrailing) {
                    Circle().fill(s.glow).frame(width: 118, height: 118).blur(radius: 50).offset(x: 46, y: 85)
                }
            art(s)
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.title).font(.equal(size: 18, weight: .semibold)).tracking(s.tracking * 18)
                        .foregroundStyle(s.titleColor)
                        .lineLimit(1).minimumScaleFactor(0.85)
                    Text(s.subtitle).font(.equal(size: 12)).tracking(s.tracking * 12).lineSpacing(16 - 12 * 1.3)
                        .foregroundStyle(s.subtitleColor)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: s.subtitleWidth, alignment: .leading)
                }
                cta(s)
            }
            .frame(width: 174, alignment: .leading)
            .padding(.leading, 19)
            .padding(.top, 25)
        }
        .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160, alignment: .topLeading)
        .background { ZStack { s.base; Rectangle().fill(s.fill) } }
        .clipShape(shape)
        .overlay(alignment: .topTrailing) {
            Button { onDismiss?() } label: {
                Image(systemName: "xmark").font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.black.opacity(0.2))
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .padding(.top, 17).padding(.trailing, 14)
            .accessibilityLabel("Dismiss")
        }
        .overlay(RoundedRectangle(cornerRadius: 18.5, style: .continuous).stroke(s.stroke, lineWidth: 1).padding(-0.5))
        .shadow(color: .black.opacity(0.08), radius: 3.8, y: 1.9)
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder private func art(_ s: Spec) -> some View {
        Color.clear.overlay(alignment: .topTrailing) {
            ZStack(alignment: .topLeading) {
                Color.clear
                switch kind {
                case .trialEnding:
                    ZStack {
                        sparkle(10).offset(x: -36, y: -38)
                        sparkle(8).offset(x: 46, y: -42)
                        sparkle(12).offset(x: -52, y: 30)
                        sparkle(11).offset(x: 20, y: 52)
                        EqualImage.crown.image.aspectRatio(contentMode: .fit).frame(width: 127, height: 127)
                    }
                    .frame(width: 120, height: 120)
                case .planExpired:
                    EqualImage.crownGoldTilted.image.aspectRatio(contentMode: .fit).frame(width: 109, height: 109).offset(x: 4, y: 6)
                    EqualImage.crossRedCircle.image.aspectRatio(contentMode: .fit).frame(width: 40, height: 40).offset(x: 72, y: 62)
                default:
                    s.art.image.aspectRatio(contentMode: .fit)
                        .frame(width: s.artSize.width, height: s.artSize.height)
                        .offset(x: s.artOffset.x, y: s.artOffset.y)
                }
            }
            .frame(width: s.artFrame.width, height: s.artFrame.height)
            .padding(.top, s.artFrame.top)
            .padding(.trailing, s.artFrame.trailing)
            .accessibilityHidden(true)
        }
    }

    private func sparkle(_ size: CGFloat) -> some View {
        Image(systemName: "sparkle").font(.system(size: size, weight: .regular)).foregroundStyle(EqualColor.goldInk.opacity(0.4))
    }

    private func cta(_ s: Spec) -> some View {
        Button(action: action) {
            HStack(spacing: s.ctaGap) {
                if let icon = s.ctaIcon {
                    if icon == "phone.sparkle" {
                        Image(systemName: "phone")
                            .font(.system(size: 14, weight: .medium))
                            .overlay(alignment: .topTrailing) { Image(systemName: "sparkle").font(.system(size: 7, weight: .bold)).offset(x: 4, y: -3) }
                    } else {
                        Image(systemName: icon).font(.system(size: s.ctaIconSize, weight: .semibold))
                    }
                }
                Text(s.ctaTitle).font(.equal(size: s.ctaFontSize, weight: s.ctaWeight)).tracking(s.ctaFontSize == 12 && s.ctaWeight == .semibold ? -0.31 : 0)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, s.ctaPadding)
            .frame(minWidth: s.ctaMinWidth)
            .frame(height: s.ctaHeight)
            .background(Capsule().fill(s.ctaFill))
        }
        .buttonStyle(.plain)
    }

    // MARK: Gold days (Gold trial area)

    private func goldDaysCard(_ d: Int) -> some View {
        HStack(spacing: EqualSpacing.s12) {
            Text("\(d)").font(.equal(size: 26, weight: .medium)).foregroundStyle(EqualColor.goldInk)
                .frame(width: 48, height: 48).overlay(Circle().stroke(EqualColor.goldInk, lineWidth: 2.5))
            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text("\(d) days of Gold, on us").font(.equal(size: 18, weight: .semibold)).tracking(-0.47).foregroundStyle(EqualColor.grey01)
                Text("Everything is unlocked. Nothing to pay yet.").font(.equal(size: 12)).foregroundStyle(EqualColor.grey05)
            }
            Spacer(minLength: 0)
            EqualIllustration(.crown, size: 84)
        }
        .padding(.horizontal, EqualSpacing.s18)
        .padding(.vertical, EqualSpacing.s16)
        .frame(minHeight: 118)
        .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(LinearGradient(colors: [Color(equalHex: 0xFFFDF6), Color(equalHex: 0xFFF3D1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(Color(equalHex: 0xF3E3B1), lineWidth: 1))
    }
}

/// Per-kind values from the Figma cards (20365:44108, 43571, 43615, 21402:67808, 26242:22960).
private struct Spec {
    var title = "", subtitle = ""
    var titleColor = Color(equalHex: 0x111111), subtitleColor = Color(equalHex: 0x555555)
    var tracking: CGFloat = -0.026
    /// The subtitle may run past the 174pt column (Figma "Contact access").
    var subtitleWidth: CGFloat = 174
    var base = Color.clear
    var fill: AnyShapeStyle = AnyShapeStyle(Color.white)
    var stroke = LinearGradient(colors: [.white], startPoint: .topLeading, endPoint: .bottomTrailing)
    var circle: Color?
    var glow = Color.clear
    var art = EqualImage.gear
    var artSize = CGSize(width: 120, height: 120)
    var artOffset = CGPoint.zero
    var artFrame: (width: CGFloat, height: CGFloat, top: CGFloat, trailing: CGFloat) = (120, 120, 20, 8)
    var ctaTitle = "", ctaIcon: String?
    var ctaIconSize: CGFloat = 16
    var ctaFill = Color(equalHex: 0xE06500)
    var ctaFontSize: CGFloat = 12, ctaWeight = Font.Weight.semibold
    var ctaHeight: CGFloat = 32, ctaPadding: CGFloat = 18, ctaGap: CGFloat = 8, ctaMinWidth: CGFloat = 0

    init(_ kind: EqualPromoCard.Kind) {
        switch kind {
        case .permissions, .notificationAccess, .contactAccess:
            let orange = Color(equalHex: 0xE06500)
            fill = AnyShapeStyle(orange.opacity(0.08))
            stroke = Self.edge(orange, orange)
            circle = orange.opacity(0.28)
            glow = Color(equalHex: 0xFF6B00, alpha: 0.6)
            ctaTitle = "Open settings"; ctaIcon = "gearshape"
            switch kind {
            case .notificationAccess:
                title = "Notification access"; subtitle = "Allow notifications access to avoid missing updates"
                art = .bell; artSize = CGSize(width: 70, height: 76); artOffset = CGPoint(x: 24, y: 44)
            case .contactAccess:
                title = "Contact access"; subtitle = "Without contact access, assistant can’t manage your calls"
                art = .contactsBook; artSize = CGSize(width: 96, height: 112); artOffset = CGPoint(x: 10, y: 8)
                subtitleWidth = 190
            default:
                title = "Enable Permissions"; subtitle = "Allow notifications and contacts for real-time call recognition"
                art = .gear; artSize = CGSize(width: 100, height: 104); artOffset = CGPoint(x: 10, y: 6)
            }
        case .meetAssistant:
            let green = EqualColor.brandGreen
            title = "Meet Your Assistant"; subtitle = "Get to know your assistant better."
            titleColor = .black; subtitleColor = .black; tracking = -0.02
            fill = AnyShapeStyle(Color(equalHex: 0xA4FFC2, alpha: 0.16))
            stroke = Self.edge(green, Color(equalHex: 0x89B136))
            circle = green.opacity(0.28)
            glow = green.opacity(0.4)
            art = .mascotPhoneVoice; artSize = CGSize(width: 140, height: 108); artOffset = CGPoint(x: 4, y: 18)
            artFrame = (146, 146, 7, 5)
            ctaTitle = "Call me"; ctaIcon = "phone.sparkle"; ctaFill = green
            ctaFontSize = 13; ctaHeight = 33
        case .callPreferences, .inviteFriend:
            let isInvite = kind == .inviteFriend
            let tint = Color(equalHex: isInvite ? 0x1300A2 : 0x0067B1)
            title = isInvite ? "Invite a Friend" : "Call Preferences"
            subtitle = isInvite ? "Share Equal so your friends never miss a call that matters." : "Stop unwanted calls from interrupting you."
            titleColor = .black; subtitleColor = Color(equalHex: 0x595959); tracking = -0.02
            fill = AnyShapeStyle(tint.opacity(0.1))
            stroke = Self.edge(tint, tint)
            glow = tint.opacity(0.6)
            art = isInvite ? .inviteHands : .bellMutedIncomingCall
            artSize = CGSize(width: 116, height: 107); artOffset = CGPoint(x: 2, y: 6)
            artFrame = (120, 120, 21, 5)
            ctaTitle = isInvite ? "Share now" : "Explore"; ctaIcon = isInvite ? "square.and.arrow.up" : "sparkles"
            ctaIconSize = 12; ctaFill = tint; ctaWeight = .bold; ctaPadding = 12; ctaGap = 5
        case .trialEnding:
            let gold = EqualColor.goldInk
            title = "Only 1 day of Gold left"; subtitle = "From tomorrow, assistant stops answering calls."
            fill = AnyShapeStyle(LinearGradient(colors: [Color(equalHex: 0xFE8383, alpha: 0.1), Color(equalHex: 0xA50606, alpha: 0.1)], startPoint: .leading, endPoint: .trailing))
            stroke = Self.edge(Color(equalHex: 0xB10000), Color(equalHex: 0xB10000))
            circle = gold.opacity(0.28)
            glow = gold.opacity(0.6)
            ctaTitle = "Subscribe"; ctaIcon = nil; ctaFill = gold
        case .planExpired:
            title = "Your plan has expired"; subtitle = "Renew plan so assistant can start answering calls again"
            titleColor = .black; subtitleColor = .black; tracking = -0.02
            fill = AnyShapeStyle(Color(equalHex: 0xFF0000, alpha: 0.1))
            stroke = LinearGradient(stops: [
                .init(color: Color(equalHex: 0xDA0001), location: 0),
                .init(color: Color(equalHex: 0xFFDF9F), location: 0.55),
                .init(color: Color(equalHex: 0xFFC14E), location: 1)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            glow = Color(equalHex: 0xC09243)
            ctaTitle = "Renew Gold"; ctaIcon = nil; ctaFill = EqualColor.brandGreen; ctaWeight = .bold; ctaMinWidth = 138
        case .goldDays:
            break
        }
        if case .trialEnding = kind { base = .white }
    }

    /// `start → #FFFFFF (48%) → end`, the 1pt outside stroke.
    static func edge(_ start: Color, _ end: Color) -> LinearGradient {
        LinearGradient(stops: [.init(color: start, location: 0), .init(color: .white, location: 0.48), .init(color: end, location: 1)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct EqualPromoCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualPromoCard(.permissions); EqualPromoCard(.notificationAccess); EqualPromoCard(.contactAccess)
            EqualPromoCard(.meetAssistant); EqualPromoCard(.trialEnding); EqualPromoCard(.planExpired)
        }
        .frame(width: 322)
        .padding(24).equalScreenBackground()
    }
}
