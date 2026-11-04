import SwiftUI

/// Pill-shaped action. **primary** green (onboarding and permission CTAs), **gold** dark-to-gold
/// gradient (paywall purchase CTAs), **goldPill** (small gold CTA on trial cards), **danger**
/// and **link** (secondary text action under a primary).
public struct EqualButton: View {
    public enum Variant: Sendable { case primary, gold, goldPill, danger, link }
    public enum Size: Sendable {
        /// 52pt, full-width CTAs.
        case large
        /// 36pt.
        case medium
        /// 32pt.
        case small
        var height: CGFloat { switch self { case .large: 52; case .medium: 36; case .small: 32 } }
        var font: Font {
            switch self {
            case .large: .equal(size: 18, weight: .semibold)
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
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled

    public init(_ title: String, variant: Variant = .primary, size: Size = .large, icon: EqualIcon? = nil, fullWidth: Bool = false, action: @escaping () -> Void = {}) {
        self.title = title
        self.variant = variant
        self.size = size
        self.icon = icon
        self.fullWidth = fullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s8) {
                if let icon { EqualIconView(icon, size: size == .large ? 18 : 12, weight: .semibold) }
                Text(title).font(size.font).tracking(-0.026 * 16)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, variant == .gold ? EqualSpacing.s24 : (size == .small ? EqualSpacing.s18 : EqualSpacing.s16))
            .frame(height: variant == .link ? nil : size.height)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(Capsule())
            .overlay(alignment: .leading) {
                if variant == .gold {
                    // the soft light streak across the gold CTA
                    Rectangle().fill(.white.opacity(0.5)).frame(width: 16).blur(radius: 9).rotationEffect(.degrees(20)).offset(x: 60).allowsHitTesting(false)
                }
            }
            .clipShape(Capsule())
            .underline(variant == .link)
        }
        .buttonStyle(.plain)
    }

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
