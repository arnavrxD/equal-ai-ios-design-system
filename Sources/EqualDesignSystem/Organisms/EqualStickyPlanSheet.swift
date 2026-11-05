import SwiftUI

/// The paywall's pinned bottom sheet: plan cards, coupon, trial note, the gold CTA whose label
/// follows the selected plan, the billing line and legal links.
public struct EqualStickyPlanSheet: View {
    public enum Plan: Sendable { case gold, goldPlus }

    @Binding var selection: Plan
    @State private var couponApplied = false
    let note: String
    let onPurchase: (Plan) -> Void

    public init(selection: Binding<Plan>, note: String = "Subscribing now ends your free trial immediately.", onPurchase: @escaping (Plan) -> Void = { _ in }) {
        self._selection = selection
        self.note = note
        self.onPurchase = onPurchase
    }

    private var price: String { selection == .goldPlus ? "₹499" : "₹249" }
    private var planName: String { selection == .goldPlus ? "Gold Plus" : "Gold" }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            HStack(spacing: EqualSpacing.s12) {
                EqualPlanCard("Gold", price: "₹249", isSelected: selection == .gold) { selection = .gold }
                EqualPlanCard("Gold Plus", price: "₹499", isSelected: selection == .goldPlus, badge: "Best value") { selection = .goldPlus }
            }
            .padding(.top, 6)
            EqualCouponRow(isApplied: $couponApplied)
            Text(note).font(.equal(size: 12.5)).foregroundStyle(EqualColor.legalText)
            EqualButton("Get \(planName) for \(price)/month", variant: .gold, fullWidth: true) { onPurchase(selection) }
            Text("Subscribe at \(price)/month. Cancel anytime in Settings.").font(.equal(size: 12)).foregroundStyle(EqualColor.legalText)
            HStack(spacing: EqualSpacing.s16) {
                Text("Recurring billing"); Text("Terms & Privacy"); Text("Restore purchases")
            }
            .font(.equal(size: 11)).foregroundStyle(EqualColor.legalLink)
            .lineLimit(1).minimumScaleFactor(0.8)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, EqualSpacing.s24)
        .padding(.bottom, EqualSpacing.s16)
        .background(Color.white)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.sheet, topTrailingRadius: EqualRadius.sheet))
        .equalShadow(.sticky)
        .environment(\.colorScheme, .light)
    }
}
