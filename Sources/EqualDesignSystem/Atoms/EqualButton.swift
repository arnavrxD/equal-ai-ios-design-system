import SwiftUI

/// Pill-shaped action. **primary** green (onboarding and permission CTAs), **gold** dark-to-gold
/// gradient (paywall purchase CTAs), **goldPill** (small gold CTA on trial cards), **danger**
/// and **link** (secondary text action under a primary).
///
/// Paywall CTAs (`gold` at any large size, or `primary` at `.cta`) use the Figma purchase-button
/// spec: 52pt, SemiBold 16 label, 32pt side padding and the soft light streak (16×72 white 52%,
/// blur 18, 55pt in). Pass `showsStreak` to force the streak on or off (the limit paywalls have none).
public struct EqualButton: View {
    public enum Variant: Sendable { case primary, gold, goldPill, danger, link }
    public enum Size: Sendable {
        /// 52pt, full-width CTAs.
        case large
        /// 36pt.
        case medium
        /// 32pt.
        case small
        /// 52pt paywall CTA: SemiBold 16 label, 32pt side padding (green "Renew" and gold purchase buttons).
        case cta
        var height: CGFloat { switch self { case .large, .cta: 52; case .medium: 36; case .small: 32 } }
        var font: Font {
            switch self {
            case .large: .equal(size: 18, weight: .semibold)
            case .cta: .equal(size: 16, weight: .semibold)
            case .medium: .equal(size: 12, weight: .bold)
            case .small: .equal(size: 12, weight: .semibold)
            }
        }
    }

    let title: String
    let variant: Variant
    let size: Size
    let icon: EqualIcon?
    let fullWidth: Bool
    let trailingIcon: Bool
    let isLoading: Bool
    let showsStreak: Bool?
    let action: () -> Void
    @Environment(\.isEnabled) private var envEnabled
    private var isEnabled: Bool { envEnabled && !isLoading }

    /// - Parameters:
    ///   - trailingIcon: puts `icon` after the title ("Let’s go ›").
    ///   - isLoading: disabled colours plus a spinner ("Verifying"); taps are ignored.
    ///   - showsStreak: the light streak across paywall CTAs. `nil` = on for `gold`, off otherwise.
    public init(_ title: String, variant: Variant = .primary, size: Size = .large, icon: EqualIcon? = nil, trailingIcon: Bool = false, fullWidth: Bool = false, isLoading: Bool = false, showsStreak: Bool? = nil, action: @escaping () -> Void = {}) {
        self.title = title
        self.variant = variant
        self.size = size
        self.icon = icon
        self.trailingIcon = trailingIcon
        self.fullWidth = fullWidth
        self.isLoading = isLoading
        self.showsStreak = showsStreak
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s8) {
                if isLoading {
                    ProgressView().controlSize(.small).tint(EqualColor.textOnActionDisabled)
                } else if let icon, !trailingIcon {
                    EqualIconView(icon, size: size == .large ? 18 : 12, weight: .semibold)
                }
                Text(title).font(labelFont).tracking(-0.026 * 16)
                if let icon, trailingIcon, !isLoading { EqualIconView(icon, size: size == .large ? 16 : 12, weight: .bold) }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, isCTA ? EqualSpacing.s32 : (size == .small ? EqualSpacing.s18 : EqualSpacing.s16))
            .frame(height: variant == .link ? nil : size.height)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(Capsule())
            .overlay(alignment: .leading) {
                if streak && isEnabled {
                    // the soft light streak across the CTA: 16×72 white 52%, Figma blur 18, 55pt in
                    Rectangle().fill(.white.opacity(0.52)).frame(width: 16, height: 72).blur(radius: 12).offset(x: 55).allowsHitTesting(false)
                }
            }
            .clipShape(Capsule())
            .underline(variant == .link)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }

    /// Gold purchase buttons and `.cta` buttons follow the paywall CTA spec.
    private var isCTA: Bool { size == .cta || (variant == .gold && size == .large) }
    private var labelFont: Font { isCTA ? Size.cta.font : size.font }
    private var streak: Bool { showsStreak ?? (variant == .gold && size != .small) }

    private var foreground: Color {
        guard isEnabled else { return EqualColor.textOnActionDisabled }
        switch variant {
        case .primary: return EqualColor.textOnAction
        case .gold, .goldPill, .danger: return .white
        case .link: return EqualColor.textPrimary
        }
    }

    @ViewBuilder private var background: some View {
        if !isEnabled && variant != .link {
            EqualColor.buttonDisabled
        } else {
            switch variant {
            case .primary: EqualColor.buttonPrimary
            case .gold: ZStack { Color.black; EqualGradient.ctaGold }
            case .goldPill: EqualColor.goldInk
            case .danger: EqualColor.buttonDanger
            case .link: Color.clear
            }
        }
    }
}

struct EqualButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            EqualButton("Next", fullWidth: true)
            EqualButton("Send OTP", fullWidth: true).disabled(true)
            EqualButton("Get Gold Plus for ₹499/month", variant: .gold, fullWidth: true)
            EqualButton("Upgrade to Gold Plus for ₹499", variant: .gold, fullWidth: true, showsStreak: false)
            EqualButton("Renew – ₹249/month", size: .cta, fullWidth: true, showsStreak: true)
            EqualButton("Verifying", fullWidth: true, isLoading: true)
            EqualButton("Let’s go", icon: .chevronRight, trailingIcon: true, fullWidth: true)
            HStack {
                EqualButton("Subscribe", variant: .goldPill, size: .small)
                EqualButton("Share now", size: .medium, icon: .share)
                EqualButton("Continue anyway", variant: .link)
            }
        }
        .padding(24)
        .equalScreenBackground()
    }
}
