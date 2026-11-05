import SwiftUI

/// iOS notification banner used in the trial-ending flow: black-70% glass, app icon, title, "now", body.
public struct EqualPushBanner: View {
    let title: String
    let message: String
    let time: String

    public init(_ title: String, message: String, time: String = "now") {
        self.title = title
        self.message = message
        self.time = time
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s10) {
            EqualAppIcon(size: 38)
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title).font(.equal(size: 15, weight: .semibold))
                    Spacer()
                    Text(time).font(.equal(size: 15)).foregroundStyle(Color(equalHex: 0xA0A0A0))
                }
                Text(message).font(.equal(size: 14)).foregroundStyle(EqualColor.grey13).lineLimit(2)
            }
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, EqualSpacing.s12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: EqualRadius.sheet))
        .background(Color.black.opacity(0.7), in: RoundedRectangle(cornerRadius: EqualRadius.sheet))
        .equalShadow(.push)
        .environment(\.colorScheme, .dark)
    }
}
