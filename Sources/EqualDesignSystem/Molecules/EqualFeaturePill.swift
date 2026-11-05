import SwiftUI

/// 52pt glassy gold pill naming one Gold feature: a 36pt 3D icon and a two-line SemiBold 14 label.
/// Laid out in a horizontal row (gap 20) on the expired page and the compact paywall.
public struct EqualFeaturePill: View {
    let title: String
    let art: [EqualImage]

    /// - Parameter art: one image, or a composite: a device plus a badge (2), or three letters (3).
    public init(_ title: String, art: [EqualImage]) {
        self.title = title
        self.art = art
    }

    /// "Handles Calls From Contacts" with the contacts book.
    public static var contacts: EqualFeaturePill { EqualFeaturePill("Handles Calls From Contacts", art: [.contactsBook]) }
    /// "Smart Call Screening": black iPhone with a green check.
    public static var screening: EqualFeaturePill { EqualFeaturePill("Smart Call Screening", art: [.iphoneBlack, .checkGreen3d]) }
    /// "10+ Assistant Languages": A / अ / అ.
    public static var languages: EqualFeaturePill { EqualFeaturePill("10+ Assistant Languages", art: [.letterAEnglish, .letterAHindi, .letterATelugu]) }
    /// "4+ Assistant Voices": retro microphone.
    public static var voices: EqualFeaturePill { EqualFeaturePill("4+ Assistant Voices", art: [.microphoneRetro]) }

    public var body: some View {
        HStack(spacing: EqualSpacing.s12) {
            icon.frame(width: 36, height: 36)
            Text(title)
                .font(.equal(size: 14, weight: .semibold))
                .foregroundStyle(EqualColor.grey06)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 109, alignment: .leading)
        }
        .padding(.horizontal, 17)
        .padding(.vertical, EqualSpacing.s8)
        .frame(height: 52)
        .background {
            let shape = RoundedRectangle(cornerRadius: 18)
            ZStack {
                shape.fill(.ultraThinMaterial)
                shape.fill(Color.white.opacity(0.6))
                shape.fill(LinearGradient(stops: [
                    .init(color: Color(equalHex: 0xFFD94F), location: 0),
                    .init(color: Color.white.opacity(0.1), location: 0.53),
                    .init(color: Color(equalHex: 0xFFD94F), location: 0.95)
                ], startPoint: .leading, endPoint: .trailing)).opacity(0.4)
            }
            .shadow(color: .black.opacity(0.25), radius: 1)
        }
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder private var icon: some View {
        switch art.count {
        case 0: EmptyView()
        case 1: EqualIllustration(art[0], size: 36)
        case 2:
            ZStack(alignment: .bottomTrailing) {
                EqualIllustration(art[0], size: 36)
                EqualIllustration(art[1], size: 17).offset(x: 2, y: 1)
            }
        default:
            ZStack {
                EqualIllustration(art[0], size: 20).offset(x: -9, y: -7)
                EqualIllustration(art[1], size: 20).offset(x: 9, y: -7)
                EqualIllustration(art[2], size: 20).offset(x: 0, y: 9)
            }
        }
    }
}

struct EqualFeaturePill_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) { EqualFeaturePill.contacts; EqualFeaturePill.screening }
            .padding(24).background(Color.white)
    }
}
