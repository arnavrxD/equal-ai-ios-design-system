import SwiftUI

/// Top of Settings: a 283pt white block with a 557pt gradient ellipse (white → gold, or mint when
/// the plan expired), an optional "←  Settings" back row, the avatar badge, name and number.
///
/// Figma 26242:90520. The header is laid out for the top of the screen (the status bar sits over
/// its first 54pt), so place it edge to edge and let it ignore the top safe area. The membership
/// card overlaps it from y 200; `SettingsScreen` composes the two.
public struct EqualProfileHeader: View {
    let name: String
    let phone: String
    let isExpired: Bool
    let avatar: EqualImage
    let onBack: (() -> Void)?

    /// - Parameters:
    ///   - isExpired: mint wash and the green-circle avatar instead of gold.
    ///   - onBack: shows the "←  Settings" row (free trial and expired states).
    public init(name: String = "Keshav", phone: String = "+91 98789 56749", isExpired: Bool = false, avatar: EqualImage = .avatarMale, onBack: (() -> Void)? = nil) {
        self.name = name
        self.phone = phone
        self.isExpired = isExpired
        self.avatar = avatar
        self.onBack = onBack
    }

    /// Height of the white block in Figma.
    public static let height: CGFloat = 282.68

    public var body: some View {
        Color.white.overlay(alignment: .topLeading) { ZStack(alignment: .topLeading) {
            wash
                .frame(width: 556.63, height: 556.63)
                .offset(x: -81.81, y: -253.08)
            if let onBack {
                Button(action: onBack) {
                    Text("←  Settings")
                        .font(.equal(size: 20, weight: .medium)).tracking(-0.6)
                        .foregroundStyle(Color(equalHex: 0x1E1E1E))
                        .frame(height: 26)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back to Settings")
                .offset(x: 17.46, y: 62.66 - 13)
            }
            HStack(spacing: 13.1) {
                EqualProfileAvatarBadge(isExpired ? .expired : .gold, image: avatar)
                VStack(alignment: .leading, spacing: -2.18) {
                    Text(name)
                        .font(.equal(size: 28.38, weight: .heavy)).tracking(-0.85)
                        .foregroundStyle(Color.black)
                        .shadow(color: .black.opacity(0.2), radius: 38, y: 15)
                    Text(phone)
                        .font(.equal(size: 17.46, weight: .medium)).tracking(-0.52)
                        .foregroundStyle(Color(equalHex: 0x1E1E1E))
                }
                .lineLimit(1)
                .fixedSize()
            }
            .offset(x: 26.19, y: 97.68)
        } }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: Self.height, alignment: .top)
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 21.83, bottomTrailingRadius: 21.83))
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder private var wash: some View {
        if isExpired {
            // Second fill (#F1FFF5 → #CEFFDB, top to bottom) covers the gold one.
            Circle().fill(LinearGradient(colors: [Color(equalHex: 0xF1FFF5), Color(equalHex: 0xCEFFDB)], startPoint: .top, endPoint: .bottom))
        } else {
            // White from the screen top (45.5% down the ellipse) to #FFC927 at its bottom.
            Circle().fill(LinearGradient(stops: [
                .init(color: .white, location: 0.4547),
                .init(color: Color(equalHex: 0xFFC927), location: 1)
            ], startPoint: .top, endPoint: .bottom))
        }
    }
}

struct EqualProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualProfileHeader()
            EqualProfileHeader(onBack: {})
            EqualProfileHeader(isExpired: true, onBack: {})
        }
        .frame(width: 393)
        .equalScreenBackground()
    }
}
