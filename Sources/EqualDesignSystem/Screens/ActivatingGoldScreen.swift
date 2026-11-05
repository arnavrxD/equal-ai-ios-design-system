import SwiftUI

/// "Activating Equal Gold": the wait screen shown while the Gold purchase is confirmed, teaching the
/// two ways to confirm (Apple Pay double-click + Face ID, or the four UPI AutoPay steps).
///
/// `layout` picks the Figma family: `.floating` (B, default), `.translucent` (B′), `.backdrop` (C),
/// `.list` (A), `.upiOnly` (E) or `.upiOnlyBackdrop` (D). `step` (1…4) is the UPI step on show.
public struct ActivatingGoldScreen: View {
    let step: Int
    let layout: EqualPaymentProcessing.Layout

    public init(step: Int = 1, layout: EqualPaymentProcessing.Layout = .floating) {
        self.step = step
        self.layout = layout
    }

    public var body: some View {
        EqualPaymentProcessing(step: step, layout: layout, title: "Activating Equal Gold")
            .ignoresSafeArea()
    }
}

struct ActivatingGoldScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivatingGoldScreen()
            ActivatingGoldScreen(step: 3, layout: .list)
            ActivatingGoldScreen(step: 2, layout: .backdrop)
        }
    }
}
