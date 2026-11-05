# PaywallHero

Paywall top: a gold shape fading from white to gold, eight soft rays and the 3D crown, the frost close button with "Restore purchases", and the title block. Positions follow the 393pt Figma frames from the top of the screen, so place it under the status bar.

- Shapes: `.circle` (A, crown + rays, title y191), `.compactArc` (B, no crown), `.shallowArc` (C, 1114pt arc), `.roundedBottom(28)` (D, crown) / `.roundedBottom(48)` (E, compact), `.dome` (paywall v2).
- Tints: `.gold` (white → #FFC927), `.sunrise` (white → #FED354, Gold limit), `.warm` (4-stop, other limit flows).
- Pass: `title`, `subtitle` (Text, "1 day" bold), `preTitle` (limit paywalls: SemiBold 16 line above an ExtraBold 28 title), `shape`, `tint`, `showsCrown`, `showsTopBar`, `showsClose`, `onClose`, `onRestore`.
- Do keep the top bar (Figma 35117 drops it; App Review expects a dismiss). Don't add a tracking to the title (Figma 0).
