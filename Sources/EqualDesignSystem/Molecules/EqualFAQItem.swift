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

/// Visual style shared by `EqualFAQItem` and `EqualFAQList`.
public enum EqualFAQStyle: Sendable {
    /// White card, Medium 16 questions (paywalls).
    case light
    /// #222 card, #F7F7F7 questions, #BBB answers (dark soft paywall).
    case dark
    /// Subscription-expired page: SemiBold 16 questions, #DADADA dividers, plain help link.
    case expired
}

/// Accordion row: a 16pt question with a grey caret that flips when open, then the 14pt answer
/// 18pt below (line height 20, tracking 0.5%).
public struct EqualFAQItem: View {
    let faq: EqualFAQ
    let style: EqualFAQStyle
    @State private var isOpen: Bool

    public init(_ faq: EqualFAQ, isOpen: Bool = false, style: EqualFAQStyle = .light) {
        self.faq = faq
        self.style = style
        self._isOpen = State(initialValue: isOpen)
    }

    private var questionColor: Color { style == .dark ? Color(equalHex: 0xF7F7F7) : EqualColor.grey01 }
    private var answerColor: Color { style == .dark ? EqualColor.grey11 : EqualColor.grey05 }
    private var chevronColor: Color {
        switch style {
        case .light: Color.black.opacity(0.32)
        case .dark: Color.white.opacity(0.4)
        case .expired: Color(equalHex: 0x7A7A7A)
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Button { withAnimation(.snappy) { isOpen.toggle() } } label: {
                HStack(alignment: .top, spacing: EqualSpacing.s32) {
                    Text(faq.question).font(.equal(size: 16, weight: style == .expired ? .semibold : .medium))
                        .foregroundStyle(questionColor)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                    EqualIconView(.chevronDown, size: 12, weight: .semibold).foregroundStyle(chevronColor)
                        .frame(width: 24, height: 21)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityValue(isOpen ? "Expanded" : "Collapsed")
            if isOpen {
                Text(faq.answer).font(.equal(size: 14)).tracking(0.07).lineSpacing(1.8).foregroundStyle(answerColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            }
        }
        .padding(EqualSpacing.s16)
    }
}

/// Radius-20 group of FAQ items with 0.3pt hairlines, plus the "Still have questions?" link 24 below.
public struct EqualFAQList: View {
    let items: [EqualFAQ]
    let style: EqualFAQStyle
    let onHelp: () -> Void

    public init(_ items: [EqualFAQ] = EqualFAQ.paywall, style: EqualFAQStyle = .light, onHelp: @escaping () -> Void = {}) {
        self.items = items
        self.style = style
        self.onHelp = onHelp
    }

    private var divider: Color {
        switch style {
        case .light: Color.black.opacity(0.08)
        case .dark: Color.white.opacity(0.16)
        case .expired: Color(equalHex: 0xDADADA)
        }
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s24) {
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { i, item in
                    if i > 0 { Rectangle().fill(divider).frame(height: style == .expired ? 1 : 0.3).padding(.horizontal, EqualSpacing.s16) }
                    EqualFAQItem(item, isOpen: i == 0, style: style)
                }
            }
            .background(RoundedRectangle(cornerRadius: EqualRadius.l).fill(style == .dark ? EqualColor.grey02 : Color.white))
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.l).strokeBorder(cardStroke, lineWidth: 1))

            Button(action: onHelp) {
                if style == .expired {
                    Text("Still have questions?").font(.equal(size: 15)).foregroundStyle(EqualColor.grey05)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "headphones").font(.system(size: 19, weight: .medium))
                        Text("Still have questions?").font(.equal(size: 16, weight: .medium)).underline()
                    }
                    .foregroundStyle(style == .dark ? Color(equalHex: 0xF7F7F7) : EqualColor.grey01)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var cardStroke: Color {
        switch style {
        case .light: EqualColor.strokeMedium
        case .dark: Color.white.opacity(0.16)
        case .expired: Color.black.opacity(0.1)
        }
    }
}

struct EqualFAQItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            EqualFAQList()
            EqualFAQList(style: .dark)
        }
        .padding(24)
        .background(EqualColor.grey14)
    }
}
