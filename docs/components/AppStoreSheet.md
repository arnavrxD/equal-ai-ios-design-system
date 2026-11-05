# AppStoreSheet

Recreation of the iOS App Store purchase confirmation for flow mocks, set in DM Sans per the type rule: "App Store" SemiBold 17 and close, the white product card (56pt gradient app tile, Bold 16 product, Price / Starts / Account rows of 39pt with top hairlines), the 12pt note and the blue 64pt Face ID box with "Double-click side button to pay". 377 wide, radius 38, #F2F2F7, 8pt from the screen edges.

- Pass: `product`, `price`, `note`, or `EqualAppStoreSheet(flow:plan:couponApplied:)` for the per-flow copy.
- Do pair it with SideButtonCue and a 35–40% black scrim (AppStoreConfirmationScreen does both).
