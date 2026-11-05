# UpiStep

`EqualUpiStep` is one numbered UPI instruction on the payment wait screen: a 24pt black disc with a Bold 16 white numeral (DM Sans; Figma used SF Pro Display), a 10pt gap, then centred text up to 237pt wide.

- Sizes: `.regular` 16/21 ("Activating Equal Gold") and `.large` 18/22 ("Processing payment"). Text is -2.6%.
- Dark: `#F7F7F7` disc with a black numeral, `#F7F7F7` text.
- Pass: the step number, the text, and optionally the size.
- Do show one step at a time and cross-fade on change. For all four at once use `EqualUpiStepList`.
