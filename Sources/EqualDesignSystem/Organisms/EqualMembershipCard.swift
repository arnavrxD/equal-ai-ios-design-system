import SwiftUI

/// "Equal GOLD" card in Settings and on the subscription page: black with the membership
/// gradient, a gold glow and concentric rings bottom-right, the wordmark, a status tag and a
/// detail line.
///
/// Figma 26242:90537 (active / trial, 345×88), 26242:91757 (expired with Renew, 345×152) and
/// 26242:89370 (subscription page, 344×87 with a price column). In Settings the card shows a
/// chevron (also when expired); pass `price` for the subscription-page variant, which swaps the
/// chevron for the "Price" column and drops the Renew pill.
public struct EqualMembershipCard: View {
    public enum Status: Sendable { case active, trial, expired }

    let status: Status
    let detail: String?
    let price: String?
    let renewTitle: String
    let onRenew: () -> Void

    /// - Parameters:
    ///   - detail: the line under the wordmark; defaults to the Figma copy for `status`.
    ///   - price: e.g. "₹ 249/month"; shows the subscription-page price column.
    ///   - renewTitle: label of the Renew pill (expired, Settings only).
    public init(status: Status, detail: String? = nil, price: String? = nil, renewTitle: String = "Renew – ₹249/month", onRenew: @escaping () -> Void = {}) {
        self.status = status
        self.detail = detail
        self.price = price
        self.renewTitle = renewTitle
        self.onRenew = onRenew
    }

    private var showsRenew: Bool { status == .expired && price == nil }

    public var body: some View {
        Group {
            if price != nil {
                subscriptionLayout
            } else if showsRenew {
                expiredLayout
            } else {
                settingsLayout
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { background }
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.goldCard))
        .environment(\.colorScheme, .light)
    }

    // MARK: Layouts

    /// 345×88: padding 18/24, title row + detail, chevron at the right.
    private var settingsLayout: some View {
        HStack(spacing: EqualSpacing.s8) {
            VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                titleRow
                Text(detail ?? defaultDetail)
                    .font(.equal(size: 12, weight: .medium)).tracking(-0.36)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Spacer(minLength: 0)
            chevron
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.vertical, EqualSpacing.s18)
    }

    /// 345×152: padding 22/24, title row + chevron, Regular 14 detail, 36pt Renew pill.
    private var expiredLayout: some View {
        VStack(alignment: .leading, spacing: 17) {
            VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                HStack(spacing: 0) {
                    titleRow
                    Spacer(minLength: 0)
                    chevron
                }
                Text(detail ?? defaultDetail)
                    .font(.equal(size: 14)).tracking(-0.42)
                    .foregroundStyle(Self.secondaryDark)
                    .lineLimit(1)
            }
            Button(action: onRenew) {
                Text(renewTitle)
                    .font(.equal(size: 12, weight: .bold))
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Capsule().fill(Self.renewGradient))
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.vertical, 22)
    }

    /// 344×87: content at 18,19, detail centred at y 60, "Price" column on the right.
    private var subscriptionLayout: some View {
        HStack(alignment: .center, spacing: EqualSpacing.s8) {
            VStack(alignment: .leading, spacing: 5) {
                titleRow
                Text(detail ?? defaultDetail)
                    .font(.equal(size: 12, weight: .medium)).tracking(-0.36)
                    .foregroundStyle(Self.secondaryDark)
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 3) {
                Text("Price").font(.equal(size: 12, weight: .medium)).foregroundStyle(Self.secondaryDark)
                Text(price ?? "").font(.equal(size: 12, weight: .semibold)).foregroundStyle(Self.primaryDark)
            }
            .tracking(-0.36)
            .padding(.top, 14)
        }
        .padding(.leading, EqualSpacing.s18)
        .padding(.trailing, 19)
        .frame(height: 87)
    }

    // MARK: Parts

    private var titleRow: some View {
        HStack(spacing: EqualSpacing.s8) {
            HStack(spacing: EqualSpacing.s4) {
                Text("Equal").font(.equal(size: 21.83, weight: .semibold)).tracking(-0.52).foregroundStyle(.white)
                Text("GOLD").font(.equal(size: 21.83, weight: .bold)).tracking(-0.44).foregroundStyle(Self.goldWordmark)
            }
            .fixedSize()
            MembershipStatusTag(status: status).fixedSize()
        }
    }

    private var chevron: some View {
        EqualIconView(.chevronRight, size: 16, weight: .semibold)
            .foregroundStyle(.white.opacity(0.7))
            .frame(width: 28, height: 28, alignment: .trailing)
            .accessibilityHidden(true)
    }

    private var background: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color.black
                EqualGradient.membership
                // Gold glow (#FFC927 @60%, blur 114).
                Circle().fill(Color(equalHex: 0xFFC927, alpha: 0.6))
                    .frame(width: 110, height: 110).blur(radius: 57)
                    .offset(x: 281, y: 45)
                if showsRenew {
                    // Extra warm ellipse (#FFF2CA @33%, plus-lighter), mostly below the card.
                    Circle().fill(Color(equalHex: 0xFFF2CA))
                        .frame(width: 192, height: 192).blur(radius: 90).opacity(0.33)
                        .blendMode(.plusLighter)
                        .offset(x: 275, y: geo.size.height + 145 - 192)
                }
                EqualConcentricRings()
                    .frame(width: 154, height: 154)
                    .mask(LinearGradient(colors: [.white.opacity(0), .white], startPoint: UnitPoint(x: 32 / 154, y: 14 / 154), endPoint: UnitPoint(x: 70 / 154, y: 59 / 154)))
                    .offset(ringOffset(in: geo.size))
            }
        }
        .allowsHitTesting(false)
    }

    private func ringOffset(in size: CGSize) -> CGSize {
        if price != nil { return CGSize(width: 288, height: 32) }
        if showsRenew { return CGSize(width: 268, height: 107) }
        return CGSize(width: 277, height: 43)
    }

    private var defaultDetail: String {
        switch status {
        case .active: "Auto renews May 16, 2026"
        case .trial: "Trial ends in 1 day"
        case .expired: price == nil ? "Assistant has stopped handling your calls" : "Expired on 16th May, 2026"
        }
    }

    // MARK: Colours

    /// text/secondarydark: #ECFFF3 @70%.
    static let secondaryDark = Color(equalHex: 0xECFFF3, alpha: 0.7)
    /// text/primarydark: #ECFFF3.
    static let primaryDark = Color(equalHex: 0xECFFF3)
    /// "GOLD": Figma fills the whole "Equal GOLD" line with #FFD040 (to 28.8%) → #FFF8C7 → #CFA846
    /// (54.6%), so the GOLD letters (the right half) sit at the end of that ramp.
    static let goldWordmark = LinearGradient(colors: [Color(equalHex: 0xDDC273), Color(equalHex: 0xCFA846)], startPoint: .leading, endPoint: .trailing)
    /// Renew pill: white → #FFFEFC (2%) → #FFC927 (95%).
    static let renewGradient = LinearGradient(stops: [
        .init(color: .white, location: 0),
        .init(color: Color(equalHex: 0xFFFEFC), location: 0.0195),
        .init(color: Color(equalHex: 0xFFC927), location: 0.9518)
    ], startPoint: .leading, endPoint: .trailing)
}

/// The card's status tag: dark glass ("Active", "Free Trial") or the red radial "Expired".
private struct MembershipStatusTag: View {
    let status: EqualMembershipCard.Status

    var body: some View {
        switch status {
        case .active, .trial:
            Text(status == .active ? "Active" : "Free Trial")
                .font(.equal(size: 12, weight: .medium))
                .foregroundStyle(.white)
                .padding(.horizontal, EqualSpacing.s12)
                .frame(height: 24)
                .background {
                    ZStack(alignment: .topLeading) {
                        EqualColor.goldStatusBg
                        // Two #FFEDB8 glows rising from below the tag.
                        HStack(spacing: 11) {
                            Circle().frame(width: 54, height: 54)
                            Circle().frame(width: 54, height: 54)
                        }
                        .foregroundStyle(Color(equalHex: 0xFFEDB8))
                        .blur(radius: 35)
                        .offset(x: 36, y: 24)
                    }
                }
                .overlay {
                    // Inner shadow #4B4B4B, offset 2.2 right / 2.2 up: the box minus its shifted copy.
                    ZStack {
                        RoundedRectangle(cornerRadius: EqualRadius.s).fill(Color(equalHex: 0x4B4B4B))
                        RoundedRectangle(cornerRadius: EqualRadius.s).offset(x: 2.2, y: -2.2).blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    .blur(radius: 0.8)
                }
                .clipShape(RoundedRectangle(cornerRadius: EqualRadius.s))
                .overlay(RoundedRectangle(cornerRadius: EqualRadius.s).stroke(EqualColor.goldStatusBorder, lineWidth: 0.65))
        case .expired:
            Text("Expired")
                .font(.equal(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, EqualSpacing.s16)
                .frame(height: 24)
                .background {
                    ZStack {
                        LinearGradient(stops: [
                            .init(color: Color(equalHex: 0xFFD040), location: 0.24),
                            .init(color: Color(equalHex: 0xFFF8C7), location: 0.48),
                            .init(color: Color(equalHex: 0xCFA846), location: 1)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        RadialGradient(stops: Self.redStops, center: UnitPoint(x: 0.03, y: 1.13), startRadius: 0, endRadius: 78)
                            .opacity(0.97)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: EqualRadius.s))
                .shadow(color: .black.opacity(0.39), radius: 1, x: 1, y: 1)
        }
    }

    static let redStops: [Gradient.Stop] = [
        .init(color: Color(equalHex: 0xCD3200), location: 0),
        .init(color: Color(equalHex: 0xDC6149), location: 0.238),
        .init(color: Color(equalHex: 0xEB9191), location: 0.476),
        .init(color: Color(equalHex: 0xBC4949), location: 0.738),
        .init(color: Color(equalHex: 0xA52424), location: 0.869),
        .init(color: Color(equalHex: 0x8D0000), location: 1)
    ]
}

struct EqualMembershipCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualMembershipCard(status: .active)
            EqualMembershipCard(status: .trial)
            EqualMembershipCard(status: .expired)
            EqualMembershipCard(status: .active, detail: "Renews 16th May, 2026", price: "₹ 249/month")
            EqualMembershipCard(status: .expired, price: "₹ 249/month")
        }
        .padding(24)
        .equalScreenBackground()
    }
}
