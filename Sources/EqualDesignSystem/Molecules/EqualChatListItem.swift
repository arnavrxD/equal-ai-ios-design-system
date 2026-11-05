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
    /// Muted conversations show a bell-slash in the compact row.
    public var isMuted: Bool

    public init(name: String, summary: String, time: String, unread: Int = 0, avatar: EqualAvatar.Content, tint: EqualAvatar.Tint = .mint, isContact: Bool = false, actions: [EqualChatAction] = [], isMuted: Bool = false) {
        self.name = name; self.summary = summary; self.time = time; self.unread = unread
        self.avatar = avatar; self.tint = tint; self.isContact = isContact; self.actions = actions; self.isMuted = isMuted
    }

    /// The same conversations without action chips (56pt rows, e.g. under a permission sheet).
    public static var samplesWithoutActions: [EqualChat] {
        samples.map { var c = $0; c.actions = []; return c }
    }

    /// Conversations from the legacy home (compact rows under "CONVERSATIONS").
    public static let legacySamples: [EqualChat] = [
        EqualChat(name: "Saurabh", summary: "About a miniature painting...", time: "Yesterday", unread: 1, avatar: .illustration(.rotaryPhoneRed), tint: .others),
        EqualChat(name: "Mygate Security", summary: "You have a visitor", time: "1:00 PM", avatar: .illustration(.securityGuard), tint: .career),
        EqualChat(name: "Amit Nanda", summary: "Amit is done with onboarding.", time: "1 Jul", avatar: .illustration(.laptop), tint: .unknown, isMuted: true),
        EqualChat(name: "HDFC Bank", summary: "Home loan offer especially for you", time: "30 Jun", avatar: .illustration(.categoryFinance), tint: .finance),
        EqualChat(name: "Rahul Sharma", summary: "Wants to discuss the job opening", time: "29 Jun", avatar: .illustration(.briefcase), tint: .career)
    ]

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
/// The **compact** style is the legacy 36pt row: grey type, a 9pt unread dot, no chips.
public struct EqualChatListItem: View {
    public enum Style: Sendable {
        /// 56pt avatar, 18/17 type, unread count, action chips.
        case regular
        /// 36pt avatar, 16/15 grey type, unread dot, bell-slash when muted.
        case compact
    }

    let chat: EqualChat
    let style: Style
    let onAction: (EqualChatAction) -> Void

    public init(_ chat: EqualChat, style: Style = .regular, onAction: @escaping (EqualChatAction) -> Void = { _ in }) {
        self.chat = chat
        self.style = style
        self.onAction = onAction
    }

    public var body: some View {
        switch style {
        case .regular: regular
        case .compact: compact
        }
    }

    private var compact: some View {
        HStack(alignment: .center, spacing: 18) {
            EqualAvatar(chat.avatar, size: 36, tint: chat.tint, isContact: chat.isContact)
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .firstTextBaseline) {
                    Text(chat.name).font(.equal(size: 16, weight: .semibold)).foregroundStyle(Color(equalHex: 0x3C3C3C))
                    Spacer(minLength: 8)
                    Text(chat.time).font(.equal(size: 12, weight: .medium)).foregroundStyle(Color(equalHex: 0xB8B8B8))
                }
                HStack {
                    Text(chat.summary).font(.equal(size: 15)).tracking(-0.3).foregroundStyle(Color(equalHex: 0x858484))
                    Spacer(minLength: 8)
                    if chat.isMuted {
                        Image(systemName: "bell.slash.fill").font(.system(size: 12)).foregroundStyle(Color(equalHex: 0xB8B8B8))
                            .accessibilityLabel("Muted")
                    } else if chat.unread > 0 {
                        Circle().fill(EqualColor.green).frame(width: 9, height: 9).accessibilityLabel("Unread")
                    }
                }
            }
            .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
    }

    private var regular: some View {
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
                    EqualScrollContent(.horizontal) {
                        HStack(spacing: EqualSpacing.s12) {
                            ForEach(chat.actions) { a in
                                EqualChip(a.title, variant: chat.unread > 0 ? .suggested : .neutral, emoji: a.emoji) { onAction(a) }
                            }
                        }
                        .padding(1)
                        .padding(.trailing, EqualSpacing.s24)
                    }
                    // chips run to the screen edge, past the 24pt gutter
                    .padding(.trailing, -EqualSpacing.s24)
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
            EqualChatListItem(EqualChat.legacySamples[0], style: .compact)
            EqualChatListItem(EqualChat.legacySamples[2], style: .compact)
        }
        .padding(24)
        .equalScreenBackground()
    }
}
