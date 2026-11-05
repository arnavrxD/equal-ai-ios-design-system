import SwiftUI

/// UPI autopay processing. Kept for source compatibility: a thin wrapper around `UpiWaitScreen`,
/// which owns the layout and the step animation.
public struct PaymentProcessingScreen: View {
    public init() {}
    public var body: some View { UpiWaitScreen() }
}

struct PurchaseFlowScreens_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProcessingScreen()
    }
}
