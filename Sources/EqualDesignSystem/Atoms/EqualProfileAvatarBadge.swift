import SwiftUI

/// The Settings profile avatar: the 3D avatar inside a gold scalloped star (active plan, free
/// trial) or a 78pt green circle (plan expired), with the head overflowing the top edge.
///
/// Figma 26242:90523 (gold, 78×88) and 26242:91747 (expired, 78×82). The badge is drawn in code
/// with `EqualScallopedStar` (17 rounded points, as in the Figma star paths); only the avatar is an image.
public struct EqualProfileAvatarBadge: View {
    public enum Style: Sendable {
        /// Back star with a 2.1pt gold outline, front star filled gold, avatar masked by the front star.
        case gold
        /// 78pt `#00B140` circle behind the avatar.
        case expired
    }

    let style: Style
    let image: EqualImage

    public init(_ style: Style = .gold, image: EqualImage = .avatarMale) {
        self.style = style
        self.image = image
    }

    // Figma geometry (points, top-left of the 78.11pt-wide group).
    private let width: CGFloat = 78.11
    private let avatarSize = CGSize(width: 61.97, height: 83.39)
    private let avatarX: CGFloat = 6.33
    /// The top of the avatar (the head) is not masked, so it pokes out of the badge.
    private let headHeight: CGFloat = 55.94

    public var body: some View {
        ZStack(alignment: .topLeading) {
            switch style {
            case .gold:
                EqualScallopedStar(points: 17, depth: 0.92)
                    .stroke(Self.outlineGradient, lineWidth: 2.1)
                    .frame(width: width - 2.1, height: width - 2.1)
                    .offset(x: 1.05, y: 9.5 + 1.05)
                EqualScallopedStar(points: 17, depth: 0.92)
                    .fill(Self.fillGradient)
                    .frame(width: 69.67, height: 69.67)
                    .offset(x: 4.22, y: 13.72)
                avatar(mask: AnyShape(EqualScallopedStar(points: 17, depth: 0.92)), maskFrame: CGRect(x: 4.22, y: 13.72, width: 69.67, height: 69.67))
            case .expired:
                Circle().fill(EqualColor.brandGreen)
                    .frame(width: width, height: width)
                    .offset(y: 3.5)
                avatar(mask: AnyShape(Circle()), maskFrame: CGRect(x: 0, y: 3.5, width: width, height: width))
            }
        }
        .frame(width: width, height: style == .gold ? 87.61 : 81.61, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    /// The avatar clipped to `mask` ∪ the head band above it.
    private func avatar(mask: AnyShape, maskFrame: CGRect) -> some View {
        image.image
            .aspectRatio(contentMode: .fill)
            .frame(width: avatarSize.width, height: avatarSize.height, alignment: .top)
            .clipped()
            .offset(x: avatarX)
            .frame(width: width, height: maskFrame.maxY, alignment: .topLeading)
            .mask(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    mask.frame(width: maskFrame.width, height: maskFrame.height).offset(x: maskFrame.minX, y: maskFrame.minY)
                    Rectangle().frame(width: width, height: headHeight)
                }
            }
    }

    /// Star 2 stroke: the #E7CA00 → #A78329 gradient as it falls across the badge (right to left).
    static let outlineGradient = LinearGradient(colors: [Color(equalHex: 0xD4B50C), Color(equalHex: 0xA78329)], startPoint: .bottomTrailing, endPoint: .leading)

    /// Star 1 fill (over #01B242): the #FFF8C7 → #CFA846 gradient as it falls across the star.
    static let fillGradient = LinearGradient(colors: [Color(equalHex: 0xF1E0A0), Color(equalHex: 0xD2AE4F)], startPoint: .leading, endPoint: .trailing)
}

struct EqualProfileAvatarBadge_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 24) {
            EqualProfileAvatarBadge(.gold)
            EqualProfileAvatarBadge(.expired)
        }
        .padding(24)
        .background(Color(equalHex: 0xFFE9A6))
    }
}
