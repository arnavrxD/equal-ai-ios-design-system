import SwiftUI

/// "How to confirm with Apple Pay" hint on the payment wait screen: a 40pt `#674F16` tile with the
/// Face ID glyph, then "**Apple Pay** · Double-click the side button, then Face ID. You stay right here."
///
/// 16pt padding, 18pt gap, radius 16; 332×72 at the screen's 332pt width. Text DM Sans 13/18, -2.6%.
public struct EqualApplePayHintCard: View {
    /// Card fill.
    public enum Style: Sendable {
        /// White, no shadow (list layout).
        case plain
        /// White with a 4pt black 16% glow (default).
        case raised
        /// White at 20% with the same glow, over the gold wash.
        case translucent
    }

    let title: String
    let message: String
    let icon: EqualIcon
    let style: Style

    public init(
        title: String = "Apple Pay",
        message: String = "Double-click the side button, then Face ID. You stay right here.",
        icon: EqualIcon = .faceID,
        style: Style = .raised
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.style = style
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s18) {
            EqualIconView(icon, size: 23.33, weight: .regular)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color(equalHex: 0x674F16), in: RoundedRectangle(cornerRadius: EqualRadius.s))
            (Text(title).font(.equal(size: 13, weight: .semibold)) + Text(" · " + message))
                .font(.equal(size: 13))
                .tracking(-0.338)
                .lineSpacing(18 - 13 * 1.3)
                .foregroundStyle(EqualColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(EqualSpacing.s16)
        .background {
            RoundedRectangle(cornerRadius: EqualRadius.m).fill(fill)
                .equalShadow(style == .plain ? EqualShadow(color: .clear, radius: 0, x: 0, y: 0) : .tile)
        }
        .accessibilityElement(children: .combine)
    }

    private var fill: Color {
        switch style {
        case .plain, .raised: return EqualColor.bgSurface
        case .translucent: return .equalDynamic(light: 0xFFFFFF, lightAlpha: 0.2, dark: 0xFFFFFF, darkAlpha: 0.08)
        }
    }
}

struct EqualApplePayHintCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualApplePayHintCard(style: .plain)
            EqualApplePayHintCard()
            EqualApplePayHintCard(style: .translucent)
        }
        .frame(width: 332)
        .padding(24)
        .background(EqualGradient.processing)
    }
}
