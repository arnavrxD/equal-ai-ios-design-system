import SwiftUI

/// Referral card at the bottom of Settings.
public struct EqualInviteCard: View {
    let onShare: () -> Void
    public init(onShare: @escaping () -> Void = {}) { self.onShare = onShare }
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text("Invite a Friend").font(.equal(size: 16, weight: .black)).foregroundStyle(EqualColor.textPrimary)
                Text("Give them the same superpower that you have").font(.equal(size: 14)).foregroundStyle(EqualColor.textSecondary).frame(maxWidth: 170, alignment: .leading)
                EqualButton("Share now", size: .medium, icon: .share, action: onShare).padding(.top, EqualSpacing.s8)
            }
            Spacer(minLength: 0)
            EqualIllustration(.inviteHands, size: 110)
        }
        .padding(.horizontal, EqualSpacing.s18).padding(.vertical, EqualSpacing.s16)
        .background {
            RoundedRectangle(cornerRadius: EqualRadius.s).fill(EqualColor.unreadFill)
                .overlay(alignment: .bottomLeading) { Circle().fill(EqualColor.unreadStroke).frame(width: 197).blur(radius: 60).offset(x: -60, y: 120) }
                .clipShape(RoundedRectangle(cornerRadius: EqualRadius.s))
        }
    }
}
