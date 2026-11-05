import SwiftUI

/// iOS notification banner used in the trial-ending flow: black-70% glass, the Equal app icon,
/// title, "now" (`#4D4D4D`, linear-dodge blend) and a two-line body, all in DM Sans.
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
                    Text(title).font(.equal(size: 15, weight: .semibold)).tracking(-0.23)
                    Spacer()
                    Text(time).font(.equal(size: 15)).tracking(-0.23).foregroundStyle(Color(equalHex: 0x4D4D4D)).blendMode(.plusLighter)
                }
                Text(message).font(.equal(size: 14)).tracking(-0.23).foregroundStyle(EqualColor.grey13).lineLimit(2)
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

struct EqualPushBanner_Previews: PreviewProvider {
    static var previews: some View {
        EqualPushBanner("Only 1 day left", message: "Your trial ends tomorrow. Subscribe to Gold before your assistant goes off duty.")
            .padding(24).background(Color(equalHex: 0x4E6E96))
    }
}
