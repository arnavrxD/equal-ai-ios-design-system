import SwiftUI

/// The "Make a call" thread when the Gold limit is reached: sheet header, bubbles on the doodle
/// background, contact chips and the composer.
public struct EqualChatScreen: View {
    @State private var text = ""
    public init() {}
    public var body: some View {
        VStack(spacing: 0) {
            EqualSheetHeader("Make a call")
            ScrollView {
                VStack(spacing: EqualSpacing.s8) {
                    EqualChatBubble("Make a call", from: .user)
                    EqualChatBubble("You’ve used all 30 AI calls on your Gold plan this month.", from: .assistant, showsAvatar: true)
                    EqualChatBubble("Upgrade to Gold Plus for unlimited calls, or wait till 1 Nov for your Gold calls to reset.", from: .assistant, actionTitle: "Get more calls")
                }
                .padding(EqualSpacing.s24)
            }
            VStack(spacing: EqualSpacing.s16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: EqualSpacing.s12) {
                        EqualChip("Amit Nanda") { EqualAvatar(.initials("AN"), size: 18) }
                        EqualChip("Dr. Mehta") { EqualAvatar(.illustration(.categoryOthers), size: 18, tint: .others) }
                        EqualChip("Other", variant: .suggested, icon: .plus, showsChevron: false, tall: true)
                    }
                    .padding(1)
                }
                EqualComposer(text: $text)
            }
            .padding(.horizontal, EqualSpacing.s24)
            .padding(.bottom, EqualSpacing.s16)
        }
        .background(Color(equalHex: 0xE8E8E8).ignoresSafeArea())
    }
}

struct EqualChatScreen_Previews: PreviewProvider { static var previews: some View { EqualChatScreen() } }
