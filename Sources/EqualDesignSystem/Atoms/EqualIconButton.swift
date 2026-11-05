import SwiftUI

/// Circular icon-only button. **solid** 48pt closes sheets, **glass** 42pt holds the ⋯ menu,
/// **frost** 38pt closes the paywall, **tile** 52pt opens the keyboard in the composer.
public struct EqualIconButton: View {
    public enum Variant: Sendable { case solid, glass, frost, tile }

    let icon: EqualIcon
    let variant: Variant
    let label: String
    let size: CGFloat?
    let action: () -> Void

    /// - Parameter size: overrides the variant's diameter (the walkthrough speaker is a 48pt glass button).
    public init(_ icon: EqualIcon, variant: Variant = .solid, size: CGFloat? = nil, label: String, action: @escaping () -> Void = {}) {
        self.icon = icon
        self.variant = variant
        self.size = size
        self.label = label
        self.action = action
    }

    private var diameter: CGFloat {
        if let size { return size }
        switch variant { case .solid: return 48; case .glass: return 42; case .frost: return 38; case .tile: return 52 }
    }

    public var body: some View {
        Button(action: action) {
            EqualIconView(icon, size: variant == .frost ? 13 : 18, weight: .semibold)
                .foregroundStyle(variant == .tile ? EqualColor.textSecondary : (variant == .frost ? Color.black : EqualColor.textPrimary))
                .frame(width: diameter, height: diameter)
                .background { surface }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    @ViewBuilder private var surface: some View {
        switch variant {
        case .solid: Circle().fill(EqualColor.bgSurface).equalShadow(.close)
        case .glass: Circle().fill(.clear).equalGlass(Circle()).equalShadow(.glass)
        case .frost: Circle().fill(Color.white.opacity(0.7))
        case .tile: Circle().fill(EqualColor.bgSurface).equalShadow(.composer)
        }
    }
}

struct EqualIconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            EqualIconButton(.close, label: "Close")
            EqualIconButton(.more, variant: .glass, label: "More")
            EqualIconButton(.close, variant: .frost, label: "Close paywall")
            EqualIconButton(.keyboard, variant: .tile, label: "Type instead")
        }
        .padding(24)
        .equalScreenBackground()
    }
}
