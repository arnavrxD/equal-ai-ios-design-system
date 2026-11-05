# SectionLabel

`EqualSectionLabel` is the section header, usually centred between rules that fade out towards the edges. Text is DM Sans (Figma used Geist Bold 14 for some uppercase headers; this follows the DM Sans rule at the same size).

- `.hairlines`: uppercase Bold 13 in `legal-text`, grey rules that stretch ("COMPARE PLANS").
- `.gold`: uppercase Bold 14 in `text-secondary`, warm gold rules that stretch ("WHAT YOU GET", "FREQUENTLY ASKED QUESTIONS").
- `.goldFixed(ruleWidth:)`: the newer gold header: uppercase Bold 14, no tracking, `#555555` at 70% (dark `#BBBBBB`), fixed gold rules (106pt default), gap 6.
- `.howToConfirm`: "HOW TO CONFIRM": uppercase Bold 14, no tracking, `#5E5E5E` at 70%, fixed 95pt gold rules, gap 6.
- `.goldSentence`: "Using UPI? Follow these steps:": sentence case SemiBold 13/18, -2.6%, `#553B00` at 70% (dark `#BBBBBB`), no rules.
- `.goldSentenceRules`: the same text between fixed 69pt gold rules, gap 6 (UPI-only and "Processing payment" screens).
- `.group`: left-aligned uppercase settings label ("YOUR ASSISTANT").
- Pass: the text as written (uppercase styles transform it) and a style.
- Do use the fixed-rule styles where Figma has fixed rule widths. Don't upper-case `.goldSentence` text.
