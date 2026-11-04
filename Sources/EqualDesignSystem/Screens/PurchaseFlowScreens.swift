import SwiftUI

/// The last-day story before the paywall.
public struct ValueRecapScreen: View {
    let onSkip: () -> Void
    public init(onSkip: @escaping () -> Void = {}) { self.onSkip = onSkip }
    public var body: some View { EqualValueRecapStory(onSkip: onSkip) }
}

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

/// Purchase success.
public struct PurchaseSuccessScreen: View {
    let kind: EqualSuccessState.Kind
    public init(_ kind: EqualSuccessState.Kind = .upgraded("Gold Plus")) { self.kind = kind }
    public var body: some View {
        VStack {
            Spacer()
            EqualSuccessState(kind)
            Spacer()
            Text("Thank you for trusting Equal").font(.equal(size: 13)).foregroundStyle(EqualColor.textSecondary).padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity)
        .equalScreenBackground()
    }
}

/// App Store confirmation over the paywall.
public struct AppStoreConfirmationScreen: View {
    public init() {}
    public var body: some View {
        ZStack(alignment: .bottom) {
            PaywallScreen()
            Color.black.opacity(0.4).ignoresSafeArea()
            EqualAppStoreSheet().padding(EqualSpacing.s8)
        }
    }
}

struct PurchaseFlowScreens_Previews: PreviewProvider {
    static var previews: some View {
        ValueRecapScreen()
        PaymentProcessingScreen()
        PurchaseSuccessScreen()
        PurchaseSuccessScreen(.trialStarted(days: 7))
        AppStoreConfirmationScreen()
    }
}
