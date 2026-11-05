import SwiftUI

/// The line under an input: a helper with an emphasised value, the OTP resend countdown,
/// the "Resend OTP" link, or a validation error.
public struct EqualFieldMessage: View {
    public enum Kind: Sendable {
        /// "Your AI will call you ‘Keshav’": regular text with a bold value.
        case helper(String, emphasis: String)
        /// "Resend in 00:30" at 60% opacity.
        case countdown(seconds: Int)
        /// "Resend OTP": green semibold link at 60% opacity.
        case link(String)
        /// Warning glyph + red semibold message.
        case error(String)
    }

    let kind: Kind
    let action: () -> Void

    public init(_ kind: Kind, action: @escaping () -> Void = {}) {
        self.kind = kind
        self.action = action
    }

    public var body: some View {
        switch kind {
        case .helper(let text, let emphasis):
            (Text(text) + Text(emphasis).bold())
                .font(.equal(size: 12)).tracking(-0.31)
                .foregroundStyle(EqualColor.textSecondary)
                .multilineTextAlignment(.center)
        case .countdown(let seconds):
            (Text("Resend in ") + Text(String(format: "%02d:%02d", seconds / 60, seconds % 60)).bold())
                .font(.equal(size: 12)).tracking(-0.31).monospacedDigit()
                .foregroundStyle(EqualColor.textSecondary)
                .opacity(0.6)
        case .link(let title):
            Button(action: action) {
                Text(title).font(.equal(size: 11, weight: .semibold)).tracking(-0.29)
                    .foregroundStyle(EqualColor.green)
            }
            .buttonStyle(.plain)
            .opacity(0.6)
        case .error(let message):
            HStack(spacing: 4) {
                EqualIconView(.warning, size: 11, weight: .semibold)
                Text(message).font(.equal(size: 12, weight: .semibold)).tracking(-0.31)
            }
            .foregroundStyle(EqualColor.red08)
            .accessibilityElement(children: .combine)
        }
    }
}

struct EqualFieldMessage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            EqualFieldMessage(.helper("Your AI will call you ", emphasis: "‘Keshav’"))
            EqualFieldMessage(.countdown(seconds: 30))
            EqualFieldMessage(.link("Resend OTP"))
            EqualFieldMessage(.error("Incorrect OTP, try again"))
            EqualFieldMessage(.error("Special characters and numbers not allowed"))
        }
        .padding(24)
        .equalScreenBackground()
    }
}
