# UpiStepList

`EqualUpiStepList` shows the four UPI AutoPay steps as a compact 164pt list beside the small phone illustration (the list layout of "Activating Equal Gold"). Each row is an 18pt black number disc (Bold 12 numeral, DM Sans) and 13/18 text 124pt wide, 9pt apart; rows are 18pt apart.

- States per row: finished and current rows at full opacity, upcoming rows at 18%. `current: 4` shows all four.
- Pass: `current` (1-based) and optionally `steps` (defaults to `EqualPaymentProcessing.steps`).
- Do pair it with `EqualUpiPhoneIllustration(step:size: .small)` on the same step. Don't use it for more than about five steps; it is not a scrolling list.
