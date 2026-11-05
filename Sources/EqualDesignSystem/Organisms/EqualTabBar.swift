import SwiftUI

/// Floating bottom navigation: a liquid-glass capsule (white 16%) with **Chats** and **You** (the
/// avatar in a gold-rimmed scalloped badge) and a 20pt unread badge, and beside it the 64pt Equal
/// FAB on the voice gradient that opens the Equal sheet.
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
                tab(.you, "You") { youBadge }
            }
            .padding(EqualSpacing.s4)
            .background(Color.white.opacity(0.16), in: Capsule())
            .background(.ultraThinMaterial, in: Capsule())
            .equalShadow(.tabbar)
            .overlay(alignment: .topLeading) {
                if unread > 0 {
                    Text(unread > 99 ? "99+" : "\(unread)")
                        .font(.equal(size: 12, weight: .bold)).foregroundStyle(Color(equalHex: 0xF7F7F7))
                        .padding(.horizontal, 6).frame(minWidth: 20, minHeight: 20)
                        .background(Capsule().fill(EqualColor.green))
                        .shadow(color: .black.opacity(0.25), radius: 2, y: 2)
                        .offset(x: 49, y: 6)
                        .accessibilityLabel("\(unread) unread")
                }
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

    /// The profile avatar inside a 26pt scalloped badge: green fill, gold gradient rim.
    private var youBadge: some View {
        ZStack {
            EqualScallopedStar(points: 12, depth: 0.9).fill(EqualColor.brandGreen)
            EqualImage.avatarMale.image.aspectRatio(contentMode: .fill).frame(width: 22, height: 26)
                .offset(y: 1)
                .mask(EqualScallopedStar(points: 12, depth: 0.9).padding(1.5))
            EqualScallopedStar(points: 12, depth: 0.9).stroke(EqualGradient.goldText, lineWidth: 1.2)
        }
        .frame(width: 26, height: 26)
    }

    private func tab<Icon: View>(_ t: Tab, _ title: String, @ViewBuilder icon: () -> Icon) -> some View {
        let on = selection == t
        return Button { selection = t } label: {
            VStack(spacing: 2) {
                icon()
                Text(title).font(.equal(size: 12, weight: on ? .semibold : .medium))
            }
            .foregroundStyle(on ? EqualColor.green : EqualColor.textSecondary)
            .padding(.horizontal, 26).padding(.vertical, 6)
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
