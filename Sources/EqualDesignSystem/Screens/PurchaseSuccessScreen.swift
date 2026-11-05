import SwiftUI

/// Purchase success: `EqualSuccessState` (mascot at y272 with the glow, star outline and check)
/// and "Thank you for trusting Equal" at the bottom. Continues on its own after 2.8s or on tap
/// when `onContinue` is set.
public struct PurchaseSuccessScreen: View {
    let kind: EqualSuccessState.Kind
    let onContinue: (() -> Void)?

    public init(_ kind: EqualSuccessState.Kind = .upgraded("Gold Plus"), onContinue: (() -> Void)? = nil) {
        self.kind = kind
        self.onContinue = onContinue
    }

    public init(kind: EqualSuccessState.Kind, onContinue: (() -> Void)? = nil) {
        self.init(kind, onContinue: onContinue)
    }

    /// Success for a flow and the plan that was bought ("Welcome back" for a Gold renewal).
    public init(flow: EqualPurchaseFlow, plan: EqualStickyPlanSheet.Plan? = nil, onContinue: (() -> Void)? = nil) {
        self.init(flow.successKind(for: plan ?? flow.defaultPlan), onContinue: onContinue)
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualSuccessState(kind).padding(.top, 272)
            Spacer(minLength: 0)
            Text("Thank you for trusting Equal").font(.equal(size: 14)).foregroundStyle(EqualColor.grey05)
                .padding(.bottom, 56)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(EqualColor.grey14)
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture { onContinue?() }
        .task {
            guard let onContinue else { return }
            try? await Task.sleep(for: .seconds(2.8))
            if !Task.isCancelled { onContinue() }
        }
        .environment(\.colorScheme, .light)
    }
}

struct PurchaseSuccessScreen_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseSuccessScreen()
        PurchaseSuccessScreen(flow: .planExpired)
        PurchaseSuccessScreen(.trialStarted(days: 7))
    }
}
