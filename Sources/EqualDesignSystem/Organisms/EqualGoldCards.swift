import SwiftUI

/// Dark "Your free week with Equal" card that overlaps the paywall hero: three tabular stats.
public struct EqualRecapCard: View {
    let eyebrow: String
    let stats: [(value: String, label: String)]

    public init(eyebrow: String = "Your free week with Equal", stats: [(value: String, label: String)] = [("2h 22m", "saved"), ("18", "calls handled"), ("7", "spam stopped")]) {
        self.eyebrow = eyebrow
        self.stats = stats
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s10) {
            HStack(spacing: 6) {
                Text(eyebrow.uppercased()).font(.equal(size: 11, weight: .semibold)).tracking(0.88)
                Image(systemName: "play.circle.fill").font(.system(size: 13))
            }
            .foregroundStyle(EqualColor.goldRecapLabel)
            HStack(spacing: 0) {
                ForEach(Array(stats.enumerated()), id: \.offset) { i, s in
                    if i > 0 { Rectangle().fill(EqualColor.goldHairline).frame(width: 1, height: 34) }
                    VStack(spacing: 0) {
                        Text(s.value).font(.equal(size: 22, weight: .semibold)).monospacedDigit()
                        Text(s.label).font(.equal(size: 11)).opacity(0.85)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .foregroundStyle(.white)
        }
        .padding(.horizontal, EqualSpacing.s18)
        .padding(.vertical, EqualSpacing.s16)
        .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(EqualGradient.recap))
        .equalShadow(.recap)
    }
}

/// "Equal GOLD" card in Settings and on the subscription page.
public struct EqualMembershipCard: View {
    public enum Status: Sendable { case active, trial, expired }

    let status: Status
    let detail: String?
    let price: String?
    let onRenew: () -> Void

    public init(status: Status, detail: String? = nil, price: String? = nil, onRenew: @escaping () -> Void = {}) {
        self.status = status
        self.detail = detail
        self.price = price
        self.onRenew = onRenew
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                HStack(spacing: EqualSpacing.s8) {
                    HStack(spacing: 4) {
                        Text("Equal").foregroundStyle(.white)
                        Text("GOLD").fontWeight(.bold).foregroundStyle(EqualGradient.goldText)
                    }
                    .font(.equal(size: 21.8, weight: .semibold))
                    EqualTag(statusText, kind: status == .expired ? .expired : .status)
                }
                Text(detail ?? defaultDetail).font(.equal(size: 12, weight: .medium)).foregroundStyle(.white.opacity(0.7))
                if status == .expired {
                    Button(action: onRenew) {
                        Text("Renew – ₹249/month").font(.equal(size: 12, weight: .semibold)).foregroundStyle(EqualColor.grey01)
                            .frame(maxWidth: .infinity).frame(height: 32)
                            .background(Capsule().fill(LinearGradient(colors: [Color(equalHex: 0xFFE58A), Color(equalHex: 0xFFCF3F)], startPoint: .leading, endPoint: .trailing)))
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer(minLength: 0)
            if let price {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Price").font(.equal(size: 11)).foregroundStyle(.white.opacity(0.7))
                    Text(price).font(.equal(size: 12, weight: .semibold)).foregroundStyle(.white)
                }
            } else if status != .expired {
                EqualIconView(.chevronRight, size: 14, weight: .semibold).foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.vertical, EqualSpacing.s18)
        .background {
            ZStack(alignment: .topTrailing) {
                Color.black
                EqualGradient.membership
                Circle().fill(Color(equalHex: 0xFFC927)).frame(width: 110, height: 110).blur(radius: 50).opacity(0.35).offset(x: 10, y: -30)
            }
            .clipShape(RoundedRectangle(cornerRadius: EqualRadius.goldCard))
        }
    }

    private var statusText: String { switch status { case .active: "Active"; case .trial: "Free Trial"; case .expired: "Expired" } }
    private var defaultDetail: String {
        switch status {
        case .active: "Auto renews May 16, 2026"
        case .trial: "Trial ends in 1 day"
        case .expired: "Assistant has stopped handling your calls"
        }
    }
}

/// Top of Settings: gold radial wash (green when the plan expired), 3D avatar, name and number.
public struct EqualProfileHeader: View {
    let name: String
    let phone: String
    let isExpired: Bool
    let onBack: (() -> Void)?

    public init(name: String = "Keshav", phone: String = "+91 98789 56749", isExpired: Bool = false, onBack: (() -> Void)? = nil) {
        self.name = name
        self.phone = phone
        self.isExpired = isExpired
        self.onBack = onBack
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            if let onBack {
                Button(action: onBack) {
                    Label("Settings", systemImage: "chevron.left").font(.equal(size: 15)).foregroundStyle(EqualColor.grey01)
                }
                .buttonStyle(.plain)
            }
            HStack(spacing: 13) {
                EqualIllustration(.avatarMale, size: 70)
                VStack(alignment: .leading, spacing: -2) {
                    Text(name).font(.equal(size: 28.4, weight: .heavy)).tracking(-0.85).foregroundStyle(Color.black)
                    Text(phone).font(.equal(size: 17.5, weight: .medium)).tracking(-0.5).foregroundStyle(Color(equalHex: 0x1E1E1E))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 24)
        .padding(.bottom, EqualSpacing.s24)
        .background(
            RadialGradient(colors: isExpired ? [Color(equalHex: 0xC9F7D3), Color(equalHex: 0xECFDF0), .white] : [Color(equalHex: 0xFFE48A), Color(equalHex: 0xFFF6D6), .white],
                           center: UnitPoint(x: 0.3, y: 0), startRadius: 0, endRadius: 420)
        )
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 22, bottomTrailingRadius: 22))
    }
}

/// Gold vs Gold Plus table. The Gold Plus column is washed gold; "AI calls a month" is highlighted.
public struct EqualComparePlansTable: View {
    let features: [String]
    let goldCalls: String

    public init(features: [String] = ["Call screening", "Handles calls from contacts", "Speaks your language", "Instructions", "Saved addresses", "Post-call actions"], goldCalls: String = "30") {
        self.features = features
        self.goldCalls = goldCalls
    }

    public var body: some View {
        VStack(spacing: 0) {
            row(highlight: false, divider: false) {
                Color.clear.frame(height: 18)
            } gold: {
                Text("Gold").font(.equal(size: 13, weight: .semibold)).foregroundStyle(EqualColor.grey05)
            } plus: {
                Text("Gold Plus").font(.equal(size: 13, weight: .semibold)).foregroundStyle(EqualColor.grey01)
            }
            .background(alignment: .trailing) { EqualColor.goldHeader.frame(width: 103) }

            row(highlight: true) {
                label("AI calls a month")
            } gold: {
                Text(goldCalls).font(.equal(size: 15, weight: .semibold)).foregroundStyle(Color(equalHex: 0x282828))
            } plus: {
                Text("Unlimited").font(.equal(size: 15, weight: .semibold)).foregroundStyle(EqualColor.successText)
            }
            ForEach(features, id: \.self) { f in
                row(highlight: false) { label(f) } gold: { EqualCompareCheck() } plus: { EqualCompareCheck() }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(EqualColor.compareBorder, lineWidth: 1))
    }

    private func label(_ s: String) -> some View {
        Text(s).font(.equal(size: 15)).tracking(-0.39).foregroundStyle(Color(equalHex: 0x282828))
    }

    private func row<L: View, G: View, P: View>(highlight: Bool, divider: Bool = true, @ViewBuilder label: () -> L, @ViewBuilder gold: () -> G, @ViewBuilder plus: () -> P) -> some View {
        HStack(spacing: 0) {
            label().frame(maxWidth: .infinity, alignment: .leading).padding(EqualSpacing.s12)
            gold().frame(width: 103).padding(.vertical, EqualSpacing.s12)
            plus().frame(width: 103).frame(maxHeight: .infinity).background(EqualColor.goldColumn)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(highlight ? EqualColor.goldRow : .clear)
        .overlay(alignment: .top) { if divider { Rectangle().fill(EqualColor.compareLine).frame(height: 1) } }
    }
}

struct EqualGoldCards_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                EqualRecapCard()
                EqualMembershipCard(status: .active)
                EqualMembershipCard(status: .trial)
                EqualMembershipCard(status: .expired)
                EqualProfileHeader(onBack: {})
                EqualComparePlansTable()
            }
            .padding(24)
        }
        .equalScreenBackground()
    }
}
