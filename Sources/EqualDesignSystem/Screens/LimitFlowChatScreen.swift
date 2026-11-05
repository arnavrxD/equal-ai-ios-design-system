import SwiftUI

/// The chat side of the four limit flows: the home (with the flow's plan badge) under a
/// `#1E1E1E@40%` scrim and, over it, the Equal sheet (01), the "Make a call" chat with the limit
/// message (02) or the chat after the purchase (06, upgraded badge).
public struct LimitFlowChatScreen: View {
    public enum Step: Hashable, Sendable {
        /// 01 · Home → Equal sheet (greeting, shortcuts, suggestions).
        case equalSheet
        /// 02 · "Make a call" → limit message with the inline action.
        case limitMessage
        /// 06 · Back in chat: the call goes through.
        case backInChat
        /// 06b · Back in chat, the whole thread scrolled to the bottom.
        case backInChatScrolled
    }

    let flow: EqualLimitFlow
    let step: Step
    let onAction: () -> Void

    /// - Parameter onAction: Make a Call on the Equal sheet, or the inline limit action in the chat.
    public init(flow: EqualLimitFlow = .goldLimit, step: Step = .limitMessage, onAction: @escaping () -> Void = {}) {
        self.flow = flow
        self.step = step
        self.onAction = onAction
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                HomeScreen(badge: badge, promos: [], showsTabBar: false)
                Color(equalHex: 0x1E1E1E, alpha: 0.4).ignoresSafeArea()
                Group {
                    if step == .equalSheet {
                        EqualSheet(onShortcut: { if $0 == 2 { onAction() } })
                    } else {
                        EqualChatScreen(flow: flow, step: step, onAction: onAction)
                            .frame(height: min(610, geo.size.height - 120))
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    private var badge: EqualPlanBadge.Kind {
        step == .backInChat || step == .backInChatScrolled ? flow.chatUpgradedBadge : flow.chatBadge
    }
}

struct LimitFlowChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        LimitFlowChatScreen(flow: .goldLimit, step: .equalSheet)
        LimitFlowChatScreen(flow: .trialLimit, step: .limitMessage)
        LimitFlowChatScreen(flow: .planExpired, step: .backInChat)
    }
}
