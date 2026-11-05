import SwiftUI

/// The paywall's pinned bottom sheet: plan cards, coupon, the note, the gold CTA, the billing line
/// and legal links. The CTA and billing copy always name the selected plan and its price after
/// the coupon (Figma has frames where they do not).
///
/// - `.full` (300pt): plans 16 from the top, coupon +12, note +12, CTA +8, billing +12, legal +4,
///   14 bottom. Free-trial flow: "Subscribe at ₹499/month…" and "Restore purchases" in the legal line.
/// - `.ctaOnly` (151pt): note, CTA, billing, legal; used when the plans sit inline in the scroll.
/// - Limit flows (`flow.isLimit`): 81pt cards with the "Your plan" tag, the compact coupon, a
///   two-line note, a CTA without the light streak, the lock trust line and
///   "Recurring billing · Terms & Privacy · Cancel anytime".
public struct EqualStickyPlanSheet: View {
    public enum Plan: String, CaseIterable, Sendable { case gold, goldPlus }
    public enum Layout: Sendable { case full, ctaOnly }

    @Binding var selection: Plan
    private let externalCoupon: Binding<Bool>?
    @State private var localCoupon = false
    let flow: EqualPurchaseFlow
    let layout: Layout
    let couponStyle: EqualCouponRow.Style
    let note: String?
    let onPurchase: (Plan) -> Void

    /// Free-trial sheet with its own coupon state.
    public init(selection: Binding<Plan>, note: String = "Subscribing now ends your free trial immediately.", onPurchase: @escaping (Plan) -> Void = { _ in }) {
        self._selection = selection
        self.externalCoupon = nil
        self.flow = .trialLastDay
        self.layout = .full
        self.couponStyle = .overhang
        self.note = note
        self.onPurchase = onPurchase
    }

    /// - Parameters:
    ///   - couponApplied: shared with an inline coupon row so the CTA follows it.
    ///   - flow: picks the copy and the limit configuration.
    ///   - couponStyle: `nil` = `.overhang`, or `.compact` on limit flows.
    ///   - note: overrides `flow.note(for:)`.
    public init(selection: Binding<Plan>, couponApplied: Binding<Bool>, flow: EqualPurchaseFlow = .trialLastDay, layout: Layout = .full,
                couponStyle: EqualCouponRow.Style? = nil, note: String? = nil, onPurchase: @escaping (Plan) -> Void = { _ in }) {
        self._selection = selection
        self.externalCoupon = couponApplied
        self.flow = flow
        self.layout = layout
        self.couponStyle = couponStyle ?? (flow.isLimit ? .compact : .overhang)
        self.note = note
        self.onPurchase = onPurchase
    }

    private var coupon: Binding<Bool> { externalCoupon ?? $localCoupon }
    private var price: Int { selection.price(couponApplied: coupon.wrappedValue) }

    public var body: some View {
        VStack(spacing: 0) {
            if layout == .full {
                EqualPlanPicker(selection: $selection, couponApplied: coupon, style: flow.isLimit ? .limit : .sheet,
                                couponStyle: couponStyle, currentPlan: flow.currentPlan)
                    .padding(.bottom, flow.isLimit ? 10 : 12)
            }
            Text(note ?? flow.note(for: selection))
                .font(.equal(size: flow.isLimit ? 12 : 12.5)).lineSpacing(flow.isLimit ? 0.5 : 0)
                .foregroundStyle(EqualColor.legalText)
                .fixedSize(horizontal: false, vertical: true)
            EqualButton(flow.ctaTitle(for: selection, price: price), variant: .gold, fullWidth: true, showsStreak: !flow.isLimit) {
                onPurchase(selection)
            }
            .disabled(!flow.canPurchase(selection))
            .padding(.top, 8)
            if flow.isLimit {
                HStack(spacing: 4) {
                    Image(systemName: "lock").font(.system(size: 10, weight: .medium)).foregroundStyle(Color(equalHex: 0x00A03A))
                    Text("Secure payment via App Store · Cancel anytime").font(.equal(size: 12)).foregroundStyle(EqualColor.legalText)
                }
                .padding(.top, 10)
            } else {
                Text("Subscribe at \(Plan.rupees(price))/month. Cancel anytime in Settings.")
                    .font(.equal(size: 12)).foregroundStyle(EqualColor.legalText)
                    .padding(.top, 12)
            }
            HStack(spacing: 15) {
                Text("Recurring billing"); Text("Terms & Privacy"); Text(flow.isLimit ? "Cancel anytime" : "Restore purchases")
            }
            .font(.equal(size: 11)).foregroundStyle(EqualColor.legalLink)
            .lineLimit(1).minimumScaleFactor(0.8)
            .padding(.top, flow.isLimit ? 6 : 4)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, topPadding)
        .padding(.bottom, flow.isLimit ? 20 : 14)
        .frame(maxWidth: .infinity)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: EqualRadius.sheet, topTrailingRadius: EqualRadius.sheet)
                .fill(Color.white)
                .equalShadow(.sticky)
                .ignoresSafeArea(edges: .bottom)
        }
        .environment(\.colorScheme, .light)
    }

    private var topPadding: CGFloat {
        if layout == .ctaOnly { return 15 }
        return flow.isLimit ? 28 : 16
    }
}

public extension EqualStickyPlanSheet.Plan {
    /// "Gold" / "Gold Plus".
    var title: String { self == .goldPlus ? "Gold Plus" : "Gold" }
    /// List price in rupees a month: ₹249 / ₹499.
    var monthlyPrice: Int { self == .goldPlus ? 499 : 249 }
    /// Price after the EQUAL25 coupon (25% off, rounded): ₹187 / ₹374.
    func price(couponApplied: Bool) -> Int {
        couponApplied ? Int((Double(monthlyPrice) * 0.75).rounded()) : monthlyPrice
    }
    /// "₹374".
    static func rupees(_ value: Int) -> String { "₹\(value)" }
}

struct EqualStickyPlanSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            EqualStickyPlanSheet(selection: .constant(.goldPlus))
            EqualStickyPlanSheet(selection: .constant(.goldPlus), couponApplied: .constant(false), layout: .ctaOnly)
            EqualStickyPlanSheet(selection: .constant(.goldPlus), couponApplied: .constant(false), flow: .goldLimit)
        }
        .frame(width: 393)
        .background(EqualColor.grey14)
    }
}
