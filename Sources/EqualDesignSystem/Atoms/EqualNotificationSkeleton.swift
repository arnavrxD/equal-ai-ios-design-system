import SwiftUI

/// A placeholder lock-screen notification (245×52, radius 16.4): frosted white-50% card with a
/// grey icon square and three bars. Stacked under a real notification in the permission preview.
public struct EqualNotificationSkeleton: View {
    public enum Emphasis: Sendable {
        /// Full opacity (first skeleton).
        case primary
        /// 50% layer opacity (second skeleton).
        case faded
    }

    let emphasis: Emphasis

    public init(_ emphasis: Emphasis = .primary) { self.emphasis = emphasis }

    public var body: some View {
        let shape = RoundedRectangle(cornerRadius: 16.4, style: .continuous)
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8).fill(Color(equalHex: 0xCCCCCC))
                .frame(width: 36, height: 36).offset(x: 13, y: 8)
            Capsule().fill(Color(equalHex: 0xCCCDC8)).frame(width: 116, height: 10).offset(x: 58, y: 14)
            Capsule().fill(Color(equalHex: 0xCCCDC8)).frame(width: 28, height: 10).offset(x: 201, y: 14)
            Capsule().fill(Color(equalHex: 0xD9D9D9)).frame(width: 161, height: 4).offset(x: 58, y: 33)
        }
        .frame(width: 245, height: 52, alignment: .topLeading)
        .background(Color.white.opacity(0.5), in: shape)
        .background(.ultraThinMaterial, in: shape)
        .clipShape(shape)
        .opacity(emphasis == .faded ? 0.5 : 1)
        .accessibilityHidden(true)
    }
}

struct EqualNotificationSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 21) { EqualNotificationSkeleton(); EqualNotificationSkeleton(.faded) }
            .padding(24)
            .background(LinearGradient(colors: [Color(equalHex: 0x6C8FB8), .white], startPoint: .top, endPoint: .bottom))
    }
}
