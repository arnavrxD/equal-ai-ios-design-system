# PaymentProcessing

`EqualPaymentProcessing` is the payment-confirmation wait screen body: the crown ring loader (y 62), a 22/28 title with a 13/18 subtitle (y 231), then how to confirm. It is laid out on the 393×852 Figma frame from the top edge, so give it the whole screen and let it ignore the safe area; the phone illustration is cropped by the bottom edge. Light uses the cream-to-gold `EqualGradient.processing`; dark goes from black to dark gold (`.equalProcessingBackground()`).

- Layouts: `.processing` (default; "Processing payment", UPI label between 69pt rules, one 18/22 step, floating phone; has a dark variant), `.floating` (family B: "Activating Equal Gold", HOW TO CONFIRM, raised Apple Pay card, UPI label, one 16/21 step, floating phone), `.translucent` (B′), `.backdrop` (C: phone in the 232pt gold panel), `.list` (A: plain card, small phone beside `EqualUpiStepList`), `.upiOnly` (E) and `.upiOnlyBackdrop` (D: no Apple Pay).
- Pass: `step` (1–4), `layout`, and optionally `title`, `subtitle` and `phoneAppearance` (defaults to wireframe in light and UPI-app styling in dark).
- Steps: 1 Open your UPI app → 2 Approve the autopay request → 3 Enter your UPI PIN → 4 Come back to Equal AI. The step text cross-fades and the phone screen rises 41pt on change.
- Do drive `step` from a timer (the app cannot see the UPI app); `UpiWaitScreen` does this. Don't wrap it in a scroll view.
