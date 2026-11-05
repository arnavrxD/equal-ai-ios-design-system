import SwiftUI

/// Carousel position: active dot 12pt green-30%, others 8pt grey-30%.
public struct EqualPageDots: View {
    let count: Int
    let active: Int
    public init(count: Int, active: Int) { self.count = count; self.active = active }
    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(i == active ? EqualColor.green.opacity(0.3) : Color(equalHex: 0xA1A1A1, alpha: 0.3))
                    .frame(width: i == active ? 12 : 8, height: i == active ? 12 : 8)
            }
        }
        .accessibilityLabel("Page \(active + 1) of \(count)")
    }
}
