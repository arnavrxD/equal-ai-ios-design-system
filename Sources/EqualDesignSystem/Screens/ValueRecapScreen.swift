import SwiftUI

/// The last-day story before the paywall: `EqualValueRecapStory` full screen. The progress bar
/// fills over 10 seconds, then `onFinish` opens the paywall; Skip does it straight away.
public struct ValueRecapScreen: View {
    let duration: Double
    let onSkip: () -> Void
    let onFinish: () -> Void
    @State private var progress: Double

    /// - Parameter startProgress: where the bar starts (previews show it mid-way).
    public init(duration: Double = 10, startProgress: Double = 0, onSkip: @escaping () -> Void = {}, onFinish: @escaping () -> Void = {}) {
        self.duration = duration
        self.onSkip = onSkip
        self.onFinish = onFinish
        self._progress = State(initialValue: startProgress)
    }

    public var body: some View {
        EqualValueRecapStory(progress: progress, onSkip: onSkip)
            .ignoresSafeArea()
            .task {
                let remaining = duration * (1 - progress)
                withAnimation(.linear(duration: remaining)) { progress = 1 }
                try? await Task.sleep(for: .seconds(remaining))
                if !Task.isCancelled { onFinish() }
            }
    }
}

struct ValueRecapScreen_Previews: PreviewProvider {
    static var previews: some View { ValueRecapScreen(startProgress: 0.45) }
}
