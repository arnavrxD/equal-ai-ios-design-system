import SwiftUI

/// 68pt settings row: 36pt icon container · title with an optional "New" tag · subtitle · chevron.
public struct EqualSettingsRow: View {
    let icon: EqualIcon
    let title: String
    let subtitle: String?
    let badge: String?
    let showsDivider: Bool
    let action: () -> Void

    /// - Parameter showsDivider: draws the hairline under the row; pass `false` for the last row in a group.
    public init(_ title: String, icon: EqualIcon, subtitle: String? = nil, badge: String? = nil, showsDivider: Bool = true, action: @escaping () -> Void = {}) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.badge = badge
        self.showsDivider = showsDivider
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s16) {
                HStack(spacing: EqualSpacing.s8) {
                    EqualIconView(icon, size: 18).foregroundStyle(EqualColor.textPrimary).frame(width: 36, height: 36)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(title).equalTextStyle(.calloutEm).foregroundStyle(EqualColor.textPrimary)
                            if let badge { EqualTag(badge, kind: .new) }
                        }
                        if let subtitle {
                            Text(subtitle).equalTextStyle(.footnote).foregroundStyle(EqualColor.textSecondary).lineLimit(1)
                        }
                    }
                }
                Spacer(minLength: 0)
                EqualIconView(.chevronRight, size: 13, weight: .semibold).foregroundStyle(EqualColor.textSecondary)
            }
            .padding(.vertical, 14)
            .overlay(alignment: .bottom) {
                if showsDivider { Rectangle().fill(EqualColor.strokeMedium).frame(height: 1) }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// White rounded group that holds settings rows (each row draws its own divider).
public struct EqualSettingsGroup<Content: View>: View {
    let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View {
        VStack(spacing: 0) { content }
        .padding(.horizontal, EqualSpacing.s16)
        .padding(.vertical, EqualSpacing.s8)
        .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(EqualColor.bgSurface))
    }
}

struct EqualSettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        EqualSettingsGroup {
            EqualSettingsRow("Instructions", icon: .document, subtitle: "4 active instructions", badge: "New")
            EqualSettingsRow("Call Handling", icon: .phoneOutline, subtitle: "Saved contacts + Unknown numbers")
            EqualSettingsRow("Silent Mode", icon: .bellSlash, subtitle: "Mute all promotional calls")
            EqualSettingsRow("Voice & Language", icon: .mic, subtitle: "Calm & Friendly · Hindi, English, Telugu", showsDivider: false)
        }
        .padding(24)
        .equalScreenBackground()
    }
}
