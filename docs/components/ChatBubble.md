# ChatBubble

Messages in the Equal thread. **user** bubbles sit right on `#E8FFED` with a "You" label (`#006223`, 8pt gap) and a `#555` time; **assistant** bubbles sit left on white, 10pt after the 28pt Equal dot, with "Equal AI" in green (2pt gap) and a `#111111` time. The first assistant bubble of a run carries the curved `EqualBubbleTail`. An optional inline action sits 12pt under the text: a 42pt row under a hairline inset to the text column, SF Symbol + Medium 16 in `#00B140`.

- Consumer passes: text, `from`, `label`, `time`, `showsAvatar`, `showsTail` (defaults to `showsAvatar`), `actionTitle`, `actionIcon` (`.plus` for "Get more calls", `.star` for "See plans", "Subscribe now", "Renew now"), `action`.
- Do stack assistant bubbles 6pt apart; max width 280.
- Don't put more than one action in a bubble.
