# ChatBubble

Messages in the Equal thread. **user** bubbles sit right on `bubble-user-bg` with a "You" label in `bubble-user-title`; **assistant** bubbles sit left on `bg-surface` with an "Equal AI" label in `green` and, for the first in a run, the Equal dot avatar. `radius-s`, 12px padding, `bubble-time` timestamp bottom-right. An optional inline action ("+ Get more calls") sits under a hairline.

- Props: `from` user | assistant, `label`, `time`, `withAvatar`, `action`, `children`.
