import SwiftUI

/// Home top bar: the equal ai logo, the plan tag (GOLD / GOLD PLUS) when subscribed, and on the
/// right the availability pill, the trial pill (last trial days) or the user's avatar.
public struct EqualAppHeader: View {
    public enum Trailing: Sendable { case availability, trial(String), avatar }

    let plan: String?
    let trailing: Trailing

    public init(plan: String? = nil, trailing: Trailing = .availability) {
        self.plan = plan
        self.trailing = trailing
    }

    public var body: some View {
        HStack {
            HStack(spacing: 7) {
                EqualLogo(height: 22)
                if let plan { EqualTag(plan, kind: .gold) }
            }
            Spacer()
            switch trailing {
            case .availability: EqualAvailabilityPill()
            case .trial(let text): EqualTrialPill(text)
            case .avatar:
                EqualImage.avatarMale.image.aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44).background(EqualColor.avatarPeach).clipShape(Circle())
                    .accessibilityLabel("Your profile")
            }
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.vertical, EqualSpacing.s12)
        .background(EqualColor.bgSurface)
        .overlay(alignment: .bottom) { Rectangle().fill(EqualColor.strokeSubtle).frame(height: 1) }
    }
}

struct EqualAppHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            EqualAppHeader(plan: "Gold")
            EqualAppHeader(plan: "Gold", trailing: .trial("1 Day Left"))
            EqualAppHeader(trailing: .avatar)
        }
        .equalScreenBackground()
    }
}
