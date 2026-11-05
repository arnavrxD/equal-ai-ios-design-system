# ProcessingSheet

`EqualProcessingSheet` is the generic payment wait sheet: "Processing payment" (SemiBold 18) with the small `EqualRingLoader` 7pt to its right, then "Please wait. Don't close this page" (Regular 12), centred on a 472pt `#E5E5E5` sheet with radii 30/30/10/10 (dark `#222`).

- Present it with `.equalProcessingSheet(isPresented:)`: the screen blurs, a black 40% scrim covers it and the sheet sits 8pt in from the left, right and bottom edges.
- Pass: optionally `title` and `message`.
- Do use it for the short gateway wait before the purchase is confirmed. Don't use it in place of the education screens ("Activating Equal Gold" / "Processing payment") while the user has to act in another app.
