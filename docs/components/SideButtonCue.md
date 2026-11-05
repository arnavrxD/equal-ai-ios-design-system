# SideButtonCue

The 4×84 iOS-blue bar with an 80% glow pinned to the right screen edge beside the hardware side button, shown while the App Store confirmation asks to "Double-click side button to pay". Pulses gently unless Reduce Motion is on.

- Pass: `y` (top of the bar, 190 on a 393×852 iPhone). Place with `.overlay(alignment: .topTrailing)` on the screen, ignoring the safe area.
- Do show it only while EqualAppStoreSheet is up. Don't use it with Equal's own purchase sheet (that uses SideButtonHint).
