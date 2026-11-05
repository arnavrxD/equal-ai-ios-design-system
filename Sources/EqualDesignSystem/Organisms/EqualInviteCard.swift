import SwiftUI

/// Referral card at the bottom of Settings: lime tint with a green glow, "Invite a Friend",
/// one line of copy, a green "Share now" pill and the 3D high-five.
///
/// Figma 26242:90508, 345×125 (grows with the copy), radius 8.
public struct EqualInviteCard: View {
    let title: String
    let message: String
    let onShare: () -> Void

    public init(title: String = "Invite a Friend", message: String = "Give them the same superpower that you have", onShare: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.onShare = onShare
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s12) {
            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text(title)
                    .font(.equal(size: 16, weight: .black)).tracking(-0.16)
                    .foregroundStyle(EqualColor.textPrimary)
                Text(message)
                    .font(.equal(size: 14))
                    .foregroundStyle(EqualColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 170, alignment: .leading)
            Button(action: onShare) {
                HStack(spacing: EqualSpacing.s4) {
                    EqualIconView(.share, size: 11, weight: .semibold)
                    Text("Share now").font(.equal(size: 12, weight: .bold)).tracking(-0.24)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, EqualSpacing.s12)
                .frame(height: 36)
                .background(Capsule().fill(EqualColor.brandGreen))
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 19)
        .padding(.vertical, 13)
        // Figma fixes the card at 125pt, which clips the pill once the copy wraps to three lines;
        // the card grows instead.
        .frame(maxWidth: .infinity, minHeight: 125, alignment: .topLeading)
        .background {
            EqualColor.unreadFill.overlay(alignment: .topLeading) {
                Circle().fill(EqualColor.brandGreen.opacity(0.36))
                    .frame(width: 197, height: 197).blur(radius: 60)
                    .offset(x: 228, y: 29)
            }
        }
        .overlay(alignment: .topTrailing) {
            EqualImage.inviteHands.image
                .aspectRatio(contentMode: .fit)
                .frame(width: 122.2, height: 120.9)
                .rotationEffect(.degrees(6.39))
                .frame(width: 134.9, height: 133.7)
                .offset(x: 0.1)
                .accessibilityHidden(true)
        }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.s))
    }
}

struct EqualInviteCard_Previews: PreviewProvider {
    static var previews: some View {
        EqualInviteCard().padding(24).equalScreenBackground()
    }
}
