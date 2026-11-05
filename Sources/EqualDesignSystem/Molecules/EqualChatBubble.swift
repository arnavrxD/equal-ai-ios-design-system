import SwiftUI

/// A message in the Equal thread. **user** bubbles sit right on `bubbleUserBg` with a "You" label;
/// **assistant** bubbles sit left on white with an "Equal AI" label and, first in a run, the
/// Equal dot and a curved tail. An optional inline action ("+ Get more calls", "☆ See plans")
/// sits under a hairline inset to the text column.
public struct EqualChatBubble: View {
    public enum Sender: Sendable { case user, assistant }

    let text: String
    let sender: Sender
    let label: String?
    let time: String
    let showsAvatar: Bool
    let showsTail: Bool
    let actionTitle: String?
    let actionIcon: EqualIcon
    let action: () -> Void

    /// - Parameters:
    ///   - showsAvatar: first assistant bubble of a run: Equal dot, "Equal AI" label.
    ///   - showsTail: the curved tail at the top-left; defaults to `showsAvatar`.
    ///   - actionIcon: SF Symbol before the action title (`.plus` for "Get more calls", `.star` for
    ///     "See plans", "Subscribe now", "Renew now").
    public init(_ text: String, from sender: Sender, label: String? = nil, time: String = "3:31 PM", showsAvatar: Bool = false, showsTail: Bool? = nil, actionTitle: String? = nil, actionIcon: EqualIcon = .plus, action: @escaping () -> Void = {}) {
        self.text = text
        self.sender = sender
        self.label = label
        self.time = time
        self.showsAvatar = showsAvatar
        self.showsTail = sender == .assistant && (showsTail ?? showsAvatar)
        self.actionTitle = actionTitle
        self.actionIcon = actionIcon
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if sender == .user { Spacer(minLength: 60) }
            if sender == .assistant {
                if showsAvatar { EqualAvatar(.equal, size: 28) } else { Color.clear.frame(width: 28, height: 1) }
            }
            bubble
            if sender == .assistant { Spacer(minLength: 24) }
        }
    }

    private var bubble: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                if let who = label ?? (sender == .user ? "You" : (showsAvatar ? "Equal AI" : nil)) {
                    Text(who).font(.equal(size: 12, weight: .semibold)).tracking(-0.31)
                        .foregroundStyle(sender == .user ? Color(equalHex: 0x006223) : EqualColor.green)
                        .padding(.bottom, sender == .user ? EqualSpacing.s8 : EqualSpacing.s2)
                }
                Text(text).equalTextStyle(.body).foregroundStyle(Color(equalHex: 0x111111))
                    .padding(.trailing, actionTitle == nil ? 34 : 0)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .overlay(alignment: .bottomTrailing) {
                Text(time).font(.equal(size: 10)).tracking(-0.6)
                    .foregroundStyle(sender == .user ? Color(equalHex: 0x555555) : Color(equalHex: 0x111111))
                    .fixedSize()
                    .offset(x: 4, y: actionTitle == nil ? 10 : 4)
            }
            if let actionTitle {
                Button(action: action) {
                    HStack(spacing: 6) {
                        EqualIconView(actionIcon, size: 13.3, weight: .medium)
                        Text(actionTitle).font(.equal(size: 16, weight: .medium))
                    }
                    .foregroundStyle(EqualColor.green)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .overlay(alignment: .top) { Rectangle().fill(Color.black.opacity(0.08)).frame(height: 1) }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.top, EqualSpacing.s12)
            }
        }
        .padding(.horizontal, EqualSpacing.s12)
        .padding(.top, EqualSpacing.s12)
        .padding(.bottom, actionTitle == nil ? 18 : 0)
        .background(RoundedRectangle(cornerRadius: EqualRadius.s).fill(sender == .user ? EqualColor.bubbleUserBg : Color.white))
        .overlay(alignment: .topLeading) {
            if showsTail {
                EqualBubbleTail().fill(Color.white).frame(width: 17.5, height: 15.1).offset(x: -16.5)
            }
        }
        .frame(maxWidth: 280, alignment: .leading)
        .environment(\.colorScheme, .light)
    }
}

struct EqualChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 6) {
            EqualChatBubble("Make a call", from: .user)
            EqualChatBubble("You’ve used all 30 AI calls on your Gold plan this month.", from: .assistant, showsAvatar: true)
            EqualChatBubble("Upgrade to Gold Plus for unlimited calls, or wait till 1 Nov for your Gold calls to reset.", from: .assistant, actionTitle: "Get more calls")
            EqualChatBubble("Pick a plan to keep making calls with Equal.", from: .assistant, actionTitle: "See plans", actionIcon: .star)
        }
        .padding(24)
        .background(Color(equalHex: 0xE8E8E8))
    }
}
