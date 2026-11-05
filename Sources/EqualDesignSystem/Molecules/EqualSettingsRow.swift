import SwiftUI

/// 68pt settings row: 36pt icon container · SemiBold 17 title with an optional green "New!" tag ·
/// Regular 12 subtitle · 16pt chevron at 40%.
///
/// Figma 26242:89427 (setting-row). Rows sit in an `EqualSettingsGroup`; each row draws the
/// hairline under itself unless `showsDivider` is false.
public struct EqualSettingsRow: View {
    /// The 20pt glyph in the icon container.
    public enum Glyph: Sendable {
        /// An `EqualIcon`, #111111.
        case icon(EqualIcon)
        /// Any SF Symbol name; `secondary` draws it #555555 (the outline icons under Settings & Support).
        case symbol(String, secondary: Bool = false)
        /// The WhatsApp outline (no SF Symbol exists), #555555.
        case whatsApp
    }

    let glyph: Glyph
    let title: String
    let subtitle: String?
    let badge: String?
    let showsDivider: Bool
    let action: () -> Void

    /// - Parameters:
    ///   - badge: text of the green tag after the title, e.g. "New!".
    ///   - showsDivider: draws the hairline under the row; pass `false` for the last row in a group.
    public init(_ title: String, icon: EqualIcon, subtitle: String? = nil, badge: String? = nil, showsDivider: Bool = true, action: @escaping () -> Void = {}) {
        self.init(title, glyph: .icon(icon), subtitle: subtitle, badge: badge, showsDivider: showsDivider, action: action)
    }

    public init(_ title: String, glyph: Glyph, subtitle: String? = nil, badge: String? = nil, showsDivider: Bool = true, action: @escaping () -> Void = {}) {
        self.title = title
        self.glyph = glyph
        self.subtitle = subtitle
        self.badge = badge
        self.showsDivider = showsDivider
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s16) {
                HStack(spacing: EqualSpacing.s8) {
                    glyphView.frame(width: 36, height: 36)
                    VStack(alignment: .leading, spacing: EqualSpacing.s2) {
                        HStack(spacing: EqualSpacing.s6) {
                            Text(title)
                                .font(.equal(size: 17, weight: .semibold)).tracking(-0.442)
                                .foregroundStyle(EqualColor.textPrimary)
                                .frame(minHeight: 22)
                            if let badge { NewTag(text: badge) }
                        }
                        if let subtitle {
                            Text(subtitle)
                                .font(.equal(size: 12)).tracking(-0.312)
                                .foregroundStyle(EqualColor.textSecondary)
                                .frame(minHeight: 16)
                                .lineLimit(1)
                        }
                    }
                }
                Spacer(minLength: 0)
                EqualIconView(.chevronRight, size: 10, weight: .bold)
                    .foregroundStyle(EqualColor.textSecondary.opacity(0.4))
                    .frame(width: 16, height: 16)
            }
            .padding(.vertical, 14)
            .overlay(alignment: .bottom) {
                if showsDivider { Rectangle().fill(EqualColor.strokeMedium).frame(height: 1) }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var glyphView: some View {
        switch glyph {
        case .icon(let icon):
            EqualIconView(icon, size: 20).foregroundStyle(EqualColor.textPrimary)
        case .symbol(let name, let secondary):
            Image(systemName: name).font(.system(size: 20))
                .foregroundStyle(secondary ? EqualColor.textSecondary : EqualColor.textPrimary)
                .accessibilityHidden(true)
        case .whatsApp:
            WhatsAppOutline().fill(EqualColor.textSecondary, style: FillStyle(eoFill: true))
                .frame(width: 17.4, height: 18)
                .accessibilityHidden(true)
        }
    }
}

/// "New!" tag: 17pt, radius 4, #00B140 → #004B1B, SemiBold 11 white.
private struct NewTag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.equal(size: 11, weight: .semibold)).tracking(-0.286)
            .foregroundStyle(.white)
            .padding(.horizontal, EqualSpacing.s8)
            .frame(height: 17)
            .background(RoundedRectangle(cornerRadius: EqualRadius.xs).fill(LinearGradient(colors: [EqualColor.brandGreen, Color(equalHex: 0x004B1B)], startPoint: .leading, endPoint: .trailing)))
            .fixedSize()
    }
}

/// The WhatsApp outline glyph (SVGRepo icon in Figma, 17.42 × 18.02 artboard).
private struct WhatsAppOutline: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width / 17.4169, sy = rect.height / 18.0237
        func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: rect.minX + x * sx, y: rect.minY + y * sy) }
        var p = Path()
        // Handset
        p.move(to: pt(3.96955, 5.54655))
        p.addCurve(to: pt(5.72775, 3.96662), control1: pt(4.06002, 4.83109), control2: pt(4.98983, 3.85872))
        p.addLine(to: pt(5.72657, 3.96544))
        p.addCurve(to: pt(7.33374, 5.89371), control1: pt(6.44471, 4.1019), control2: pt(7.01319, 5.33793))
        p.addCurve(to: pt(7.20153, 6.87792), control1: pt(7.56087, 6.29696), control2: pt(7.41338, 6.70552))
        p.addCurve(to: pt(6.5626, 7.74522), control1: pt(6.91574, 7.10827), control2: pt(6.46884, 7.4261))
        p.addCurve(to: pt(9.6819, 10.8543), control1: pt(6.7293, 8.31253), control2: pt(8.70847, 10.2917))
        p.addCurve(to: pt(10.5457, 10.2178), control1: pt(10.0503, 11.0673), control2: pt(10.3175, 10.5056))
        p.addCurve(to: pt(11.5227, 10.0827), control1: pt(10.7115, 9.99648), control2: pt(11.1204, 9.86419))
        p.addCurve(to: pt(13.2131, 11.2971), control1: pt(12.1236, 10.4326), control2: pt(12.6896, 10.8393))
        p.addCurve(to: pt(13.3547, 12.1798), control1: pt(13.4745, 11.5156), control2: pt(13.5358, 11.8385))
        p.addCurve(to: pt(11.443, 13.4125), control1: pt(13.0356, 12.7809), control2: pt(12.1129, 13.5736))
        p.addCurve(to: pt(4.02207, 5.98345), control1: pt(10.2731, 13.1312), control2: pt(5.5418, 11.2971))
        p.addCurve(to: pt(3.96955, 5.54655), control1: pt(3.9366, 5.73207), control2: pt(3.95811, 5.63704))
        p.closeSubpath()
        // Bubble (outer)
        p.move(to: pt(8.70843, 17.4168))
        p.addCurve(to: pt(6.33343, 17.0209), control1: pt(7.73975, 17.4168), control2: pt(7.20379, 17.3128))
        p.addLine(to: pt(4.66652, 17.8544))
        p.addCurve(to: pt(2.3751, 16.4382), control1: pt(3.61375, 18.3808), control2: pt(2.3751, 17.6152))
        p.addLine(to: pt(2.3751, 14.6459))
        p.addCurve(to: pt(0, 8.70843), control1: pt(0.67028, 13.0563), control2: pt(0, 11.2233))
        p.addCurve(to: pt(8.70843, 0), control1: pt(0, 3.89895), control2: pt(3.89895, 0))
        p.addCurve(to: pt(17.4168, 8.70843), control1: pt(13.5179, 0), control2: pt(17.4168, 3.89895))
        p.addCurve(to: pt(8.70843, 17.4168), control1: pt(17.4168, 13.5179), control2: pt(13.5179, 17.4168))
        p.closeSubpath()
        // Bubble (inner, cut out by the even-odd fill)
        p.move(to: pt(3.95843, 13.9574))
        p.addLine(to: pt(3.45489, 13.4879))
        p.addCurve(to: pt(1.58343, 8.70843), control1: pt(2.13037, 12.2529), control2: pt(1.58343, 10.8721))
        p.addCurve(to: pt(8.70843, 1.58343), control1: pt(1.58343, 4.7734), control2: pt(4.7734, 1.58343))
        p.addCurve(to: pt(15.8334, 8.70843), control1: pt(12.6435, 1.58343), control2: pt(15.8334, 4.7734))
        p.addCurve(to: pt(8.70843, 15.8334), control1: pt(15.8334, 12.6435), control2: pt(12.6435, 15.8334))
        p.addCurve(to: pt(6.83689, 15.5198), control1: pt(7.92808, 15.8334), control2: pt(7.5621, 15.763))
        p.addLine(to: pt(6.21347, 15.3107))
        p.addLine(to: pt(3.95843, 16.4382))
        p.addLine(to: pt(3.95843, 13.9574))
        p.closeSubpath()
        return p
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
            EqualSettingsRow("Instructions", icon: .document, subtitle: "4 active instructions", badge: "New!")
            EqualSettingsRow("Call Handling", icon: .phoneOutline, subtitle: "Saved contacts + Unknown numbers")
            EqualSettingsRow("WhatsApp Updates", glyph: .whatsApp, subtitle: "Assistant and App Updates")
            EqualSettingsRow("Help Center", glyph: .symbol("questionmark.circle", secondary: true), subtitle: "Your What, Why and How", showsDivider: false)
        }
        .padding(24)
        .equalScreenBackground()
    }
}
