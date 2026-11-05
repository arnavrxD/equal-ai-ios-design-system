import SwiftUI

/// The four UPI AutoPay steps as a compact list beside the phone illustration ("Activating Equal Gold",
/// list layout): finished and current rows at full opacity, upcoming rows at 18%.
///
/// Rows 18pt apart; each row is an 18pt black number disc (Bold 12 white numeral), 9pt gap, and
/// Regular 13/18 text (-2.6%) 124pt wide. The list is 164pt wide.
public struct EqualUpiStepList: View {
    let steps: [String]
    let current: Int

    /// - Parameters:
    ///   - steps: the instructions, in order (defaults to the four UPI AutoPay steps).
    ///   - current: the step in progress, 1-based. Rows after it are dimmed.
    public init(steps: [String] = EqualPaymentProcessing.steps, current: Int) {
        self.steps = steps
        self.current = current
    }

    public var body: some View {
        let ink = Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7)
        VStack(alignment: .leading, spacing: EqualSpacing.s18) {
            ForEach(Array(steps.enumerated()), id: \.offset) { i, text in
                HStack(alignment: .top, spacing: 9) {
                    Text("\(i + 1)")
                        .font(.equal(size: 12, weight: .bold))
                        .foregroundStyle(Color.equalDynamic(light: 0xFFFFFF, dark: 0x000000))
                        .frame(width: 18, height: 18)
                        .background(Circle().fill(ink))
                    Text(text)
                        .equalTextStyle(.footnote)
                        .foregroundStyle(ink)
                        .frame(width: 124, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .opacity(i + 1 <= current ? 1 : 0.18)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Step \(i + 1): \(text)")
                .accessibilityValue(i + 1 < current ? "Done" : i + 1 == current ? "Current" : "Upcoming")
            }
        }
        .frame(width: 164, alignment: .leading)
        .animation(.easeInOut(duration: 0.3), value: current)
    }
}

struct EqualUpiStepList_Previews: PreviewProvider {
    static var previews: some View {
        HStack(alignment: .top, spacing: 24) {
            EqualUpiStepList(current: 1)
            EqualUpiStepList(current: 3)
        }
        .padding(24)
        .background(EqualGradient.processing)
    }
}
