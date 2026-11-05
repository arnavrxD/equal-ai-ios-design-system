import SwiftUI

/// UPI autopay waiting screen: crown loader, "Processing payment" and the current step.
public struct EqualPaymentProcessing: View {
    public static let steps = [
        "Open your UPI app, via notifications or directly",
        "Review and approve the autopay request",
        "Enter your UPI pin to confirm purchase",
        "Come back to Equal AI app to continue"
    ]
    let step: Int

    /// - Parameter step: 1 to 4.
    public init(step: Int = 1) { self.step = min(max(step, 1), 4) }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            EqualCrownLoader(size: 80)
            Text("Processing payment").font(.equal(size: 22, weight: .bold)).foregroundStyle(Color.black)
            Text("Waiting for your confirmation...").font(.equal(size: 15)).foregroundStyle(Color.black.opacity(0.6))
            HStack(spacing: EqualSpacing.s8) {
                Rectangle().fill(Color(equalHex: 0x553B00, alpha: 0.2)).frame(height: 1)
                Text("Using UPI? Follow these steps:").font(.equal(size: 13, weight: .semibold)).foregroundStyle(Color(equalHex: 0x553B00)).fixedSize()
                Rectangle().fill(Color(equalHex: 0x553B00, alpha: 0.2)).frame(height: 1)
            }
            .padding(.vertical, EqualSpacing.s8)
            EqualUpiStep(step, Self.steps[step - 1])
        }
        .multilineTextAlignment(.center)
        .padding(EqualSpacing.s24)
        .frame(maxWidth: .infinity)
        .background(EqualGradient.processing)
    }
}
