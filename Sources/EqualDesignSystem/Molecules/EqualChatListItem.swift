import SwiftUI

/// A post-call action shown as a chip under a conversation.
public struct EqualChatAction: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let emoji: String
    public init(_ title: String, emoji: String) { self.id = title; self.title = title; self.emoji = emoji }

    public static let callBack = EqualChatAction("Call back", emoji: "📞")
    public static let addToCalendar = EqualChatAction("Add to Calendar", emoji: "🗓️")
    public static let mute = EqualChatAction("Mute", emoji: "🔕")
    public static let addToDND = EqualChatAction("Add to DND", emoji: "🛑")
    public static let updateAddress = EqualChatAction("Update address", emoji: "✏️")
    public static let addInstruction = EqualChatAction("Add instruction", emoji: "📝")
}

/// One conversation in the home list.
public struct EqualChat: Identifiable, Sendable {
    public let id = UUID()
    public var name: String
    public var summary: String
    public var time: String
    public var unread: Int
    public var avatar: EqualAvatar.Content
    public var tint: EqualAvatar.Tint
    public var isContact: Bool
    public var actions: [EqualChatAction]

    public init(name: String, summary: String, time: String, unread: Int = 0, avatar: EqualAvatar.Content, tint: EqualAvatar.Tint = .mint, isContact: Bool = false, actions: [EqualChatAction] = []) {
        self.name = name; self.summary = summary; self.time = time; self.unread = unread
        self.avatar = avatar; self.tint = tint; self.isContact = isContact; self.actions = actions
    }

    /// Sample data from the Figma home screen.
    public static let samples: [EqualChat] = [
        EqualChat(name: "Amit Nanda", summary: "Amit called to remind you about the meeting", time: "3:15 PM", unread: 1, avatar: .initials("AN"), isContact: true, actions: [.callBack, .addToCalendar]),
        EqualChat(name: "HDFC Bank", summary: "Home loan offer especially for you", time: "3:02 PM", unread: 1, avatar: .illustration(.categoryFinance), tint: .finance, actions: [.mute, .addToDND]),
        EqualChat(name: "Shankar Rapido", summary: "Driver has come to location", time: "3:02 PM", avatar: .illustration(.categoryRide), tint: .ride, actions: [.updateAddress, .mute]),
        EqualChat(name: "Santosh Anna", summary: "Order left with security", time: "3:02 PM", avatar: .illustration(.categoryDelivery), tint: .peach, actions: [.updateAddress, .mute]),
        EqualChat(name: "+91 9871746113", summary: "Caller said hello", time: "Yesterday", avatar: .illustration(.categoryOthers), tint: .others, actions: [.mute, .addToDND])
    ]
}

/// Avatar · name · one-line summary · time · unread count · a scrolling row of action chips.
/// Unread rows use the green time and **suggested** chips; read rows use **neutral** chips.
public struct EqualChatListItem: View {
    let chat: EqualChat
    let onAction: (EqualChatAction) -> Void

    public init(_ chat: EqualChat, onAction: @escaping (EqualChatAction) -> Void = { _ in }) {
        self.chat = chat
        self.onAction = onAction
    }

    public var body: some View {
        HStack(alignment: .top, spacing: EqualSpacing.s12) {
            EqualAvatar(chat.avatar, tint: chat.tint, isContact: chat.isContact)
            VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                HStack(alignment: .top, spacing: 3) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(chat.name).equalTextStyle(.headlineEm).foregroundStyle(EqualColor.textPrimary)
                        Text(chat.summary).equalTextStyle(.body).foregroundStyle(EqualColor.textSecondary)
                    }
                    .lineLimit(1)
                    Spacer(minLength: 0)
                    VStack(alignment: .trailing, spacing: EqualSpacing.s8) {
                        Text(chat.time)
                            .equalTextStyle(chat.unread > 0 ? .footnoteEm : .footnote)
                            .foregroundStyle(chat.unread > 0 ? EqualColor.textAction : EqualColor.textSecondary)
                        if chat.unread > 0 { EqualUnreadCount(chat.unread) }
                    }
                }
                if !chat.actions.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: EqualSpacing.s12) {
                            ForEach(chat.actions) { a in
                                EqualChip(a.title, variant: chat.unread > 0 ? .suggested : .neutral, emoji: a.emoji) { onAction(a) }
                            }
                        }
                        .padding(1)
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
    }
}

struct EqualChatListItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            EqualChatListItem(EqualChat.samples[0])
            EqualChatListItem(EqualChat.samples[2])
        }
        .padding(24)
        .equalScreenBackground()
    }
}
