import SwiftUI

/// Floating bottom navigation: a liquid-glass capsule with **Chats** and **You** and, beside it,
/// the 64pt Equal FAB on the voice gradient that opens the Equal sheet.
public struct EqualTabBar: View {
    public enum Tab: Hashable, Sendable { case chats, you }

    @Binding var selection: Tab
    let unread: Int
    let onEqual: () -> Void

    public init(selection: Binding<Tab>, unread: Int = 0, onEqual: @escaping () -> Void = {}) {
        self._selection = selection
        self.unread = unread
        self.onEqual = onEqual
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s16) {
            HStack(spacing: 0) {
                tab(.chats, "Chats") { EqualIconView(.chat, size: 20) }
                tab(.you, "You") { EqualIllustration(.avatarMale, size: 26) }
            }
            .padding(EqualSpacing.s4)
            .background(.ultraThinMaterial, in: Capsule())
            .background(Color.white.opacity(0.6), in: Capsule())
            .equalShadow(.tabbar)
            .overlay(alignment: .topLeading) {
                if unread > 0 { EqualUnreadCount(unread).offset(x: 58, y: -4) }
            }

            Button(action: onEqual) {
                EqualMark(size: 26, color: .white)
                    .frame(width: 64, height: 64)
                    .background(Circle().fill(EqualGradient.voice))
                    .equalShadow(.tabbar)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Talk to Equal")
        }
    }

    private func tab<Icon: View>(_ t: Tab, _ title: String, @ViewBuilder icon: () -> Icon) -> some View {
        let on = selection == t
        return Button { selection = t } label: {
            VStack(spacing: 2) {
                icon()
                Text(title).font(.equal(size: 12, weight: on ? .semibold : .medium))
            }
            .foregroundStyle(on ? EqualColor.green : EqualColor.textSecondary)
            .padding(.horizontal, 24).padding(.vertical, 6)
            .background { if on { Capsule().fill(EqualColor.unreadFill).shadow(color: .black.opacity(0.18), radius: 2.5) } }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(on ? .isSelected : [])
    }
}

struct EqualTabBar_Previews: PreviewProvider {
    static var previews: some View {
        EqualTabBar(selection: .constant(.chats), unread: 2).padding(40).equalScreenBackground()
    }
}
