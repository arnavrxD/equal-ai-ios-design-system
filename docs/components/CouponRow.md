# CouponRow

Coupon line with the scalloped "%" seal (or the 3D badge), the code, the offer and APPLY. Tapping APPLY switches to the applied state: #EFFAF2 with a dashed #7FD39B border, "25% off applied" Bold 14 #00872F and a "✓ Applied" pill that removes it.

- Styles: `.overhang` (default: 331×40 capsule, 84×40 APPLY hanging over its end), `.inset` (radius 14, 66×26 APPLY inside), `.compact` (limit paywalls: 42pt, dash 5/4, 70×26 APPLY), `.card` (soft paywall: 63pt, radius 20, 3D badge, code over offer).
- Pass: `code`, `offer`, `appliedTitle`, `style`, `isApplied` binding. Bind it to the sheet so prices and CTA follow.
