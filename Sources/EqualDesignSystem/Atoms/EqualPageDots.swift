import SwiftUI

/// Carousel position: active dot 12pt green-30%, others 8pt grey-30%.
public struct EqualPageDots: View {
    let count: Int
    let active: Int
    let activeColor: Color
    let inactiveColor: Color

    /// - Parameters:
    ///   - activeColor / inactiveColor: the limit paywalls use `#B2E8C6` / `#E3E3E3`.
    public init(count: Int, active: Int, activeColor: Color = EqualColor.green.opacity(0.3), inactiveColor: Color = Color(equalHex: 0xA1A1A1, alpha: 0.3)) {
        self.count = count; self.active = active; self.activeColor = activeColor; self.inactiveColor = inactiveColor
    }
    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(i == active ? activeColor : inactiveColor)
                    .frame(width: i == active ? 12 : 8, height: i == active ? 12 : 8)
            }
        }
        .accessibilityLabel("Page \(active + 1) of \(count)")
    }
}
