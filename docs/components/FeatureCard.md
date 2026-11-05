# FeatureCard

"What you get" carousel card: an art panel over a SemiBold 17 title and a 12pt description. The art panels are flattened Figma exports (`EqualImage.featureArt…`); tags, borders, glows and pills are code.

- Styles: `.exclusive` (280×292, radius 20, gold border + 3pt #F7CB3C 14% ring, crown and "30 calls a month → Unlimited" pills, "Only in Gold Plus"), `.standard` (303×292, radius 16, black 8% border, "Both plans"), `.trial` (303×292, no tag or border, follows dark mode), `.hero` (full-bleed 393×319 art with centred text, carousel-first paywall).
- Pass: `EqualFeatureCard(content, style:)` with `EqualFeatureCard.Content.paywall` (the seven Figma cards), or the legacy `title:message:isExclusive:art:style:`.
- Do show page dots matching the card count (7). Don't stretch the art panel: it is 303×207.
