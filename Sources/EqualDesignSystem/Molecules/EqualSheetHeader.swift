import SwiftUI

/// Top of the Equal action sheet: grab handle, Equal dot, current task and a close button.
public struct EqualSheetHeader: View {
    let title: String
    let onClose: () -> Void
    public init(_ title: String = "Make a call", onClose: @escaping () -> Void = {}) { self.title = title; self.onClose = onClose }
    public var body: some View {
        HStack(spacing: EqualSpacing.s12) {
            EqualAvatar(.equal, size: 28)
            Text(title).equalTextStyle(.body).foregroundStyle(EqualColor.textPrimary)
            Spacer()
            EqualIconButton(.close, label: "Close", action: onClose)
        }
        .padding(EqualSpacing.s24)
        .background(EqualColor.bgSurface)
        .overlay(alignment: .top) { Capsule().fill(Color(equalHex: 0xADADAD)).frame(width: 89, height: 7).padding(.top, 8) }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
        .shadow(color: Color(equalHex: 0x191919, alpha: 0.08), radius: 8, y: 4)
    }
}
