# StickyPlanSheet

The paywall's pinned bottom sheet: plan cards, coupon, the note, the gold CTA, billing line and legal links. The CTA and billing copy always name the selected plan and its price after the coupon (several Figma frames do not).

- Layouts: `.full` (300pt; plans 16 from the top, coupon +12, note +12, CTA +8, billing +12, legal +4), `.ctaOnly` (151pt, plans inline in the scroll). Limit flows (`flow.isLimit`) switch to 81pt cards, the "Your plan" tag, the compact coupon, the lock trust line, "Cancel anytime" legal and a CTA without the light streak.
- Pass: `selection`, `couponApplied` (binding), `flow: EqualPurchaseFlow`, `layout`, `couponStyle`, `note`, `onPurchase`. `EqualStickyPlanSheet(selection:)` still works with its own coupon state.
- Plan helpers: `Plan.title`, `monthlyPrice`, `price(couponApplied:)` (₹374 / ₹187), `Plan.rupees(_:)`.
