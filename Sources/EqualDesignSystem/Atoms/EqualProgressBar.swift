import SwiftUI

/// 4pt progress: green on a 10% track (walkthrough), gold on the dark value-recap story.
public struct EqualProgressBar: View {
    public enum Tone: Sendable { case green, gold }
    let value: Double
    let tone: Tone
    public init(value: Double, tone: Tone = .green) { self.value = value; self.tone = tone }
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(tone == .gold ? Color.white.opacity(0.18) : Color.black.opacity(0.1))
                Capsule().fill(tone == .gold ? EqualColor.goldLabel : EqualColor.green)
                    .frame(width: geo.size.width * min(max(value, 0), 1))
            }
        }
        .frame(height: 4)
        .accessibilityValue("\(Int(value * 100)) percent")
    }
}
