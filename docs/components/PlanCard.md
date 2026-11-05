# PlanCard

Selectable plan card: name (Medium 15), price (Bold 22) with "/month", a radio top-right and an optional tag across the top edge. White, radius 16, 2pt border (#F2F2F2; selected #EBCB6A, or #C29200 inline) with a soft #B98407 glow when selected.

- Styles: `.sheet` / `.inline` (84pt, 14pt inset), `.limit` (81pt, 16pt inset).
- Pass: `name`, `price`, `period`, `isSelected`, `badge` (dark "Best value"), `originalPrice` (struck through after a coupon), `currentPlanTag` (cream "Your plan"), `style`, `action`.
- Prefer PlanPicker over placing cards by hand.
