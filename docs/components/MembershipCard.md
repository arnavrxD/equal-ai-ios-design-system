# MembershipCard

"Equal GOLD" card in Settings and on the subscription page (Figma 26242:90537, 26242:91757, 26242:89370): black with `gradient-membership`, a `#FFC927` glow and four concentric rings (82–152pt, faded with a gradient mask) bottom-right, the "Equal" + gold "GOLD" wordmark (21.8), a status tag and one detail line.

- Variants: `active` ("Active" glass tag, "Auto renews May 16, 2026"), `trial` ("Free Trial", "Trial ends in 1 day"), `expired` (red radial "Expired" tag, Regular 14 "Assistant has stopped handling your calls", 36pt white → gold "Renew – ₹249/month" pill; the chevron stays). Passing `price` gives the subscription-page variant: a "Price" / "₹ 249/month" column instead of the chevron and no Renew pill (expired detail: "Expired on 16th May, 2026").
- Props: `status`, `detail`, `price`, `renewTitle`, `onRenew`.
