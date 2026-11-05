# FAQItem

Accordion FAQ in a radius-20 card with 0.3pt black 8% hairlines: Medium 16 question, 12pt caret (black 32%) that flips when open, answer Regular 14 (line height 20, tracking 0.5%) 18pt below. FAQList adds "Still have questions?" 24pt below.

- Styles (`EqualFAQStyle`): `.light`, `.dark` (#222 card, #F7F7F7 / #BBB text), `.expired` (SemiBold questions, #DADADA dividers, plain help link).
- Pass: `EqualFAQList(items, style:, onHelp:)` or `EqualFAQItem(faq, isOpen:, style:)`. The first item opens by default.
