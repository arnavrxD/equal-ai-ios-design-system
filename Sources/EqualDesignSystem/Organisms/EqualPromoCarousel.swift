import SwiftUI

/// Paging row of home promo cards: 322pt cards 24pt apart with the next card peeking past the
/// right edge, and page dots 16pt below. Swipe to page; a single card fills the width alone.
public struct EqualPromoCarousel: View {
    let kinds: [EqualPromoCard.Kind]
    let cardWidth: CGFloat
    let leadingInset: CGFloat
    let onAction: (EqualPromoCard.Kind) -> Void
    let onDismiss: (EqualPromoCard.Kind) -> Void
    @State private var page = 0
    @GestureState private var drag: CGFloat = 0

    /// - Parameters:
    ///   - kinds: cards in order (the permission card first, then Meet Your Assistant).
    ///   - leadingInset: x of the first card (28 on the current home, 24 on the legacy home).
    public init(_ kinds: [EqualPromoCard.Kind], cardWidth: CGFloat = 322, leadingInset: CGFloat = 28,
                onAction: @escaping (EqualPromoCard.Kind) -> Void = { _ in }, onDismiss: @escaping (EqualPromoCard.Kind) -> Void = { _ in }) {
        self.kinds = kinds
        self.cardWidth = cardWidth
        self.leadingInset = leadingInset
        self.onAction = onAction
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(spacing: 12) {
            Color.clear
                .frame(height: 168)
                .overlay(alignment: .leading) {
                    HStack(spacing: 24) {
                        ForEach(Array(kinds.enumerated()), id: \.offset) { _, kind in
                            EqualPromoCard(kind, onDismiss: { onDismiss(kind) }, action: { onAction(kind) })
                                .frame(width: cardWidth)
                        }
                    }
                    .fixedSize()
                    .padding(.leading, leadingInset)
                    .offset(x: -CGFloat(page) * (cardWidth + 24) + drag)
                }
                .frame(maxWidth: .infinity)
                .clipped()
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 10)
                    .updating($drag) { v, s, _ in s = v.translation.width }
                    .onEnded { v in
                        let step = (cardWidth + 24) / 2
                        let target = page + (v.predictedEndTranslation.width < -step ? 1 : (v.predictedEndTranslation.width > step ? -1 : 0))
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { page = min(max(target, 0), kinds.count - 1) }
                    }
            )
            .animation(.interactiveSpring, value: drag)
            .accessibilityElement(children: .contain)
            .accessibilityScrollAction { edge in
                withAnimation { page = edge == .trailing ? min(page + 1, kinds.count - 1) : max(page - 1, 0) }
            }
            if kinds.count > 1 {
                EqualPageDots(count: kinds.count, active: page)
            }
        }
    }
}

struct EqualPromoCarousel_Previews: PreviewProvider {
    static var previews: some View {
        EqualPromoCarousel([.permissions, .meetAssistant, .callPreferences])
            .frame(width: 393)
            .padding(.vertical, 24)
            .equalScreenBackground()
    }
}
