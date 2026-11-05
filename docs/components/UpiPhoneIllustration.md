# UpiPhoneIllustration

`EqualUpiPhoneIllustration` is a fully coded wireframe phone that shows what the user sees in their UPI app at each AutoPay step. It replaces the reference art `upi-autopay-steps.png`. The phone is open at the bottom: top corners 33.18, 5.53pt outline and fill both fade out downwards, so it is meant to be cropped by the screen edge or its panel. Drawn at 215.68×365 and scaled.

- Steps: 1 AutoPay request notification card, 2 "Approve AutoPay" (payee, frequency, validity, button), 3 "Enter UPI PIN" (4 of 6 dots, keypad), 4 check seal.
- Sizes: `.large` 215.68, `.tall` 214, `.small` 156, `.backdrop` 152, `.compact` 143, or `Size(width:)`.
- Containers: `.floating`, or `.backdrop(height:)`, a 345-wide `#674F16` → `#251A00` panel with radius 16 that clips the phone (19pt top inset at 232 tall, 41pt at 362).
- Appearance: `.wireframe` (grey placeholders) or `.upiBrand` ("AS" avatar on `#61799B`, purple `#680EC6` "View details" / "Set AutoPay"). Dark mode: black phone, white outline, `#222` card, `#E0C171` eyebrow.
- Motion: changing `step` fades the new screen in while it rises 41pt; under Reduce Motion it only cross-fades.
- Pass: `step`, and optionally `size`, `container`, `appearance`, `merchant` ("Apple") and `initials` ("AS").
- Do keep the step text beside or above it; the phone is decorative and hidden from VoiceOver. Don't show it uncropped: its bottom is intentionally open.
