import SwiftUI

/// Bottom bar with one full-width CTA under a gold hairline. **gold** "Start using Equal Gold";
/// **goldTerms** the gold CTA with trial terms and the legal line; **renew** a green
/// "Renew - ₹249/month" with "Cancel anytime. Automatically renews". Pin it to the bottom edge,
/// ignoring the bottom safe area (it includes the home-indicator space).
public struct EqualStickyCTABar: View {
    public enum Style: Sendable { case gold, goldTerms, renew }

    let style: Style
    let title: String
    let caption: String?
    let legal: String?
    let action: () -> Void

    /// - Parameters:
    ///   - title: defaults per style: "Start using Equal Gold", "Experience Gold for ₹249", "Renew - ₹249/month".
    ///   - caption: the line under the CTA (trial terms for `.goldTerms`, renewal note for `.renew`).
    public init(_ style: Style = .gold, title: String? = nil, caption: String? = nil, legal: String? = nil, action: @escaping () -> Void = {}) {
        self.style = style
        self.action = action
        switch style {
        case .gold:
            self.title = title ?? "Start using Equal Gold"
            self.caption = caption
            self.legal = legal
        case .goldTerms:
            self.title = title ?? "Experience Gold for ₹249"
            self.caption = caption ?? "Free for 7 days, then ₹249/month. Cancel at least 24h before the trial ends to avoid charges."
            self.legal = legal ?? "Recurring billing.  Terms & Privacy. Restore purchases"
        case .renew:
            self.title = title ?? "Renew - ₹249/month"
            self.caption = caption ?? "Cancel anytime.  Automatically renews"
            self.legal = legal
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                Text(title)
                    .equalTextStyle(.calloutEm)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, EqualSpacing.s32)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(ctaFill)
                    .overlay(alignment: .leading) {
                        // Light streak: 16×72 white 52%, blur 18, tilted, ~56pt in.
                        Rectangle().fill(Color.white.opacity(0.52)).frame(width: 16, height: 72)
                            .blur(radius: 9).rotationEffect(.degrees(19)).offset(x: 48)
                            .allowsHitTesting(false)
                    }
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.leading, 21).padding(.trailing, 26)
            .padding(.top, 19)

            if let caption {
                Text(caption)
                    .font(.equal(size: style == .renew ? 15 : 12, weight: style == .renew ? .regular : .medium))
                    .lineSpacing(style == .renew ? 0.5 : 0)
                    .foregroundStyle(style == .renew ? EqualColor.textSecondary.opacity(0.6) : Self.terms)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, EqualSpacing.s24)
                    .padding(.top, style == .renew ? 13 : 14)
            }
            if let legal {
                Text(legal).font(.equal(size: 11)).foregroundStyle(Self.legalColor)
                    .padding(.top, 20)
            }
        }
        .padding(.bottom, bottomPadding)
        .frame(maxWidth: .infinity)
        .background(Self.surface)
        .overlay(alignment: .top) {
            LinearGradient(stops: [
                .init(color: Color(equalHex: 0xFFD94F, alpha: 0), location: 0),
                .init(color: Color(equalHex: 0xFFD94F), location: 0.54),
                .init(color: Color(equalHex: 0xFFD94F, alpha: 0), location: 1)
            ], startPoint: .leading, endPoint: .trailing)
            .frame(height: 1)
        }
    }

    private var bottomPadding: CGFloat {
        switch style {
        case .gold: return 36
        case .goldTerms: return 9
        case .renew: return 29
        }
    }

    @ViewBuilder private var ctaFill: some View {
        if style == .renew {
            EqualColor.brandGreen
        } else {
            ZStack { Color.black; EqualGradient.ctaGold }
        }
    }

    static let surface = Color.equalDynamic(light: 0xFFFFFF, dark: 0x000000)
    static let terms = Color.equalDynamic(light: 0x000000, lightAlpha: 0.4, dark: 0xFFFFFF, darkAlpha: 0.5)
    static let legalColor = Color(equalHex: 0xB5B5B5)
}

struct EqualStickyCTABar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            EqualStickyCTABar()
            EqualStickyCTABar(.goldTerms)
            EqualStickyCTABar(.renew)
        }
        .equalScreenBackground()
    }
}
