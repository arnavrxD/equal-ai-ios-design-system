import SwiftUI

/// Green verified disc that sits on the trial-started mascot: 52pt `#00B13E` circle, soft drop
/// shadow, white check.
public struct EqualCheckBadge: View {
    let size: CGFloat

    public init(size: CGFloat = 52) { self.size = size }

    public var body: some View {
        let s = size / 52
        Circle()
            .fill(Color(equalHex: 0x00B13E))
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.25), radius: 2.17 * s, x: 0, y: 2.17 * s)
            .overlay {
                Image(systemName: "checkmark")
                    .font(.system(size: 21 * s, weight: .heavy))
                    .foregroundStyle(Color(equalHex: 0xFAFFF6))
            }
            .accessibilityLabel("Confirmed")
    }
}

struct EqualCheckBadge_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) { EqualCheckBadge(); EqualCheckBadge(size: 32) }.padding(24).equalScreenBackground()
    }
}
