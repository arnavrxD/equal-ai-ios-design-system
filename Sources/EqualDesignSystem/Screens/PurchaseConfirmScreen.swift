import SwiftUI

/// Purchase confirmation (24539:8465 → 24539:8824): the payment-processing screen dimmed (black
/// 40%, blur 12), Equal's `EqualPurchaseConfirmSheet` slid up from the bottom and the
/// "Double click to Subscribe" side-button hint at the top right.
public struct PurchaseConfirmScreen: View {
    let animatesIn: Bool
    let onClose: () -> Void
    @State private var isPresented: Bool

    /// - Parameter animatesIn: starts with the sheet parked off-screen (24539:8465) and springs it up on appear.
    public init(animatesIn: Bool = false, onClose: @escaping () -> Void = {}) {
        self.animatesIn = animatesIn
        self.onClose = onClose
        self._isPresented = State(initialValue: !animatesIn)
    }

    public var body: some View {
        ZStack {
            PaymentProcessingScreen()
                .blur(radius: isPresented ? 6 : 0)
                .allowsHitTesting(false)
            Color.black.opacity(isPresented ? 0.4 : 0).ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            EqualSideButtonHint()
                .padding(.top, 147)
                .padding(.trailing, 6)
                .opacity(isPresented ? 1 : 0)
        }
        .overlay(alignment: .bottom) {
            EqualPurchaseConfirmSheet(onClose: onClose)
                .padding(.horizontal, EqualSpacing.s8)
                .padding(.bottom, EqualSpacing.s8)
                .offset(y: isPresented ? 0 : 520)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            guard animatesIn else { return }
            withAnimation(.spring(response: 0.45, dampingFraction: 0.85).delay(0.2)) { isPresented = true }
        }
    }
}

struct PurchaseConfirmScreen_Previews: PreviewProvider {
    static var previews: some View { PurchaseConfirmScreen() }
}
