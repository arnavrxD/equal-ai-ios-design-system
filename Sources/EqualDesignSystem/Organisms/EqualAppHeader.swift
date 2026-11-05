import SwiftUI

/// Home top bar: the 24pt equal ai logo, the plan badge 7pt after it (GOLD, GOLD PLUS, TRIAL,
/// TRIAL ENDED, EXPIRED), and on the right the availability pill, the trial pill (last trial
/// days) or the user's avatar (legacy home: 28pt logo, 45pt avatar on mint). A hairline closes it.
public struct EqualAppHeader: View {
    public enum Trailing: Sendable {
        /// Glass availability pill, 36pt.
        case availability
        /// Availability pill in a given size and style (31pt compact on the permission home,
        /// plain white after an upgrade).
        case available(EqualAvailabilityPill.Size, EqualAvailabilityPill.Style)
        /// "1 Day Left" trial pill.
        case trial(String)
        /// The legacy home: profile avatar instead of a pill.
        case avatar
    }

    let badge: EqualPlanBadge.Kind?
    let trailing: Trailing
    let onTrailing: () -> Void

    /// - Parameter plan: "Gold" or "Gold Plus" (any other text shows a neutral badge); `nil` hides it.
    public init(plan: String? = nil, trailing: Trailing = .availability, onTrailing: @escaping () -> Void = {}) {
        self.badge = plan.map { p in
            switch p.lowercased() {
            case "gold": return .gold
            case "gold plus": return .goldPlus
            default: return .neutral(p)
            }
        }
        self.trailing = trailing
        self.onTrailing = onTrailing
    }

    /// A header with an explicit plan badge (e.g. `.trialEnded`, `.goldLight`).
    public init(badge: EqualPlanBadge.Kind?, trailing: Trailing = .availability, onTrailing: @escaping () -> Void = {}) {
        self.badge = badge
        self.trailing = trailing
        self.onTrailing = onTrailing
    }

    private var isLegacy: Bool { if case .avatar = trailing { return true } else { return false } }

    public var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 7) {
                EqualLogo(height: isLegacy ? 28 : 24)
                if let badge { EqualPlanBadge(badge) }
            }
            Spacer(minLength: 8)
            switch trailing {
            case .availability: EqualAvailabilityPill(action: onTrailing)
            case .available(let size, let style): EqualAvailabilityPill(size: size, style: style, action: onTrailing)
            case .trial(let text): EqualTrialPill(text)
            case .avatar:
                Button(action: onTrailing) {
                    EqualImage.avatarMale.image.aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45).background(Color(equalHex: 0xD8F6E0)).clipShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Your profile")
            }
        }
        .frame(height: isLegacy ? 45 : 37)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, isLegacy ? 10 : 18)
        .padding(.bottom, isLegacy ? 16 : 24)
        .background(EqualColor.bgSurface)
        .overlay(alignment: .bottom) { Rectangle().fill(Color.black.opacity(isLegacy ? 0.1 : 0.05)).frame(height: 1) }
    }
}

struct EqualAppHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            EqualAppHeader(plan: "Gold")
            EqualAppHeader(badge: .trialEnded)
            EqualAppHeader(plan: "Gold Plus", trailing: .available(.regular, .plain))
            EqualAppHeader(plan: "Gold", trailing: .trial("1 Day Left"))
            EqualAppHeader(trailing: .avatar)
        }
        .equalScreenBackground()
    }
}
