# PlanPicker

The Gold / Gold Plus pair of PlanCards with the CouponRow under them. Prices follow the coupon (25% off, the old price struck through) and the selection is a binding, so the sheet CTA can follow both.

- Styles: `.sheet` (gap 13, coupon 12 below), `.inline` (selected stroke #C29200, coupon 17 below), `.limit` (81pt cards, gap 14, "Your plan" on `currentPlan`).
- Pass: `selection`, `couponApplied` bindings, `style`, `couponStyle` (`nil` hides the coupon), `currentPlan`.
- Do share the bindings with StickyPlanSheet when plans are inline. Don't build plan rows by hand.
