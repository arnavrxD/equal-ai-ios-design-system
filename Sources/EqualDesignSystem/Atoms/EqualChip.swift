import SwiftUI

/// Post-call action chip ("Call back ›", "Add to Calendar ›"). **suggested** marks actions on unread
/// conversations (lime gradient + green stroke); **neutral** is for read ones.
public struct EqualChip: View {
    public enum Variant: Sendable { case suggested, neutral }

    let title: String
    let variant: Variant
    let emoji: String?
    let icon: EqualIcon?
    let showsChevron: Bool
    let tall: Bool
    let leading: AnyView?
    let action: () -> Void

    public init(_ title: String, variant: Variant = .neutral, emoji: String? = nil, icon: EqualIcon? = nil, showsChevron: Bool = true, tall: Bool = false, action: @escaping () -> Void = {}) {
        self.title = title
        self.variant = variant
        self.emoji = emoji
        self.icon = icon
        self.showsChevron = showsChevron
        self.tall = tall
        self.leading = nil
        self.action = action
    }

    /// A contact chip with an avatar leading the name.
    public init<Leading: View>(_ title: String, variant: Variant = .suggested, @ViewBuilder leading: () -> Leading, action: @escaping () -> Void = {}) {
        self.title = title
        self.variant = variant
        self.emoji = nil
        self.icon = nil
        self.showsChevron = false
        self.tall = true
        self.leading = AnyView(leading())
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s8) {
                if let leading { leading }
                if let emoji { Text(emoji).font(.system(size: 15)) }
                if let icon { EqualIconView(icon, size: 14, weight: .semibold) }
                Text(title)
                    .font(.equal(size: leading == nil ? 16 : 14, weight: leading == nil ? .regular : .medium))
                    .tracking(-0.4)
                if showsChevron { EqualIconView(.chevronRight, size: 11, weight: .semibold) }
            }
            .foregroundStyle(EqualColor.textPrimary)
            .lineLimit(1)
            .padding(.horizontal, EqualSpacing.s16)
            .frame(height: tall ? 44 : 37)
            .background(Capsule().fill(variant == .suggested ? EqualGradient.chipSuggested : EqualGradient.chipNeutral))
            .overlay(Capsule().stroke(variant == .suggested ? EqualColor.unreadStroke : EqualColor.strokeMedium, lineWidth: 1))
            .equalShadow(.chip)
        }
        .buttonStyle(.plain)
    }
}

struct EqualChip_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { EqualChip("Call back", variant: .suggested, emoji: "📞"); EqualChip("Add to Calendar", variant: .suggested, emoji: "🗓️") }
            HStack { EqualChip("Update address", emoji: "✏️"); EqualChip("Mute", emoji: "🔕") }
            HStack {
                EqualChip("Amit Nanda") { EqualAvatar(.initials("AN"), size: 18) }
                EqualChip("Other", variant: .suggested, icon: .plus, showsChevron: false, tall: true)
            }
        }
        .padding(24)
        .equalScreenBackground()
    }
}
