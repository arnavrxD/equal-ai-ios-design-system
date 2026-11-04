import SwiftUI

/// Round caller avatar (56pt in the chat list, 18pt inside contact chips). Saved contacts show
/// initials on mint with a person badge; businesses show a 3D category illustration on a tint;
/// Equal itself is the six-dot mark on the voice gradient.
public struct EqualAvatar: View {
    public enum Content: Sendable {
        case initials(String)
        case illustration(EqualImage)
        case equal
    }

    public enum Tint: Sendable {
        case mint, finance, ride, career, peach, others, unknown
        var color: Color {
            switch self {
            case .mint: EqualColor.avatarMint
            case .finance: EqualColor.avatarFinance
            case .ride: EqualColor.avatarRide
            case .career: EqualColor.avatarCareer
            case .peach: EqualColor.avatarPeach
            case .others: EqualColor.avatarOthers
            case .unknown: EqualColor.avatarUnknown
            }
        }
    }

    let content: Content
    let size: CGFloat
    let tint: Tint
    let isContact: Bool

    public init(_ content: Content, size: CGFloat = 56, tint: Tint = .mint, isContact: Bool = false) {
        self.content = content
        self.size = size
        self.tint = tint
        self.isContact = isContact
    }

    public var body: some View {
        ZStack {
            switch content {
            case .initials(let s):
                Circle().fill(tint.color)
                Text(s).font(.equal(size: size * 0.43, weight: .semibold)).foregroundStyle(Color.black.opacity(0.6))
            case .illustration(let img):
                Circle().fill(tint.color)
                img.image.aspectRatio(contentMode: .fit).frame(width: size * 0.78, height: size * 0.78)
            case .equal:
                Circle().fill(EqualGradient.voice)
                EqualMark(size: size * 0.5, color: .white)
            }
        }
        .frame(width: size, height: size)
        .overlay(alignment: .bottomTrailing) {
            if isContact {
                Image(systemName: "person.fill").font(.system(size: 9, weight: .bold))
                    .foregroundStyle(EqualColor.textPrimary)
                    .frame(width: 18, height: 18)
                    .background(Circle().fill(EqualColor.bgPrimary))
                    .offset(x: 2, y: 2)
            }
        }
        .accessibilityHidden(true)
    }
}

struct EqualAvatar_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            EqualAvatar(.initials("AN"), isContact: true)
            EqualAvatar(.illustration(.categoryFinance), tint: .finance)
            EqualAvatar(.illustration(.categoryRide), tint: .ride)
            EqualAvatar(.illustration(.categoryDelivery), tint: .peach)
            EqualAvatar(.equal)
        }
        .padding(24)
        .equalScreenBackground()
    }
}
