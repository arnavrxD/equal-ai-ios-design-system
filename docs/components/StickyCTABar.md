# StickyCTABar

Bottom bar with one full-width CTA under a gold hairline (white, black in dark mode). Covers the soft-paywall "Start using Equal Gold", the paywall-v2 gold CTA with trial terms and legal line, and the green renew bar.

- Styles: `.gold` (107pt), `.goldTerms` (166pt; "Experience Gold for ₹249", terms, legal), `.renew` (133pt; green "Renew - ₹249/month", "Cancel anytime. Automatically renews").
- Pass `title`, `caption`, `legal` overrides and `action`.
- Do pin it with `.safeAreaInset(edge: .bottom)` and let it ignore the bottom safe area.
- The terms say ₹249/month after the trial (Figma's "then ₹499/month" contradicts the ₹249 CTA).
