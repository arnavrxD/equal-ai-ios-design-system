import SwiftUI

/// UPI autopay processing, stepping through the four instructions.
public struct PaymentProcessingScreen: View {
    @State private var step = 1
    public init() {}
    public var body: some View {
        VStack {
            Spacer()
            EqualPaymentProcessing(step: step)
            Spacer()
        }
        .background(EqualGradient.processing.ignoresSafeArea())
        .task {
            while step < 4 {
                try? await Task.sleep(for: .seconds(2.5))
                withAnimation { step += 1 }
            }
        }
    }
}

struct PurchaseFlowScreens_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProcessingScreen()
    }
}
