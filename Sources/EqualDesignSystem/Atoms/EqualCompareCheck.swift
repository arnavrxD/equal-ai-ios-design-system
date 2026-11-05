import SwiftUI

/// "Included" mark in the compare-plans table.
public struct EqualCompareCheck: View {
    public init() {}
    public var body: some View {
        Image(systemName: "checkmark").font(.system(size: 10, weight: .bold))
            .foregroundStyle(EqualColor.successText)
            .frame(width: 20, height: 20)
            .background(Circle().fill(EqualColor.successText.opacity(0.14)))
            .accessibilityLabel("Included")
    }
}
