import SwiftUI

/// Equal's own purchase confirmation sheet (not the App Store replica): black equal ai logo and a
/// glass close button on grey, a white card with the app tile, "1 week free trial / Starting today",
/// the price and its start date, terms and the account, then the "Confirm with side button" cue.
public struct EqualPurchaseConfirmSheet: View {
    let plan: String
    let trial: String
    let trialStart: String
    let price: String
    let priceStart: String
    let terms: String
    let account: String
    let onClose: () -> Void

    public init(
        plan: String = "Gold Plan",
        trial: String = "1 week free trial",
        trialStart: String = "Starting today",
        price: String = "₹249/month",
        priceStart: String = "Starting 7th May, 2026",
        terms: String = "No commitment. Cancel anytime in Settings at least one day before each renewal date. Plan automatically renews until cancelled.",
        account: String = "you@example.com",
        onClose: @escaping () -> Void = {}
    ) {
        self.plan = plan
        self.trial = trial
        self.trialStart = trialStart
        self.price = price
        self.priceStart = priceStart
        self.terms = terms
        self.account = account
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                EqualLogo(height: 25, color: .black)
                Spacer()
                Button(action: onClose) {
                    EqualIconView(.close, size: 17, weight: .semibold)
                        .foregroundStyle(EqualColor.grey01)
                        .frame(width: 48, height: 48)
                        .background(Circle().fill(Color.white.opacity(0.55)))
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        .equalShadow(.glass)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close")
            }
            .frame(height: 48)
            .padding(.top, 14)

            card.padding(.top, 10)

            VStack(spacing: 6) {
                Circle().fill(EqualColor.green.opacity(0.1))
                    .overlay(Circle().stroke(Color(equalHex: 0x00AE35), lineWidth: 1))
                    .frame(width: 36, height: 36)
                Text("Confirm with side button").font(.equal(size: 12)).foregroundStyle(Color.black)
            }
            .padding(.top, 8)
            .padding(.bottom, 23)
            .accessibilityElement(children: .combine)
        }
        .padding(.horizontal, EqualSpacing.s16)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 30, style: .continuous)
                .fill(Color(equalHex: 0xE5E5E5))
        )
        .environment(\.colorScheme, .light)
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: EqualSpacing.s12) {
                EqualAppIcon(size: 46)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Equal AI").font(.equal(size: 18, weight: .semibold))
                    Text(plan).font(.equal(size: 14))
                }
            }
            divider
            VStack(alignment: .leading, spacing: 13) {
                line(trial, trialStart)
                line(price, priceStart)
            }
            divider
            VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                Text(terms).font(.equal(size: 12)).fixedSize(horizontal: false, vertical: true)
                Text("Account: \(account)").font(.equal(size: 12)).foregroundStyle(Color(equalHex: 0x828282))
            }
        }
        .foregroundStyle(Color.black)
        .padding(21)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: EqualRadius.sheet).fill(Color.white))
    }

    private var divider: some View {
        Rectangle().fill(Color(equalHex: 0xECECEC)).frame(height: 1).padding(.trailing, 9)
    }

    private func line(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.equal(size: 18, weight: .semibold))
            Text(detail).font(.equal(size: 12))
        }
        .accessibilityElement(children: .combine)
    }
}

struct EqualPurchaseConfirmSheet_Previews: PreviewProvider {
    static var previews: some View {
        EqualPurchaseConfirmSheet().padding(8).background(Color.gray)
    }
}
