import SwiftUI

/// Numbered instruction on the payment screen: a black number disc above centred text.
public struct EqualUpiStep: View {
    let number: Int
    let text: String
    public init(_ number: Int, _ text: String) { self.number = number; self.text = text }
    public var body: some View {
        VStack(spacing: EqualSpacing.s10) {
            Text("\(number)").font(.equal(size: 14, weight: .bold)).foregroundStyle(.white)
                .frame(width: 24, height: 24).background(Circle().fill(Color.black))
            Text(text).font(.equal(size: 16)).foregroundStyle(Color.black).multilineTextAlignment(.center).frame(maxWidth: 237)
        }
    }
}
