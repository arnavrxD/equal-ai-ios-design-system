# SwipeToStart

"Swipe to start using Gold": a 66pt capsule in `buttonPrimary` (green, lime in dark) with a white (dark `#222`) knob carrying the six Equal dots. Dragging past 80% completes; releasing earlier springs back. The label fades as the knob moves.

- States: idle, dragging, completed.
- Pass the title and `onComplete`. VoiceOver exposes it as a button with an activate action.
- Do sit it in a 109pt bottom container fading from the page colour.
- Don't use it for destructive or paid actions.
