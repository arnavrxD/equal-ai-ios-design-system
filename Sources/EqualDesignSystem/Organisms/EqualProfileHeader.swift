import SwiftUI

/// Top of Settings: gold radial wash (green when the plan expired), 3D avatar, name and number.
public struct EqualProfileHeader: View {
    let name: String
    let phone: String
    let isExpired: Bool
    let onBack: (() -> Void)?

    public init(name: String = "Keshav", phone: String = "+91 98789 56749", isExpired: Bool = false, onBack: (() -> Void)? = nil) {
        self.name = name
        self.phone = phone
        self.isExpired = isExpired
        self.onBack = onBack
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            if let onBack {
                Button(action: onBack) {
                    Label("Settings", systemImage: "chevron.left").font(.equal(size: 15)).foregroundStyle(EqualColor.grey01)
                }
                .buttonStyle(.plain)
            }
            HStack(spacing: 13) {
                EqualIllustration(.avatarMale, size: 70)
                VStack(alignment: .leading, spacing: -2) {
                    Text(name).font(.equal(size: 28.4, weight: .heavy)).tracking(-0.85).foregroundStyle(Color.black)
                    Text(phone).font(.equal(size: 17.5, weight: .medium)).tracking(-0.5).foregroundStyle(Color(equalHex: 0x1E1E1E))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 24)
        .padding(.bottom, EqualSpacing.s24)
        .background(
            RadialGradient(colors: isExpired ? [Color(equalHex: 0xC9F7D3), Color(equalHex: 0xECFDF0), .white] : [Color(equalHex: 0xFFE48A), Color(equalHex: 0xFFF6D6), .white],
                           center: UnitPoint(x: 0.3, y: 0), startRadius: 0, endRadius: 420)
        )
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 22, bottomTrailingRadius: 22))
    }
}
