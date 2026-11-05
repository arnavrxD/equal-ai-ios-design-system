Equal AI is a personal AI call assistant for iPhone users in India. It answers unknown calls, screens spam, takes messages and turns every call into a one-tap follow-up. This system covers the onboarding, home/chat, permissions, Gold paywall, payment and settings screens of the iOS app (Figma: EQAI-iOS → "Oboarding/Paywall Changes"). Components are organised by atomic level: **1 · Atoms → 2 · Molecules → 3 · Organisms**. Full screens are in the **Screens** asset group as reference.

## Content fundamentals

- Speak to the user as "you"; the assistant is "your assistant" or "Equal". Equal speaks in first person only inside chat ("What can I help you with today?").
- Be short and concrete. Titles state the task ("Enter phone number", "Choose your plan"); subtitles give the reason ("Assistant will handle calls for this number").
- Chat summaries say what the assistant learned, not what the caller said: "Driver has come to location", "Home loan offer especially for you".
- Action labels are verbs: "Call back", "Add to Calendar", "Open settings", "Send voice note". Paywall CTAs always carry the price: "Get Gold Plus for ₹499/month".
- Local by default: ₹ prices, +91 numbers, UPI autopay steps, Indian names, Hindi/English/Telugu languages.
- Emoji appear as action-chip glyphs (📞 🗓️ 🔕 🛑 ✏️ 📝) and once in celebration ("You’re on Gold Plus 🎉"). Never as section markers.
- Gold copy sells the time saved, using the user's own numbers: "2h 22m saved on calls you didn’t have to take", "Don’t make it start over."

## Visual foundations

**Color.** Two brand hues: `brand-green` (#00B140) for actions and `brand-lime` (#BAFF29) for highlights and gradients. UI is built on the semantic tokens from the Figma "Allias" collection, which have light and dark values: `bg-primary` page, `bg-surface` cards, `text-primary` / `text-secondary` text, `button-primary` CTAs, `stroke-subtle` / `stroke-medium` hairlines, `unread-fill` + `unread-stroke` for anything that needs attention. The 14-step `grey-*` and `red-*` primitives feed them; reach primitives only through a semantic token. The Gold world (paywall, membership, trial) has its own literal palette: `gold-ink`, `gold-deep`, `gold-label`, `gold-border` and the compare-table tints. It is light-only.
- Green text on white (`text-action`) is 3.0:1. The file uses it only at 13px semibold and up (unread timestamps, links); keep it there. `text-placeholder` is for placeholders only.
- Avatar tints (`avatar-*`) encode caller category; don't use them elsewhere.

**Type.** DM Sans everywhere, with the file's 22 iOS-mapped text styles (`large-title` … `caption-2`, each with an `-em` weight) and -2.6% tracking. Most-used: `body` 17/22 for previews, `callout` 16/21 for chips, `headline-em` 18/22 for names, `title-2-em` 22/28 for screen titles. Uppercase only for small labels (`section-label`, `group-label`, `eyebrow-gold`) with positive tracking. SF Pro appears only inside SF Symbols icons; every piece of text, including system-style sheets and banners, is DM Sans.

**Spacing and layout.** iPhone 15 Pro frame, 393×852. Content is 345 wide with a 24px gutter (`space-24`). Lists use 12px gaps (`space-12`); chips 16px horizontal / 8px vertical padding; paywall sections 48px apart (`space-48`); settings sections 32px.

**Shape.** Pills (`radius-full`) for every button, chip, search bar and pill; `radius-m` 16px for inputs, cards, tables and settings groups; `radius-l` 20px for FAQ and feature cards; `radius-xl` 28px for bottom-sheet tops; `radius-s` 8px for chat bubbles.

**Depth.** Flat surfaces with hairlines; shadows stay soft and short (`shadow-chip`, `shadow-card`). Floating controls use iOS liquid glass: `glass-button` / `bg-nav-bottom` fills with backdrop blur and `stroke-subtle`. Sheets lift with `shadow-sheet` over `bg-overlay`.

**Gradients.** `gradient-voice` (lime → green) marks Equal itself: the FAB, the voice button, the Equal dot. Suggested chips fade from 8% lime to lime. The Gold world uses `gradient-gold-hero`, `gradient-cta-gold`, `gradient-membership` and `gradient-gold-text`.

**Imagery.** Soft 3D renders: the green robot mascot (with or without a crown), the gold crown, a bell, a gear, category avatars, 3D people. They sit on tinted circles or float on glows; never crop or recolor them.

**Motion.** Lottie loops on payment steps and the live-call card; shimmer on "Thinking...". Respect reduced motion.

**States.** Unread / suggested = lime fill + green stroke + green time + count. Selected = green border (inputs, gender cards) or gold border + glow (plans). Disabled = `button-disabled` with `text-on-action-disabled`. Focus ring: 2px `green` outline, 2px offset.

## Iconography

The file uses SF Symbols (chevron 􀆊, chat, phone glyphs inside text), Material icons (search, more_horiz, close, support_agent, keyboard_arrow_down) and emoji. The bundle's `Icon` component redraws the needed UI glyphs as 24px line icons on a 1.8 stroke in `currentColor`; it is a stand-in, not the original SF Symbols. The original icons, exported as SVG from the file, are in the **Icons** asset group (75 files: navigation, calls, voice and chat, notifications, selection, Gold and paywall, brand marks). Brand marks are in **Logos**, 3D illustrations in **Illustrations**, whole screens in **Screens** and **Flows**.

## Using the components

React components live on `window.EqualDS`. Build screens from organisms, organisms from molecules, molecules from atoms:
- Home = `AppHeader` + `PromoCard` + `SearchBar` + `ChatList` + `TabBar`.
- Equal sheet = `SheetHeader` / `EqualSheet` + `ChatBubble` + `Chip` + `Composer`.
- Paywall = `PaywallHero` + `RecapCard` + `ComparePlansTable` + `FeatureCard` carousel + `FAQItem`s + `StickyPlanSheet`.
- Settings = `ProfileHeader` + `MembershipCard` + `AssistantToggleCard` + `SettingsRow` groups + `InviteCard`.

Images come from `EqualDS.assets` (uploaded files). Token names map to CSS custom properties (`var(--button-primary)`).

## Not synced

Lottie animations, the keyboard and status-bar system components, and the dark appearance of the Gold screens (only the semantic tokens define dark values). Notes and component docs paraphrase the Figma file; component names were assigned here because most layers in the file are unnamed frames.
