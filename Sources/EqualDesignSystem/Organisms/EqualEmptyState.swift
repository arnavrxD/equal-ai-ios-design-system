import SwiftUI

/// Home before any calls: the mascot on a phone with green sparkles and a ground shadow,
/// "Your chats will appear here", one line inviting a demo, and an optional green
/// "Meet Your Assistant" call button.
public struct EqualEmptyState: View {
    let title: String
    let message: String
    let actionTitle: String?
    let illustrationSize: CGFloat
    let action: () -> Void

    /// - Parameters:
    ///   - actionTitle: shows the 44pt green phone button ("Meet Your Assistant") 18pt below the text; nil hides it.
    ///   - illustrationSize: 160 by default; 117 when a second promo card pushes the list down.
    public init(title: String = "Your chats will appear here", message: String = "Talk to your assistant and try a demo of how it answers calls and helps you afterwards.", actionTitle: String? = nil, illustrationSize: CGFloat = 160, action: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.illustrationSize = illustrationSize
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 2) {
            illustration
            VStack(spacing: 18) {
                VStack(spacing: EqualSpacing.s8) {
                    Text(title).equalTextStyle(.headlineEm).foregroundStyle(EqualColor.textPrimary)
                    Text(message).equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary)
                        .frame(maxWidth: 278)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let actionTitle {
                    Button(action: action) {
                        HStack(spacing: EqualSpacing.s8) {
                            EqualIconView(.phoneOutline, size: 15, weight: .regular)
                            Text(actionTitle).equalTextStyle(.subheadEm)
                        }
                        .foregroundStyle(EqualColor.textOnAction)
                        .padding(.horizontal, 28)
                        .frame(height: 44)
                        .background(Capsule().fill(EqualColor.buttonPrimary))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .multilineTextAlignment(.center)
    }

    /// 191×160 art box (Figma "Component 237" plus sparkles), scaled to `illustrationSize`.
    private var illustration: some View {
        let ink = EqualColor.green
        let star = TrialStarShape(points: 4, innerRatio: 0.382)
        return ZStack(alignment: .topLeading) {
            Color.clear
            Ellipse()
                .fill(LinearGradient(colors: [.black.opacity(0.6), .black.opacity(0)], startPoint: .top, endPoint: .bottom))
                .frame(width: 106, height: 16).blur(radius: 8).offset(x: 41, y: 122)
            FramedArt(image: .mascotPhoneVoice, size: 194, fraction: 0.72, offset: CGSize(width: 10, height: -2))
                .offset(x: -1, y: -17)
            star.fill(ink).frame(width: 15, height: 15).offset(x: 158, y: 117).opacity(0.4)
            star.stroke(ink, lineWidth: 1).frame(width: 21, height: 21).offset(x: 0, y: 111).opacity(0.4)
            star.fill(ink).frame(width: 21, height: 21).offset(x: 170, y: 97).opacity(0.4)
            star.fill(ink).frame(width: 12, height: 12).offset(x: 117, y: 22).opacity(0.4)
            Image(systemName: "bubble.left").font(.system(size: 21)).foregroundStyle(ink.opacity(0.4)).offset(x: 21, y: 18)
        }
        .frame(width: 191, height: 160)
        .scaleEffect(illustrationSize / 160)
        .frame(width: 191 * illustrationSize / 160, height: illustrationSize)
        .accessibilityHidden(true)
    }
}

struct EqualEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        EqualPreviewPair {
            VStack(spacing: 40) {
                EqualEmptyState(actionTitle: "Meet Your Assistant")
                EqualEmptyState(illustrationSize: 117)
            }
        }
    }
}
