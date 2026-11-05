import SwiftUI

/// The sheet the Equal FAB opens (`#F7F7F7`, 28pt top corners): grab handle, the lime-to-green
/// Equal disc, a greeting with the user's name in green, three square shortcuts, suggestion chips
/// from recent calls and the composer. Spacing top to bottom: 12 / 22 / 30 / 40.
public struct EqualSheet: View {
    let name: String
    let greeting: String
    let suggestions: [EqualChatAction]
    let onShortcut: (Int) -> Void
    let onSuggestion: (EqualChatAction) -> Void
    @State private var text = ""

    /// The suggestions in the Figma sheet.
    public static let defaultSuggestions: [EqualChatAction] = [
        EqualChatAction("Reply Amit on WhatsApp", emoji: "🗓️"),
        EqualChatAction("Set reminder for Dr. Mehta’s clinic", emoji: "🔔"),
        EqualChatAction("Add new instruction", emoji: "📝")
    ]

    /// - Parameters:
    ///   - greeting: "Good morning, " (the name follows in green).
    ///   - onShortcut: 0 Talk to Equal, 1 Set Instruction, 2 Make a Call.
    public init(name: String = "Keshav", greeting: String = "Good morning, ", suggestions: [EqualChatAction] = EqualSheet.defaultSuggestions,
                onShortcut: @escaping (Int) -> Void = { _ in }, onSuggestion: @escaping (EqualChatAction) -> Void = { _ in }) {
        self.name = name
        self.greeting = greeting
        self.suggestions = suggestions
        self.onShortcut = onShortcut
        self.onSuggestion = onSuggestion
    }

    public var body: some View {
        VStack(spacing: 0) {
            Capsule().fill(Color(equalHex: 0xADADAD)).frame(width: 89, height: 7).padding(.top, 10)
            EqualMark(size: 32, color: Color(equalHex: 0xF7F7F7))
                .frame(width: 64, height: 64)
                .background(Circle().fill(LinearGradient(colors: [EqualColor.brandLime, EqualColor.brandGreen], startPoint: .top, endPoint: .bottom)))
                .background(Circle().fill(Color.black.opacity(0.16)).padding(-2).blur(radius: 2))
                .padding(.top, 14)
            VStack(spacing: 4) {
                (Text(greeting) + Text(name).foregroundColor(EqualColor.green))
                    .font(.equal(size: 22, weight: .bold)).tracking(-0.57)
                    .foregroundStyle(Color(equalHex: 0x111111))
                Text("What can I help you with today?").font(.equal(size: 15)).tracking(-0.39)
                    .foregroundStyle(Color(equalHex: 0x555555))
            }
            .multilineTextAlignment(.center)
            .padding(.top, 12)
            HStack(spacing: EqualSpacing.s12) {
                EqualQuickActionTile("Talk to Equal", glyph: .equalMark, style: .square) { onShortcut(0) }
                EqualQuickActionTile("Set Instruction", glyph: .icon(.wand), style: .square) { onShortcut(1) }
                EqualQuickActionTile("Make a Call", glyph: .icon(.phone), style: .square) { onShortcut(2) }
            }
            .padding(.horizontal, EqualSpacing.s24)
            .padding(.top, 22)
            EqualScrollContent(.horizontal) {
                HStack(spacing: EqualSpacing.s16) {
                    ForEach(suggestions) { s in EqualSheetChip(s.title, emoji: s.emoji) { onSuggestion(s) } }
                }
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.vertical, 2)
            }
            .padding(.top, 28)
            EqualComposer(text: $text)
                .padding(.horizontal, EqualSpacing.s24)
                .padding(.top, 38)
                .padding(.bottom, EqualSpacing.s32)
        }
        .frame(maxWidth: .infinity)
        .background(Color(equalHex: 0xF7F7F7))
        .overlay(alignment: .top) {
            UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl)
                .strokeBorder(Color.black.opacity(0.08), lineWidth: 1)
                .mask(LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .init(x: 0.5, y: 0.08)))
        }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
        .shadow(color: .black.opacity(0.12), radius: 4, y: -6)
        .environment(\.colorScheme, .light)
    }
}

/// Suggestion and contact chip inside the Equal sheets: 44pt, `#F7F7F7` with the lime gradient
/// at 18%, `#00B140@36%` stroke. Text chips are Regular 16; chips with a leading avatar are Medium 14.
struct EqualSheetChip<Leading: View>: View {
    let title: String
    let emoji: String?
    let leading: Leading?
    let action: () -> Void

    init(_ title: String, emoji: String? = nil, action: @escaping () -> Void = {}) where Leading == EmptyView {
        self.title = title; self.emoji = emoji; self.leading = nil; self.action = action
    }

    init(_ title: String, @ViewBuilder leading: () -> Leading, action: @escaping () -> Void = {}) {
        self.title = title; self.emoji = nil; self.leading = leading(); self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s8) {
                if let leading { leading }
                if let emoji { Text(emoji).font(.equal(size: isContactStyle ? 14 : 16)) }
                Text(title)
                    .font(.equal(size: isContactStyle ? 14 : 16, weight: isContactStyle ? .medium : .regular))
                    .tracking(isContactStyle ? 0 : -0.42)
                    .foregroundStyle(Color(equalHex: 0x111111))
            }
            .lineLimit(1)
            .padding(.horizontal, EqualSpacing.s16)
            .frame(height: 44)
            .background {
                ZStack {
                    Capsule().fill(Color(equalHex: 0xF7F7F7))
                    Capsule().fill(EqualGradient.chipSuggested).opacity(0.18)
                }
            }
            .overlay(Capsule().stroke(EqualColor.brandGreen.opacity(0.36), lineWidth: 1))
            .shadow(color: .black.opacity(0.25), radius: 0.5)
        }
        .buttonStyle(.plain)
    }

    /// Contact chips (avatar or ➕) use Medium 14.
    private var isContactStyle: Bool { leading != nil || emoji == "➕" }
}

struct EqualSheet_Previews: PreviewProvider {
    static var previews: some View {
        EqualSheet().background(EqualColor.bgOverlay)
    }
}
