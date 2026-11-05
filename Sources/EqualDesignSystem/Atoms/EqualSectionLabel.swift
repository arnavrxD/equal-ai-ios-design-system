import SwiftUI

/// Section header, usually centred between fading rules.
///
/// - `.hairlines`: uppercase, grey rules ("COMPARE PLANS").
/// - `.gold`: uppercase, warm gold rules that stretch ("WHAT YOU GET").
/// - `.goldFixed(ruleWidth:)`: the newer gold header: fixed-width gold rules (106pt), gap 6,
///   Bold 14, no tracking, `#555555` at 70% (dark `#BBBBBB`).
/// - `.howToConfirm`: "HOW TO CONFIRM" on the payment wait screen: 95pt gold rules, gap 6,
///   Bold 14, no tracking, `#5E5E5E` at 70%.
/// - `.goldSentence` / `.goldSentenceRules`: sentence-case "Using UPI? Follow these steps:",
///   SemiBold 13/18, `#553B00` at 70%, with no rules or with fixed 69pt gold rules.
/// - `.group`: the left-aligned settings label ("YOUR ASSISTANT").
public struct EqualSectionLabel: View {
    /// Text and rule treatment of a section label.
    public struct Style: Hashable, Sendable {
        enum Layout: Hashable, Sendable { case rules, textOnly, group }
        let layout: Layout
        let uppercase: Bool
        let size: CGFloat
        let weight: Font.Weight
        let tracking: CGFloat
        let textColor: Color
        let ruleColor: Color
        /// `nil` stretches the rules to fill the width.
        let ruleWidth: CGFloat?
        let gap: CGFloat

        /// Uppercase grey label between stretching grey hairlines ("COMPARE PLANS").
        public static let hairlines = Style(layout: .rules, uppercase: true, size: 13, weight: .bold, tracking: 0.52,
                                            textColor: EqualColor.legalText, ruleColor: Color.black.opacity(0.14), ruleWidth: nil, gap: EqualSpacing.s8)
        /// Uppercase label between stretching warm-gold hairlines ("WHAT YOU GET").
        public static let gold = Style(layout: .rules, uppercase: true, size: 14, weight: .bold, tracking: 0.52,
                                       textColor: EqualColor.textSecondary, ruleColor: Color(equalHex: 0xA37135, alpha: 0.5), ruleWidth: nil, gap: EqualSpacing.s8)
        /// Left-aligned settings group label ("YOUR ASSISTANT").
        public static let group = Style(layout: .group, uppercase: true, size: 14, weight: .semibold, tracking: 0.84,
                                        textColor: EqualColor.textPrimary, ruleColor: .clear, ruleWidth: nil, gap: 0)
        /// "HOW TO CONFIRM": Bold 14, no tracking, `#5E5E5E` at 70%, fixed 95pt gold rules, gap 6.
        public static let howToConfirm = Style(layout: .rules, uppercase: true, size: 14, weight: .bold, tracking: 0,
                                               textColor: .equalDynamic(light: 0x5E5E5E, lightAlpha: 0.7, dark: 0xBBBBBB),
                                               ruleColor: goldRule, ruleWidth: 95, gap: EqualSpacing.s6)
        /// "Using UPI? Follow these steps:" without rules: SemiBold 13/18, -2.6%, `#553B00` at 70%.
        public static let goldSentence = Style(layout: .textOnly, uppercase: false, size: 13, weight: .semibold, tracking: -0.338,
                                               textColor: sentenceColor, ruleColor: .clear, ruleWidth: nil, gap: 0)
        /// "Using UPI? Follow these steps:" between fixed 69pt gold rules, gap 6.
        public static let goldSentenceRules = Style(layout: .rules, uppercase: false, size: 13, weight: .semibold, tracking: -0.338,
                                                    textColor: sentenceColor, ruleColor: goldRule, ruleWidth: 69, gap: EqualSpacing.s6)

        /// Uppercase Bold 14 label, no tracking, `#555555` at 70%, between fixed gold rules
        /// (106pt in the paywall and settings reports), gap 6.
        public static func goldFixed(ruleWidth: CGFloat = 106) -> Style {
            Style(layout: .rules, uppercase: true, size: 14, weight: .bold, tracking: 0,
                  textColor: .equalDynamic(light: 0x555555, lightAlpha: 0.7, dark: 0xBBBBBB),
                  ruleColor: goldRule, ruleWidth: ruleWidth, gap: EqualSpacing.s6)
        }

        /// `#A37135` at 50% (dark: white 24%), faded to clear at the outer end.
        static let goldRule = Color.equalDynamic(light: 0xA37135, lightAlpha: 0.5, dark: 0xFFFFFF, darkAlpha: 0.24)
        static let sentenceColor = Color.equalDynamic(light: 0x553B00, lightAlpha: 0.7, dark: 0xBBBBBB)
    }

    let text: String
    let style: Style

    public init(_ text: String, style: Style = .hairlines) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        switch style.layout {
        case .group:
            label.frame(maxWidth: .infinity, alignment: .leading)
        case .textOnly:
            label
        case .rules:
            HStack(spacing: style.gap) {
                rule(leading: true)
                label.fixedSize()
                rule(leading: false)
            }
        }
    }

    private var label: some View {
        Text(style.uppercase ? text.uppercased() : text)
            .font(.equal(size: style.size, weight: style.weight))
            .tracking(style.tracking)
            .foregroundStyle(style.textColor)
            .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder private func rule(leading: Bool) -> some View {
        let colors = leading ? [style.ruleColor.opacity(0), style.ruleColor] : [style.ruleColor, style.ruleColor.opacity(0)]
        let line = LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing).frame(height: 1)
        if let w = style.ruleWidth { line.frame(width: w) } else { line }
    }
}

struct EqualSectionLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            EqualSectionLabel("Compare plans")
            EqualSectionLabel("What you get", style: .gold)
            EqualSectionLabel("What you get", style: .goldFixed())
            EqualSectionLabel("How to confirm", style: .howToConfirm)
            EqualSectionLabel("Using UPI? Follow these steps:", style: .goldSentence)
            EqualSectionLabel("Using UPI? Follow these steps:", style: .goldSentenceRules)
            EqualSectionLabel("Your assistant", style: .group)
        }
        .padding(24)
        .background(EqualGradient.processing)
    }
}
