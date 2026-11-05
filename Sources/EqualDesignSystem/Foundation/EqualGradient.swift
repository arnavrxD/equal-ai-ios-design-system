import SwiftUI

/// The gradient tokens as SwiftUI fills (CSS sources in tokens/tokens.json → gradient).
public enum EqualGradient {
    /// Send voice note button, Equal FAB, Equal avatar dot.
    public static let voice = LinearGradient(colors: [EqualColor.brandLime, EqualColor.brandGreen], startPoint: .top, endPoint: .bottom)
    /// Suggested / unread action chips (with the `unreadStroke` border).
    public static let chipSuggested = LinearGradient(colors: [EqualColor.brandLime.opacity(0.08), EqualColor.brandLime], startPoint: .top, endPoint: .bottom)
    /// Neutral action chips (with the `strokeMedium` border).
    public static let chipNeutral = LinearGradient(colors: [EqualColor.brandWhite, Color(equalHex: 0xEBEBEB)], startPoint: .top, endPoint: .bottom)
    /// Paywall CTA over black.
    public static let ctaGold = LinearGradient(colors: [Color(equalHex: 0x2E2E2E), Color(equalHex: 0xFFC927, alpha: 0.2)], startPoint: .leading, endPoint: .trailing)
    /// Equal GOLD membership card over black.
    public static let membership = LinearGradient(colors: [Color(equalHex: 0x2E2E2E), Color(equalHex: 0x7A4900, alpha: 0.2)], startPoint: .leading, endPoint: .trailing)
    /// Free-week recap card.
    public static let recap = LinearGradient(stops: [
        .init(color: Color(equalHex: 0x2A2A28), location: 0),
        .init(color: Color(equalHex: 0x3A3218), location: 0.6),
        .init(color: Color(equalHex: 0x7A5A12), location: 1)
    ], startPoint: .leading, endPoint: .trailing)
    /// Paywall and subscription hero glow behind the crown.
    public static let goldHero = RadialGradient(stops: [
        .init(color: Color(equalHex: 0xFFC927), location: 0),
        .init(color: Color(equalHex: 0xFFFEFC), location: 0.7),
        .init(color: .white, location: 1)
    ], center: .top, startRadius: 0, endRadius: 420)
    /// "GOLD" wordmark text and gold star outlines.
    public static let goldText = LinearGradient(stops: [
        .init(color: Color(equalHex: 0xFFD040), location: 0),
        .init(color: Color(equalHex: 0xFFF8C7), location: 0.4),
        .init(color: Color(equalHex: 0xCFA846), location: 1)
    ], startPoint: .top, endPoint: .bottom)
    /// Coupon seal badge.
    public static let coupon = LinearGradient(stops: [
        .init(color: Color(equalHex: 0xFFD95A), location: 0),
        .init(color: Color(equalHex: 0xF2A900), location: 0.55),
        .init(color: Color(equalHex: 0xC77700), location: 1)
    ], startPoint: .top, endPoint: .bottom)
    /// "Only 1 day of Gold left" card wash.
    public static let trialCard = LinearGradient(colors: [.white, Color(equalHex: 0xFE8383)], startPoint: .topLeading, endPoint: .bottomTrailing)
    /// Splash screen.
    public static let splash = LinearGradient(stops: [
        .init(color: EqualColor.brandGreen, location: 0),
        .init(color: Color(equalHex: 0x6DD836), location: 0.55),
        .init(color: EqualColor.brandLime, location: 1)
    ], startPoint: .topLeading, endPoint: .bottomTrailing)
    /// Value-recap story background.
    public static let recapStory = RadialGradient(stops: [
        .init(color: Color(equalHex: 0x1F4D17), location: 0),
        .init(color: Color(equalHex: 0x0B1215), location: 0.7),
        .init(color: .black, location: 1)
    ], center: UnitPoint(x: 0.5, y: 0.4), startRadius: 0, endRadius: 520)
    /// Fade behind the floating tab bar.
    public static let fadeBottom = LinearGradient(colors: [EqualColor.bgPrimary.opacity(0), EqualColor.bgPrimary], startPoint: .top, endPoint: .bottom)
    /// Cream-to-gold wash of the payment processing screen. Figma: white frame under a 1115pt ellipse
    /// (#FFFFFF → #FFFEFC → #FFC927 at 60%) and a #FDEFC6 top glow; stops sampled from the render.
    public static let processing = LinearGradient(stops: [
        .init(color: Color(equalHex: 0xFFFDF5), location: 0),
        .init(color: Color(equalHex: 0xFFFEFA), location: 0.17),
        .init(color: Color(equalHex: 0xFFFAE9), location: 0.35),
        .init(color: Color(equalHex: 0xFFF3CE), location: 0.55),
        .init(color: Color(equalHex: 0xFFE28C), location: 1)
    ], startPoint: .top, endPoint: .bottom)
}
