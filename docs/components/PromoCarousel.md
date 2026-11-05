# PromoCarousel

Paging row of home promo cards: 322pt `EqualPromoCard`s 24pt apart with the next card peeking past the right edge, and `EqualPageDots` 16pt below. Swipe (or the accessibility scroll action) moves one card at a time.

- Variants: any number of cards; one card hides the dots.
- Consumer passes: the card kinds in order (the permission card first, Meet Your Assistant second), `leadingInset` (28 current home, 24 legacy), `onAction`, `onDismiss`.
- Do lead with the card for what is missing (Enable Permissions, Notification access or Contact access).
- Don't mix carousel cards with a standalone card on the same home.
