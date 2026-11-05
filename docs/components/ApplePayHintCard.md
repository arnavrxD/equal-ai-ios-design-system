# ApplePayHintCard

`EqualApplePayHintCard` tells the user how to confirm with Apple Pay on the "Activating Equal Gold" wait screen: a 40pt `#674F16` tile with the Face ID glyph, then "**Apple Pay** · Double-click the side button, then Face ID. You stay right here." in DM Sans 13/18. 16pt padding, 18pt gap, radius 16; 332×72 at the screen's 332pt width.

- Styles: `.plain` (white, no shadow; list layout), `.raised` (white with a 4pt black 16% glow; default), `.translucent` (white at 20% with the glow). Dark: `#222` card, white text.
- Pass: optionally `title`, `message`, `icon` (default `.faceID`) and `style`.
- Do give it a fixed 332pt width on the wait screen. Don't show it on UPI-only builds (families D and E drop it).
