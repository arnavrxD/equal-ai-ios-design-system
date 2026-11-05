import SwiftUI

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
