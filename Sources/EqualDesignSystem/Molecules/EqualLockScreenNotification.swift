import SwiftUI

/// A light, frosted iOS lock-screen notification from Equal, used in the permission previews.
/// **large** (339×71, radius 22.7): one-line title, "now", one-line message.
/// **small** (269×78, radius 18): "Equal AI" header, a bold line and a two-line detail.
public struct EqualLockScreenNotification: View {
    public enum Size: Sendable { case large, small }

    let title: String
    let message: String
    let detail: String?
    let time: String
    let size: Size

    /// - Parameters:
    ///   - title: "Vishnu Office" (large) or "Equal AI" (small).
    ///   - message: the body line ("Called to confirm lunch plan" / "Missed call from Mom").
    ///   - detail: the small style's second, two-line body.
    public init(_ title: String = "Vishnu Office", message: String = "Called to confirm lunch plan", detail: String? = nil, time: String = "now", size: Size = .large) {
        self.title = title
        self.message = message
        self.detail = detail
        self.time = time
        self.size = size
    }

    public var body: some View {
        let large = size == .large
        let shape = RoundedRectangle(cornerRadius: large ? 22.7 : 18, style: .continuous)
        HStack(spacing: large ? 13.86 : 11) {
            icon(large ? 42 : 33)
            VStack(alignment: .leading, spacing: large ? 5.04 : 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(title).font(.equal(size: large ? 17.64 : 14, weight: .semibold)).tracking((large ? 17.64 : 14) * -0.04)
                    Spacer(minLength: 8)
                    Text(time).font(.equal(size: large ? 12.6 : 10)).tracking((large ? 12.6 : 10) * -0.04)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(message)
                        .font(.equal(size: large ? 13.76 : 10, weight: large ? .medium : .semibold))
                        .tracking((large ? 13.76 : 10) * -0.04)
                    if let detail, !large {
                        Text(detail).font(.equal(size: 8)).tracking(-0.32).lineLimit(2)
                            .padding(.trailing, 31)
                    }
                }
            }
            .lineLimit(1)
            .foregroundStyle(Color.black)
        }
        .padding(.horizontal, large ? 18.9 : 15)
        .padding(.vertical, large ? 12.6 : 10)
        .frame(width: large ? 339 : 269, height: large ? 71 : 78)
        .background(Color.white.opacity(0.5), in: shape)
        .background(.ultraThinMaterial, in: shape)
        .clipShape(shape)
        .accessibilityElement(children: .combine)
    }

    private func icon(_ side: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: side * 0.2583, style: .continuous)
            .fill(EqualColor.brandGreen)
            .overlay(EqualMark(size: side * 0.524, color: .white))
            .frame(width: side, height: side)
            .accessibilityHidden(true)
    }
}

struct EqualLockScreenNotification_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualLockScreenNotification()
            EqualLockScreenNotification("Equal AI", message: "Missed call from Mom", detail: "Mom said she’d be late getting home and asked you to call her back when free.", size: .small)
        }
        .padding(24)
        .background(Color(equalHex: 0x4E6E96))
    }
}
