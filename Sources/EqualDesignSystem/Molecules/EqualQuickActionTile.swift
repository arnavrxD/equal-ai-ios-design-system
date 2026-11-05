import SwiftUI

/// Shortcut tile. **round** (72pt white circle, green glyph, 12pt label): Message, Discover,
/// Call, Tell Equal. **square** (108×98 white card, radius 16, no stroke, soft 16% shadow,
/// 36pt green glyph, 11pt black label): Talk to Equal, Set Instruction, Make a Call.
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
            if style == .round {
                VStack(spacing: 10) {
                    glyphView
                        .frame(width: 72, height: 72)
                        .background { Circle().fill(EqualColor.bgSurface).equalShadow(.tile) }
                    Text(title).font(.equal(size: 12)).foregroundStyle(EqualColor.textPrimary)
                }
                .frame(width: 77)
            } else {
                VStack(spacing: 12) {
                    glyphView.frame(width: 36, height: 36)
                    Text(title).font(.equal(size: 11)).tracking(-0.29).foregroundStyle(Color.black).lineLimit(1)
                }
                .padding(.vertical, 9)
                .padding(.horizontal, 6)
                .frame(minWidth: 98, idealWidth: 108, maxWidth: 108)
                .frame(height: 98)
                .background {
                    RoundedRectangle(cornerRadius: EqualRadius.m).fill(Color.white)
                        .shadow(color: .black.opacity(0.16), radius: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var glyphView: some View {
        switch glyph {
        case .icon(let i): EqualIconView(i, size: 30, weight: style == .round ? .regular : .medium).foregroundStyle(EqualColor.green)
        case .equalMark: EqualMark(size: style == .round ? 30 : 32)
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
