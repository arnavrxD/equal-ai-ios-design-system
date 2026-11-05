import SwiftUI

/// "On day 7 we'll ask if you want to keep Gold at ₹249/month." The free-week terms block with
/// the crowned mascot, as a white **card** (mascot cropped bottom-right) or **stacked** and centred
/// (mascot on top; the dark soft paywall uses this with lime accent).
public struct EqualTrialInfoCard: View {
    public enum Style: Sendable {
        /// 345×139 white card, radius 16, mascot 128 bleeding off the bottom-right over a green disc.
        case card
        /// 240 wide, centred: mascot 160, then the text centred.
        case stacked
    }

    let style: Style
    let day: Int
    let price: String
    let message: String

    public init(_ style: Style = .card, day: Int = 7, price: String = "₹249/month", message: String = "If you don’t, your assistant stops answering. No charge.") {
        self.style = style
        self.day = day
        self.price = price
        self.message = message
    }

    private var title: Text {
        Text("On day \(day) we’ll ask if you want to keep Gold at ")
            + Text("\(price).").font(.equal(size: 18, weight: .semibold)).foregroundStyle(EqualColor.textAction)
    }

    public var body: some View {
        switch style {
        case .card:
            VStack(alignment: .leading, spacing: 11) {
                title.equalTextStyle(.headline).foregroundStyle(EqualColor.textPrimary)
                    .frame(maxWidth: 239, alignment: .leading)
                Text(message).equalTextStyle(.footnote).foregroundStyle(EqualColor.textSecondary)
                    .frame(maxWidth: 191, alignment: .leading)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, EqualSpacing.s24)
            .padding(.horizontal, EqualSpacing.s16)
            .frame(maxWidth: .infinity, minHeight: 139, alignment: .leading)
            .background(alignment: .topTrailing) {
                // Figma: disc 161 at x 246, mascot 128 at (239, 50) on a 345-wide card.
                ZStack(alignment: .topLeading) {
                    Circle().fill(EqualColor.green.opacity(0.12)).frame(width: 161, height: 161).offset(x: 7, y: 52)
                    FramedArt.mascotCrown(128).offset(y: 50)
                }
                .frame(width: 106, height: 139, alignment: .topLeading)
            }
            .background(EqualColor.bgSurface)
            .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        case .stacked:
            VStack(spacing: 0) {
                FramedArt.mascotCrown(160)
                VStack(spacing: 11) {
                    title.equalTextStyle(.headline).foregroundStyle(EqualColor.textPrimary)
                    Text(message).equalTextStyle(.footnote).foregroundStyle(EqualColor.textSecondary)
                        .frame(maxWidth: 191)
                }
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 240)
        }
    }
}

/// A trimmed bundled render drawn the way Figma frames the untrimmed export: the visible art takes
/// `fraction` of the `size` frame (e.g. mascot-crown fills 76% of its frame), nudged by `offset`.
struct FramedArt: View {
    let image: EqualImage
    let size: CGFloat
    let fraction: CGFloat
    var offset: CGSize = .zero

    static func mascotCrown(_ size: CGFloat) -> FramedArt { FramedArt(image: .mascotCrown, size: size, fraction: 0.76, offset: CGSize(width: 0, height: -0.04 * size)) }

    var body: some View {
        EqualIllustration(image, size: size * fraction)
            .offset(offset)
            .frame(width: size, height: size)
    }
}

struct EqualTrialInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        EqualPreviewPair {
            VStack(spacing: 24) {
                EqualTrialInfoCard(.card)
                EqualTrialInfoCard(.stacked)
            }
        }
    }
}
