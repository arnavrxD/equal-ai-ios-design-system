import SwiftUI

/// The Gold / Gold Plus pair of `EqualPlanCard`s with the coupon row under them. Prices follow the
/// coupon (25% off, old price struck through). Shared by the sticky plan sheet and the inline
/// layout, where the plans sit in the scroll under the hero and the sheet shrinks to the CTA.
///
/// - `.sheet`: cards gap 13, coupon 12 below.
/// - `.inline`: selected stroke #C29200, coupon 17 below.
/// - `.limit`: 81pt cards, gap 14, the user's `currentPlan` tagged "Your plan".
public struct EqualPlanPicker: View {
    public typealias Plan = EqualStickyPlanSheet.Plan

    @Binding var selection: Plan
    @Binding var couponApplied: Bool
    let style: EqualPlanCard.Style
    let couponStyle: EqualCouponRow.Style?
    let currentPlan: Plan?

    /// - Parameters:
    ///   - couponStyle: `nil` hides the coupon row.
    ///   - currentPlan: the plan the user already has (Gold limit flow).
    public init(selection: Binding<Plan>, couponApplied: Binding<Bool>, style: EqualPlanCard.Style = .sheet,
                couponStyle: EqualCouponRow.Style? = .overhang, currentPlan: Plan? = nil) {
        self._selection = selection
        self._couponApplied = couponApplied
        self.style = style
        self.couponStyle = couponStyle
        self.currentPlan = currentPlan
    }

    public var body: some View {
        VStack(spacing: style == .inline ? 17 : 12) {
            HStack(spacing: style == .limit ? 14 : 13) {
                card(.gold)
                card(.goldPlus)
            }
            if let couponStyle {
                EqualCouponRow(style: couponStyle, isApplied: $couponApplied)
            }
        }
    }

    private func card(_ plan: Plan) -> some View {
        let price = plan.price(couponApplied: couponApplied)
        return EqualPlanCard(plan.title, price: Plan.rupees(price), isSelected: selection == plan,
                             badge: plan == .goldPlus ? "Best value" : nil,
                             originalPrice: couponApplied ? Plan.rupees(plan.monthlyPrice) : nil,
                             currentPlanTag: plan == currentPlan ? "Your plan" : nil,
                             style: style) {
            withAnimation(.snappy) { selection = plan }
        }
    }
}

struct EqualPlanPicker_Previews: PreviewProvider {
    struct Demo: View {
        @State var plan: EqualStickyPlanSheet.Plan = .goldPlus
        @State var coupon = false
        var body: some View { EqualPlanPicker(selection: $plan, couponApplied: $coupon, style: .inline) }
    }
    static var previews: some View { Demo().padding(24).frame(width: 393).background(EqualColor.grey14) }
}
