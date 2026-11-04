import SwiftUI

/// A message in the Equal thread. **user** bubbles sit right on `bubbleUserBg` with a "You" label;
/// **assistant** bubbles sit left on the surface with an "Equal AI" label and, first in a run,
/// the Equal dot. An optional inline action ("+ Get more calls") sits under a hairline.
public struct EqualChatBubble: View {
    public enum Sender: Sendable { case user, assistant }

    let text: String
    let sender: Sender
    let label: String?
    let time: String
    let showsAvatar: Bool
    let actionTitle: String?
    let action: () -> Void

    public init(_ text: String, from sender: Sender, label: String? = nil, time: String = "3:31 PM", showsAvatar: Bool = false, actionTitle: String? = nil, action: @escaping () -> Void = {}) {
        self.text = text
        self.sender = sender
        self.label = label
        self.time = time
        self.showsAvatar = showsAvatar
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .top, spacing: EqualSpacing.s8) {
            if sender == .user { Spacer(minLength: 60) }
            if sender == .assistant {
                if showsAvatar { EqualAvatar(.equal, size: 28) } else { Color.clear.frame(width: 28, height: 1) }
            }
            bubble
            if sender == .assistant { Spacer(minLength: 24) }
        }
    }

    private var bubble: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s8) {
            if let who = label ?? (sender == .user ? "You" : (showsAvatar ? "Equal AI" : nil)) {
                Text(who).equalTextStyle(.caption1Em)
                    .foregroundStyle(sender == .user ? EqualColor.bubbleUserTitle : EqualColor.green)
            }
            Text(text).equalTextStyle(.body).foregroundStyle(EqualColor.textPrimary).padding(.trailing, 34)
            if let actionTitle {
                Divider().overlay(EqualColor.strokeMedium).padding(.horizontal, -12)
                Button(action: action) {
                    Label(actionTitle, systemImage: "plus")
                        .font(.equal(size: 16, weight: .medium))
                        .foregroundStyle(EqualColor.textAction)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(EqualSpacing.s12)
        .padding(.bottom, 6)
        .overlay(alignment: .bottomTrailing) {
            Text(time).equalTextStyle(.bubbleTime).foregroundStyle(EqualColor.textSecondary).padding(8)
        }
        .background(RoundedRectangle(cornerRadius: EqualRadius.s).fill(sender == .user ? EqualColor.bubbleUserBg : EqualColor.bgSurface))
        .frame(maxWidth: 280, alignment: .leading)
    }
}

struct EqualChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            EqualChatBubble("Make a call", from: .user)
            EqualChatBubble("You’ve used all 30 AI calls on your Gold plan this month.", from: .assistant, showsAvatar: true)
            EqualChatBubble("Upgrade to Gold Plus for unlimited calls, or wait till 1 Nov for your Gold calls to reset.", from: .assistant, actionTitle: "Get more calls")
        }
        .padding(24)
        .background(Color(equalHex: 0xE8E8E8))
    }
}
