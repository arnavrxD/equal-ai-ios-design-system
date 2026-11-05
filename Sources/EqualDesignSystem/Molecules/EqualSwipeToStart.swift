import SwiftUI

/// "Swipe to start using Gold": a 66pt green capsule (lime in dark mode) with a white knob carrying
/// the six Equal dots. Drag the knob to the end to start the trial; the label fades as it moves and
/// the knob springs back if released early.
public struct EqualSwipeToStart: View {
    let title: String
    let onComplete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var isComplete = false

    private let knob = CGSize(width: 73, height: 57)
    private let inset: CGFloat = 6

    public init(_ title: String = "Swipe to start using Gold", onComplete: @escaping () -> Void = {}) {
        self.title = title
        self.onComplete = onComplete
    }

    public var body: some View {
        GeometryReader { geo in
            let travel = max(1, geo.size.width - knob.width - inset * 2)
            ZStack(alignment: .leading) {
                Capsule().fill(EqualColor.buttonPrimary)
                Text(title)
                    .equalTextStyle(.bodyEm)
                    .foregroundStyle(EqualColor.textOnAction)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, knob.width + inset)
                    .padding(.trailing, EqualSpacing.s8)
                    .opacity(1 - min(1, offset / travel * 1.6))
                knobView
                    .offset(x: inset + offset)
                    .gesture(
                        DragGesture(minimumDistance: 2)
                            .onChanged { v in
                                guard !isComplete else { return }
                                offset = min(max(0, v.translation.width), travel)
                            }
                            .onEnded { _ in
                                guard !isComplete else { return }
                                if offset > travel * 0.8 { complete(travel) } else {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { offset = 0 }
                                }
                            }
                    )
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(title)
            .accessibilityAddTraits(.isButton)
            .accessibilityAction { complete(travel) }
        }
        .frame(height: 66)
    }

    private var knobView: some View {
        Capsule().fill(EqualColor.bgSurface)
            .frame(width: knob.width, height: knob.height)
            .overlay {
                VStack(spacing: 5) {
                    ForEach(0..<2, id: \.self) { _ in
                        HStack(spacing: 0) { ForEach(0..<3, id: \.self) { _ in Circle().frame(width: 10, height: 10) } }
                    }
                }
                .foregroundStyle(EqualColor.buttonPrimary)
            }
    }

    private func complete(_ travel: CGFloat) {
        withAnimation(.snappy) { offset = travel }
        isComplete = true
        onComplete()
    }
}

struct EqualSwipeToStart_Previews: PreviewProvider {
    static var previews: some View {
        EqualPreviewPair { EqualSwipeToStart().frame(width: 335) }
    }
}
