import SwiftUI

/// Header pill showing whether the assistant is answering: green dot + "Available" (or grey
/// "Busy"). **glass** is the white-30% liquid-glass pill with a caret; **plain** is white with a
/// `#BFE8CC` stroke, `#111111` text and no caret (home after an upgrade).
/// Sizes: **regular** 36pt, Regular 15; **compact** 31pt, Medium 14.
public struct EqualAvailabilityPill: View {
    public enum Size: Sendable {
        /// 36pt tall, DM Sans Regular 15 (most homes).
        case regular
        /// 31pt tall, DM Sans Medium 14 (home with the permission card).
        case compact
    }

    public enum Style: Sendable {
        /// White 30% glass, `#000@5%` hairline, caret.
        case glass
        /// Solid white, `#BFE8CC` stroke, no caret.
        case plain
    }

    let isAvailable: Bool
    let size: Size
    let style: Style
    let action: () -> Void

    public init(isAvailable: Bool = true, size: Size = .regular, style: Style = .glass, action: @escaping () -> Void = {}) {
        self.isAvailable = isAvailable
        self.size = size
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                Circle().fill(isAvailable ? EqualColor.green : EqualColor.grey09).frame(width: 8, height: 8)
                Text(isAvailable ? "Available" : "Busy")
                    .font(.equal(size: size == .regular ? 15 : 14, weight: size == .regular ? .regular : .medium))
                    .tracking(size == .regular ? -0.39 : -0.42)
                    .foregroundStyle(style == .plain ? Color(equalHex: 0x111111) : (isAvailable ? EqualColor.green : EqualColor.textSecondary))
                    .padding(.leading, style == .plain ? 8 : 4)
                if style == .glass {
                    Image(systemName: "chevron.down")
                        .font(.system(size: size == .regular ? 12 : 11, weight: .semibold))
                        .foregroundStyle(Color(equalHex: 0x555555))
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal, EqualSpacing.s16)
            .frame(height: style == .plain ? 37 : (size == .regular ? 36 : 31))
            .background { surface }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isAvailable ? "Assistant available" : "Assistant busy")
    }

    @ViewBuilder private var surface: some View {
        switch style {
        case .glass:
            Capsule().fill(Color.white.opacity(0.3))
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(Capsule().stroke(Color.black.opacity(0.05), lineWidth: 1))
                .shadow(color: .black.opacity(0.08), radius: 1.5, y: 0.74)
        case .plain:
            Capsule().fill(Color.white)
                .overlay(Capsule().strokeBorder(Color(equalHex: 0xBFE8CC), lineWidth: 1.5))
        }
    }
}

struct EqualAvailabilityPill_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            EqualAvailabilityPill()
            EqualAvailabilityPill(size: .compact)
            EqualAvailabilityPill(style: .plain)
            EqualAvailabilityPill(isAvailable: false)
        }
        .padding(24)
        .equalScreenBackground()
    }
}
