import SwiftUI

/// Recreation of the iOS purchase confirmation used in flow mocks (text in DM Sans per the brand rule).
public struct EqualAppStoreSheet: View {
    let product: String
    let price: String
    let note: String

    public init(product: String = "Equal Gold Plus", price: String = "₹499.00 per month", note: String = "Your free trial ends today and Gold Plus starts now. Renews monthly at ₹499 until cancelled in Settings.") {
        self.product = product
        self.price = price
        self.note = note
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            HStack {
                Text("App Store").font(.equal(size: 20, weight: .semibold))
                Spacer()
                Image(systemName: "xmark").font(.system(size: 12, weight: .bold)).foregroundStyle(.secondary)
                    .frame(width: 30, height: 30).background(Circle().fill(Color(equalHex: 0xE3E3E8)))
            }
            VStack(spacing: 0) {
                HStack(spacing: EqualSpacing.s12) {
                    EqualAppIcon(size: 48)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product).font(.equal(size: 17, weight: .semibold))
                        Text("Equal AI · Subscription").font(.equal(size: 13)).foregroundStyle(EqualColor.iosGray)
                    }
                    Spacer()
                }
                .padding(.bottom, EqualSpacing.s12)
                Divider()
                EqualKeyValueRow("Price", price); Divider()
                EqualKeyValueRow("Starts", "Today"); Divider()
                EqualKeyValueRow("Account", "Apple Account")
            }
            .padding(.horizontal, EqualSpacing.s16).padding(.vertical, EqualSpacing.s12)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
            Text(note).font(.equal(size: 13)).foregroundStyle(EqualColor.iosGray)
            VStack(spacing: EqualSpacing.s10) {
                Image(systemName: "faceid").font(.system(size: 30)).frame(width: 56, height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(EqualColor.iosBlue, lineWidth: 2))
                Text("Double-click side button to pay").font(.equal(size: 15, weight: .semibold))
            }
            .foregroundStyle(EqualColor.iosBlue)
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(EqualColor.grey01)
        .padding(EqualSpacing.s24)
        .background(RoundedRectangle(cornerRadius: 34).fill(Color(equalHex: 0xF2F2F7)))
        .environment(\.colorScheme, .light)
    }
}
