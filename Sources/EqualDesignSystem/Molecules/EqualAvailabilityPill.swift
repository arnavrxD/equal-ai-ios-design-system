import SwiftUI

/// Header pill showing whether the assistant is answering: glass, green dot + "Available", caret.
public struct EqualAvailabilityPill: View {
    let isAvailable: Bool
    let action: () -> Void
    public init(isAvailable: Bool = true, action: @escaping () -> Void = {}) { self.isAvailable = isAvailable; self.action = action }
    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s8) {
                Circle().frame(width: 7, height: 7)
                Text(isAvailable ? "Available" : "Busy").font(.equal(size: 15))
                EqualIconView(.chevronDown, size: 11, weight: .bold)
            }
            .foregroundStyle(isAvailable ? EqualColor.green : EqualColor.textSecondary)
            .padding(.horizontal, EqualSpacing.s16).frame(height: 36)
            .equalGlass(Capsule())
        }
        .buttonStyle(.plain)
    }
}
