import SwiftUI

/// One FAQ entry.
public struct EqualFAQ: Identifiable, Sendable {
    public let id = UUID()
    public let question: String
    public let answer: String
    public init(_ question: String, _ answer: String) { self.question = question; self.answer = answer }

    public static let paywall: [EqualFAQ] = [
        EqualFAQ("Is Equal AI free on iPhone?", "Equal AI offers a 1-week free trial for new users. After the trial ends, you’ll need an active subscription to continue using the assistant."),
        EqualFAQ("How does the free trial work?", "Your assistant handles calls for 7 days with every Gold feature unlocked."),
        EqualFAQ("Will I keep access if I cancel during the free trial?", "Yes, until the trial ends.")
    ]
}

/// Accordion row: medium 16pt question, a grey caret that flips when open, 14pt answer.
public struct EqualFAQItem: View {
    let faq: EqualFAQ
    @State private var isOpen: Bool

    public init(_ faq: EqualFAQ, isOpen: Bool = false) {
        self.faq = faq
        self._isOpen = State(initialValue: isOpen)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s8) {
            Button { withAnimation(.snappy) { isOpen.toggle() } } label: {
                HStack(spacing: EqualSpacing.s32) {
                    Text(faq.question).font(.equal(size: 16, weight: .medium)).foregroundStyle(EqualColor.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                    EqualIconView(.chevronDown, size: 14, weight: .semibold).foregroundStyle(EqualColor.strokeDark)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
            }
            .buttonStyle(.plain)
            .accessibilityValue(isOpen ? "Expanded" : "Collapsed")
            if isOpen {
                Text(faq.answer).font(.equal(size: 14)).lineSpacing(3).foregroundStyle(EqualColor.textSecondary)
                    .transition(.opacity)
            }
        }
        .padding(EqualSpacing.s16)
    }
}

/// White radius-20 group of FAQ items with hairlines, plus the "Still have questions?" link.
public struct EqualFAQList: View {
    let items: [EqualFAQ]
    let onHelp: () -> Void

    public init(_ items: [EqualFAQ] = EqualFAQ.paywall, onHelp: @escaping () -> Void = {}) {
        self.items = items
        self.onHelp = onHelp
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s24) {
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
                    if i > 0 { Rectangle().fill(EqualColor.strokeMedium).frame(height: 0.5) }
                    EqualFAQItem(item, isOpen: i == 0)
                }
            }
            .background(RoundedRectangle(cornerRadius: EqualRadius.l).fill(EqualColor.bgSurface))
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.l).stroke(EqualColor.strokeMedium, lineWidth: 1))

            Button(action: onHelp) {
                Label("Still have questions?", systemImage: "headphones")
                    .font(.equal(size: 16, weight: .medium)).underline()
                    .foregroundStyle(EqualColor.textPrimary)
            }
            .buttonStyle(.plain)
        }
    }
}

struct EqualFAQItem_Previews: PreviewProvider {
    static var previews: some View { EqualFAQList().padding(24).equalScreenBackground() }
}
