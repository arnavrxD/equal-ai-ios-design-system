# TabBar

Floating bottom navigation: a liquid-glass capsule (white 16% over a material, `0 0 8 #000@24%` shadow) with **Chats** and **You** (the avatar in a 26pt gold-rimmed scalloped badge); the selected tab sits on a lime-8% pill. A 20pt green unread badge (Bold 12 `#F7F7F7`) sits at (49,6) on the capsule. Beside it, the 64pt Equal FAB on the voice gradient opens the Equal sheet.

- Consumer passes: `selection`, `unread`, `onEqual`.
- Do float it over a fade (`EqualGradient.fadeBottom`).
- Don't add tabs: the FAB carries every action.
