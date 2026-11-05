import SwiftUI

/// "Processing payment" loading-state education: the ring loader spins while the four UPI AutoPay
/// steps advance on their own, each with its phone illustration rising into place.
///
/// Light and dark (follows the colour scheme; dark uses the UPI-app styled phone). The app cannot see
/// the UPI app, so the steps run on a timer and loop back to step 1 after the last one.
public struct UpiWaitScreen: View {
    let autoAdvance: Bool
    let interval: Double
    @State private var step: Int

    /// - Parameters:
    ///   - step: the step shown first.
    ///   - autoAdvance: steps advance every `interval` seconds and loop.
    ///   - interval: seconds per step.
    public init(step: Int = 1, autoAdvance: Bool = true, interval: Double = 3) {
        self.autoAdvance = autoAdvance
        self.interval = interval
        _step = State(initialValue: min(max(step, 1), 4))
    }

    public var body: some View {
        EqualPaymentProcessing(step: step, layout: .processing)
            .ignoresSafeArea()
            .task {
                guard autoAdvance else { return }
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(interval))
                    if Task.isCancelled { break }
                    step = step % 4 + 1
                }
            }
    }
}

struct UpiWaitScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpiWaitScreen()
            UpiWaitScreen(step: 2, autoAdvance: false).environment(\.colorScheme, .dark)
        }
    }
}
