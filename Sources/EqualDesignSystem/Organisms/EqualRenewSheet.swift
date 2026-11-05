import SwiftUI

/// Pinned bottom sheet on the expired subscription page: a gold "Renew Plan" capsule with a light
/// streak and an underlined "Explore other plans" link.
///
/// Figma 26242:98635 (Sticky plans sheet), 393×127, white with 24pt top corners and the sticky
/// shadow. Use it in `.safeAreaInset(edge: .bottom)`; the white extends under the home indicator.
public struct EqualRenewSheet: View {
    let title: String
    let linkTitle: String
    let onRenew: () -> Void
    let onExplore: () -> Void

    public init(title: String = "Renew Plan – ₹249/month", linkTitle: String = "Explore other plans", onRenew: @escaping () -> Void = {}, onExplore: @escaping () -> Void = {}) {
        self.title = title
        self.linkTitle = linkTitle
        self.onRenew = onRenew
        self.onExplore = onExplore
    }

    public var body: some View {
        VStack(spacing: 11) {
            EqualGoldCapsuleCTA(title, action: onRenew)
            Button(action: onExplore) {
                Text(linkTitle)
                    .font(.equal(size: 15, weight: .semibold)).tracking(-0.39)
                    .underline()
                    .foregroundStyle(Color.black)
                    .frame(height: 20)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 22)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: EqualRadius.sheet, topTrailingRadius: EqualRadius.sheet)
                .fill(Color.white)
                .equalShadow(.sticky)
                .ignoresSafeArea(edges: .bottom)
        }
        .environment(\.colorScheme, .light)
    }
}

/// The 52pt black-to-gold capsule used for paywall-style CTAs on the subscription page: SemiBold 16
/// white label and a soft white streak near the leading edge (Figma 26242:98636 / 26242:89392).
struct EqualGoldCapsuleCTA: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.equal(size: 16, weight: .semibold)).tracking(-0.416)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background {
                    ZStack(alignment: .leading) {
                        Color.black
                        LinearGradient(colors: [Color(equalHex: 0x2E2E2E), Color(equalHex: 0xFFC927, alpha: 0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        // Light streak: 16×72 white @52%, blur 9, rotated 18.5°, at x 32.
                        Rectangle().fill(Color.white.opacity(0.52))
                            .frame(width: 16.09, height: 72.1)
                            .blur(radius: 9)
                            .rotationEffect(.degrees(18.52))
                            .offset(x: 43)
                    }
                }
                .clipShape(Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct EqualRenewSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            EqualRenewSheet()
        }
        .frame(width: 393, height: 300)
        .background(Color.white)
    }
}
