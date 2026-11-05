import SwiftUI

/// The home conversation list: chat rows 12pt apart, separated by hairlines inset to the text
/// column. The **compact** style (legacy home) stacks 36pt rows 16pt apart without hairlines.
public struct EqualChatList: View {
    let chats: [EqualChat]
    let style: EqualChatListItem.Style
    let onSelect: (EqualChat) -> Void
    let onAction: (EqualChat, EqualChatAction) -> Void

    public init(_ chats: [EqualChat] = EqualChat.samples, style: EqualChatListItem.Style = .regular, onSelect: @escaping (EqualChat) -> Void = { _ in }, onAction: @escaping (EqualChat, EqualChatAction) -> Void = { _, _ in }) {
        self.chats = chats
        self.style = style
        self.onSelect = onSelect
        self.onAction = onAction
    }

    public var body: some View {
        VStack(spacing: style == .compact ? 16 : EqualSpacing.s12) {
            ForEach(Array(chats.enumerated()), id: \.element.id) { i, chat in
                if i > 0 && style == .regular { Rectangle().fill(EqualColor.strokeMedium).frame(height: 1).padding(.leading, 68) }
                EqualChatListItem(chat, style: style) { onAction(chat, $0) }
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(chat) }
            }
        }
    }
}

struct EqualChatList_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView { EqualChatList().padding(24) }.equalScreenBackground()
    }
}
