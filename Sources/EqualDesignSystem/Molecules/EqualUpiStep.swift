import SwiftUI

/// Numbered instruction on the payment wait screen: a 24pt number disc above centred text.
///
/// Disc `#000000` with a Bold 16 white numeral (dark: `#F7F7F7` disc, black numeral), 10pt gap,
/// text Regular 16/21 (`.regular`, "Activating Equal Gold") or 18/22 (`.large`, "Processing
/// payment"), -2.6%, up to 237pt wide.
public struct EqualUpiStep: View {
    /// Text size of the instruction.
    public enum Size: Sendable {
        /// 16/21 (the "Activating Equal Gold" screens).
        case regular
        /// 18/22 (the "Processing payment" loading-education screens).
        case large
    }

    let number: Int
    let text: String
    let size: Size

    public init(_ number: Int, _ text: String, size: Size = .regular) {
        self.number = number
        self.text = text
        self.size = size
    }

    public var body: some View {
        let ink = Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7)
        VStack(spacing: EqualSpacing.s10) {
            Text("\(number)")
                .font(.equal(size: 16, weight: .bold))
                .foregroundStyle(Color.equalDynamic(light: 0xFFFFFF, dark: 0x000000))
                .frame(width: 24, height: 24)
                .background(Circle().fill(ink))
            Text(text)
                .equalTextStyle(size == .regular ? .callout : .headline)
                .foregroundStyle(ink)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 237)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(number): \(text)")
    }
}

struct EqualUpiStep_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            EqualUpiStep(1, "Open your UPI app, via notifications or directly")
            EqualUpiStep(2, "Review and approve the autopay request", size: .large)
        }
        .padding(24)
        .background(EqualGradient.processing)
    }
}
