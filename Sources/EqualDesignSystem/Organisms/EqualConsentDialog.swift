import SwiftUI

/// In-app consent dialog shown before the iOS permission alerts: "Allow Equal to process your
/// call data?" on a 302pt `#F7F7F7` card (radius 30) with a grey **Don’t allow** and a green
/// **Allow** button. Pass `backdrop: true` to centre it over the `#1E1E1E@40%` blurred scrim.
public struct EqualConsentDialog: View {
    let title: String
    let message: String
    let declineTitle: String
    let allowTitle: String
    let backdrop: Bool
    let onDecline: () -> Void
    let onAllow: () -> Void

    public init(title: String = "Allow Equal to process your call data?",
                message: String = "To identify callers, detect spam, and respond on your behalf, Equal shares limited call data- including caller ID, audio transcripts, and contact context, with our AI partners.\n\nYour data is used only to power your assistant. It is never sold or used for advertising.",
                declineTitle: String = "Don’t allow", allowTitle: String = "Allow", backdrop: Bool = false,
                onDecline: @escaping () -> Void = {}, onAllow: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.declineTitle = declineTitle
        self.allowTitle = allowTitle
        self.backdrop = backdrop
        self.onDecline = onDecline
        self.onAllow = onAllow
    }

    public var body: some View {
        if backdrop {
            ZStack {
                Color(equalHex: 0x1E1E1E, alpha: 0.4).ignoresSafeArea()
                card
            }
        } else {
            card
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 19) {
            Text(title).font(.equal(size: 18, weight: .semibold)).tracking(-0.47).lineSpacing(22 - 18 * 1.3)
                .foregroundStyle(Color(equalHex: 0x111111))
                .accessibilityAddTraits(.isHeader)
            Text(message).font(.equal(size: 12)).tracking(-0.31).lineSpacing(16 - 12 * 1.3)
                .foregroundStyle(Color(equalHex: 0x111111))
            HStack(spacing: EqualSpacing.s12) {
                button(declineTitle, fill: Color(equalHex: 0xDADADA, alpha: 0.7), text: Color(equalHex: 0x070707, alpha: 0.8), weight: .regular, action: onDecline)
                button(allowTitle, fill: EqualColor.brandGreen, text: .white, weight: .bold, action: onAllow)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 18)
        .padding(.vertical, 32)
        .frame(width: 302)
        .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color(equalHex: 0xF7F7F7)))
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }

    private func button(_ title: String, fill: Color, text: Color, weight: Font.Weight, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.equal(size: 14, weight: weight)).foregroundStyle(text)
                .frame(maxWidth: .infinity).frame(height: 42)
                .background(RoundedRectangle(cornerRadius: 30, style: .continuous).fill(fill))
        }
        .buttonStyle(.plain)
    }
}

struct EqualConsentDialog_Previews: PreviewProvider {
    static var previews: some View {
        EqualConsentDialog(backdrop: true).frame(width: 393, height: 852)
    }
}
