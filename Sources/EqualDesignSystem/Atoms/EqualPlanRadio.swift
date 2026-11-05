import SwiftUI

/// Plan selector radio: a gold-grey ring, or filled green with a white check when selected.
public struct EqualPlanRadio: View {
    let isSelected: Bool
    public init(isSelected: Bool) { self.isSelected = isSelected }
    public var body: some View {
        ZStack {
            if isSelected {
                Circle().fill(EqualColor.green)
                Image(systemName: "checkmark").font(.system(size: 10, weight: .heavy)).foregroundStyle(.white)
            } else {
                Circle().stroke(EqualColor.goldRadio, lineWidth: 1.5)
            }
        }
        .frame(width: 20, height: 20)
        .accessibilityHidden(true)
    }
}
