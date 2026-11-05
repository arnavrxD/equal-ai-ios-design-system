import SwiftUI

/// The Equal "Make a call" chat sheet: header, the thread on the doodle wallpaper, contact chips
/// and the composer. Copy follows an `EqualLimitFlow` and a step: the limit message with its
/// inline action, back in chat after the purchase, or the full thread scrolled to the bottom.
public struct EqualChatScreen: View {
    let flow: EqualLimitFlow
    let step: LimitFlowChatScreen.Step
    let onAction: () -> Void
    let onClose: () -> Void
    @State private var text = ""

    /// - Parameters:
    ///   - step: `.limitMessage`, `.backInChat` or `.backInChatScrolled` (`.equalSheet` shows the limit message).
    ///   - onAction: the inline action ("Get more calls", "See plans", …).
    public init(flow: EqualLimitFlow = .goldLimit, step: LimitFlowChatScreen.Step = .limitMessage, onAction: @escaping () -> Void = {}, onClose: @escaping () -> Void = {}) {
        self.flow = flow
        self.step = step
        self.onAction = onAction
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualSheetHeader("Make a call", onClose: onClose).zIndex(1)
            thread
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: step == .backInChatScrolled ? .bottom : .top)
                .clipped()
            EqualScrollContent(.horizontal) {
                HStack(spacing: EqualSpacing.s16) {
                    EqualSheetChip("Amit Nanda") { EqualAvatar(.initials("AN"), size: 18) }
                    EqualSheetChip("Dr. Mehta") { EqualAvatar(.illustration(.rotaryPhoneRed), size: 18, tint: .others) }
                    EqualSheetChip("Other", emoji: "➕")
                }
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.vertical, 2)
            }
            .padding(.top, 12)
            EqualComposer(text: $text)
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.top, 15)
                .padding(.bottom, 35)
        }
        .background(EqualChatWallpaper().padding(.top, 98))
        .background(Color(equalHex: 0xE8E8E8))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
        .overlay {
            UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl)
                .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
                .mask(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .init(x: 0.5, y: 0.05)))
                .allowsHitTesting(false)
        }
        .shadow(color: .black.opacity(0.12), radius: 4, y: -6)
        .environment(\.colorScheme, .light)
    }

    private var thread: some View {
        VStack(spacing: 0) {
            if step != .backInChatScrolled {
                EqualChatBubble("Make a call", from: .user).padding(.trailing, 19).padding(.top, 21)
            }
            VStack(spacing: 6) {
                switch step {
                case .equalSheet, .limitMessage:
                    EqualChatBubble(flow.chatLimitMessage, from: .assistant, showsAvatar: true)
                    EqualChatBubble(flow.chatLimitFollowUp, from: .assistant, actionTitle: flow.chatActionTitle, actionIcon: flow.chatActionIcon, action: onAction)
                case .backInChat:
                    EqualChatBubble(flow.chatBackMessage, from: .assistant, showsAvatar: true)
                    EqualChatBubble(EqualLimitFlow.chatBackFollowUp, from: .assistant)
                case .backInChatScrolled:
                    EqualChatBubble("Make a call", from: .user).padding(.trailing, 7).padding(.bottom, 12)
                    EqualChatBubble(flow.chatLimitMessage, from: .assistant, showsAvatar: true)
                    EqualChatBubble(flow.chatLimitFollowUp, from: .assistant, actionTitle: flow.chatActionTitle, actionIcon: flow.chatActionIcon, action: onAction)
                    EqualChatBubble(flow.chatBackMessage, from: .assistant)
                    EqualChatBubble(EqualLimitFlow.chatBackFollowUp, from: .assistant)
                }
            }
            .padding(.leading, 12)
            .padding(.trailing, step == .backInChatScrolled ? 12 : 0)
            .padding(.top, step == .backInChatScrolled ? 0 : 18)
            .padding(.bottom, step == .backInChatScrolled ? 32 : 0)
        }
    }
}

struct EqualChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        EqualChatScreen()
        EqualChatScreen(flow: .trialLimit)
        EqualChatScreen(flow: .planExpired, step: .backInChat)
    }
}
