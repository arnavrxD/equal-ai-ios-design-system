import SwiftUI

/// The master switch at the top of Settings: a lime-tinted card with a soft green glow,
/// the assistant bot, "AI Assistant is On" and a toggle.
public struct EqualAssistantToggleCard: View {
    @Binding var isOn: Bool
    let title: String
    let subtitle: String

    public init(isOn: Binding<Bool>, title: String = "AI Assistant is On", subtitle: String = "Equal is managing your unknown calls") {
        self._isOn = isOn
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s10) {
            EqualIllustration(.assistantBot, size: 48)
            VStack(alignment: .leading, spacing: 0) {
                Text(isOn ? title : "AI Assistant is Off").font(.equal(size: 16, weight: .semibold)).foregroundStyle(EqualColor.textPrimary)
                Text(subtitle).equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary)
            }
            Spacer(minLength: 0)
            EqualToggle("AI Assistant", isOn: $isOn)
        }
        .padding(.vertical, EqualSpacing.s8)
        .padding(.leading, EqualSpacing.s8)
        .padding(.trailing, EqualSpacing.s12)
        .background {
            RoundedRectangle(cornerRadius: EqualRadius.m).fill(EqualColor.unreadFill)
                .overlay(alignment: .topLeading) {
                    Circle().fill(EqualColor.unreadStroke).frame(width: 197, height: 197).blur(radius: 60).offset(x: -60, y: -80)
                }
                .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        }
    }
}

struct EqualAssistantToggleCard_Previews: PreviewProvider {
    static var previews: some View {
        EqualAssistantToggleCard(isOn: .constant(true)).padding(24).equalScreenBackground()
    }
}
