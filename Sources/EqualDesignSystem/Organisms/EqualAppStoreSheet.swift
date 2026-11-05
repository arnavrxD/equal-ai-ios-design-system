import SwiftUI

/// Recreation of the iOS App Store purchase confirmation used in the purchase flows, set in DM Sans
/// per the brand rule: "App Store" title and close, the product card (app icon, plan, Price /
/// Starts / Account), the per-flow note and the blue Face ID prompt.
///
/// 377 wide, radius 38, #F2F2F7, inset 8pt from the screen edges. Pair it with
/// `EqualSideButtonCue` on the right screen edge while it is up.
public struct EqualAppStoreSheet: View {
    let product: String
    let price: String
    let note: String
    let onClose: () -> Void

    public init(product: String = "Equal Gold Plus", price: String = "₹499.00 per month",
                note: String = "Your free trial ends today and Gold Plus starts now. Renews monthly at ₹499 until cancelled in Settings.",
                onClose: @escaping () -> Void = {}) {
        self.product = product
        self.price = price
        self.note = note
        self.onClose = onClose
    }

    /// The sheet for a flow and the selected plan (price after any coupon).
    public init(flow: EqualPurchaseFlow, plan: EqualStickyPlanSheet.Plan, couponApplied: Bool = false, onClose: @escaping () -> Void = {}) {
        let price = plan.price(couponApplied: couponApplied)
        self.init(product: flow.appStoreProduct(for: plan), price: flow.appStorePrice(price),
                  note: flow.appStoreNote(for: plan, price: price), onClose: onClose)
    }

    private static let ink = Color(equalHex: 0x151714)
    private static let grey = Color(equalHex: 0x8E8E93)

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("App Store").font(.equal(size: 17, weight: .semibold)).foregroundStyle(Self.ink)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark").font(.system(size: 11, weight: .bold)).foregroundStyle(Color(equalHex: 0x6C6C70))
                        .frame(width: 30, height: 30).background(Circle().fill(Color(equalHex: 0xE3E3E8)))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Cancel")
            }
            .frame(height: 30)
            .padding(.top, 19)
            .padding(.leading, 20).padding(.trailing, 22)

            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    EqualStoreAppIcon(size: 56)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product).font(.equal(size: 16, weight: .bold)).foregroundStyle(Self.ink)
                        Text("Equal AI · Subscription").font(.equal(size: 13)).foregroundStyle(Self.grey)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.bottom, 14)
                row("Price", price)
                row("Starts", "Today")
                row("Account", "Apple Account")
            }
            .padding(.horizontal, 14).padding(.top, 11).padding(.bottom, 3)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .padding(.horizontal, 20)
            .padding(.top, 17)

            Text(note).font(.equal(size: 12)).lineSpacing(3.8).foregroundStyle(Self.grey)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
                .padding(.top, 13)

            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 16).strokeBorder(EqualColor.iosBlue, lineWidth: 3)
                    .frame(width: 64, height: 64)
                    .overlay(EqualIconView(.faceID, size: 26, weight: .regular).foregroundStyle(EqualColor.iosBlue))
                Text("Double-click side button to pay").font(.equal(size: 14, weight: .semibold)).foregroundStyle(EqualColor.iosBlue)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 14)
            .padding(.bottom, 22)
        }
        .frame(maxWidth: 377)
        .background(RoundedRectangle(cornerRadius: 38, style: .continuous).fill(Color(equalHex: 0xF2F2F7)))
        .environment(\.colorScheme, .light)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(Self.grey)
            Spacer()
            Text(value).foregroundStyle(Self.ink)
        }
        .font(.equal(size: 14))
        .frame(height: 39)
        .overlay(alignment: .top) { Rectangle().fill(Color(equalHex: 0xEFEFF4)).frame(height: 1) }
    }
}

/// The App Store app tile: 56pt, radius 13, #28C24E → #0A9A35 with the white six-dot mark.
struct EqualStoreAppIcon: View {
    let size: CGFloat
    var body: some View {
        RoundedRectangle(cornerRadius: size * 13 / 56, style: .continuous)
            .fill(LinearGradient(colors: [Color(equalHex: 0x28C24E), Color(equalHex: 0x0A9A35)], startPoint: .top, endPoint: .bottom))
            .overlay(EqualMark(size: size * 0.5, color: .white))
            .frame(width: size, height: size)
            .accessibilityLabel("Equal AI")
    }
}

struct EqualAppStoreSheet_Previews: PreviewProvider {
    static var previews: some View {
        EqualAppStoreSheet(flow: .goldLimit, plan: .goldPlus)
            .padding(8)
            .frame(width: 393)
            .background(Color.gray)
    }
}
