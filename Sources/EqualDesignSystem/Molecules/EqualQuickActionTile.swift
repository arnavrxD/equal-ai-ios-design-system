import SwiftUI

/// Shortcut tile. **round** (72pt white circle, green glyph, 12pt label): Message, Discover,
/// Call, Tell Equal. **square** (104×100): Talk to Equal, Set Instruction, Make a Call.
public struct EqualQuickActionTile: View {
    public enum Style: Sendable { case round, square }
    public enum Glyph: Sendable { case icon(EqualIcon), equalMark }

    let title: String
    let glyph: Glyph
    let style: Style
    let action: () -> Void

    public init(_ title: String, glyph: Glyph, style: Style = .round, action: @escaping () -> Void = {}) {
        self.title = title
        self.glyph = glyph
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: style == .round ? 10 : 12) {
                glyphView
                    .frame(width: style == .round ? 72 : nil, height: style == .round ? 72 : nil)
                    .background { if style == .round { Circle().fill(EqualColor.bgSurface).equalShadow(.tile) } }
                Text(title).font(.equal(size: style == .round ? 12 : 11)).foregroundStyle(EqualColor.textPrimary)
            }
            .frame(width: style == .round ? 77 : 104, height: style == .round ? nil : 100)
            .background {
                if style == .square {
                    RoundedRectangle(cornerRadius: EqualRadius.m).fill(EqualColor.bgSurface)
                        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(EqualColor.strokeMedium, lineWidth: 1))
                        .equalShadow(.card)
                }
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var glyphView: some View {
        switch glyph {
        case .icon(let i): EqualIconView(i, size: style == .round ? 30 : 26, weight: .regular).foregroundStyle(EqualColor.green)
        case .equalMark: EqualMark(size: 30)
        }
    }
}

struct EqualQuickActionTile_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                EqualQuickActionTile("Message", glyph: .icon(.messageFill))
                EqualQuickActionTile("Discover", glyph: .icon(.compass))
                EqualQuickActionTile("Call", glyph: .icon(.phone))
                EqualQuickActionTile("Tell Equal", glyph: .icon(.mic))
            }
            HStack(spacing: 12) {
                EqualQuickActionTile("Talk to Equal", glyph: .equalMark, style: .square)
                EqualQuickActionTile("Set Instruction", glyph: .icon(.wand), style: .square)
                EqualQuickActionTile("Make a Call", glyph: .icon(.phone), style: .square)
            }
        }
        .padding(24)
        .equalScreenBackground()
    }
}
