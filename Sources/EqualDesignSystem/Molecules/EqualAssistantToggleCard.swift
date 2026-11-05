import SwiftUI

/// The master switch at the top of Settings: a lime-tinted card with two soft green glows, the
/// smiling mascot, "AI Assistant is On" and a toggle.
///
/// Figma 26242:89415 (Component 26), 345×64.
public struct EqualAssistantToggleCard: View {
    @Binding var isOn: Bool
    let title: String
    let subtitle: String

    public init(isOn: Binding<Bool>, title: String = "AI Assistant is On", subtitle: String = "Equal is managing your unknown calls!") {
        self._isOn = isOn
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: EqualSpacing.s4) {
                EqualImage.mascotFaceSmile.image
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .offset(y: -1)
                    .frame(width: 48, height: 48)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 0) {
                    Text(isOn ? title : "AI Assistant is Off")
                        .font(.equal(size: 17, weight: .semibold)).tracking(-0.442)
                        .foregroundStyle(EqualColor.textPrimary)
                        .frame(height: 22)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 3.1)
                    Text(subtitle)
                        .font(.equal(size: 12)).tracking(-0.312)
                        .foregroundStyle(EqualColor.textPrimary)
                        .frame(height: 16)
                        .lineLimit(1)
                }
            }
            Spacer(minLength: 0)
            EqualToggle("AI Assistant", isOn: $isOn)
        }
        .padding(.vertical, EqualSpacing.s8)
        .padding(.leading, EqualSpacing.s8)
        .padding(.trailing, EqualSpacing.s12)
        .background {
            // Two #00B140 @36% glows (197pt, blur 124): top-left and right.
            EqualColor.unreadFill.overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    glow.offset(x: -160, y: -140)
                    glow.offset(x: 310, y: 0)
                }
            }
            .allowsHitTesting(false)
        }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
    }

    private var glow: some View {
        Circle().fill(EqualColor.brandGreen.opacity(0.36)).frame(width: 197, height: 197).blur(radius: 62)
    }
}

struct EqualAssistantToggleCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualAssistantToggleCard(isOn: .constant(true))
            EqualAssistantToggleCard(isOn: .constant(false))
        }
        .padding(24)
        .equalScreenBackground()
    }
}
