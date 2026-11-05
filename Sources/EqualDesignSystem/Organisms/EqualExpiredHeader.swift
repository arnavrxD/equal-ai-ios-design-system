import SwiftUI

/// Top of the Subscription Expired page: a mint dome, the white close button, the tilted gold crown
/// with a red ✕ badge, "Subscription Expired" and "Assistant has stopped handling your calls".
/// Place it edge to edge at the very top; the membership card follows directly below.
public struct EqualExpiredHeader: View {
    let title: String
    let message: String
    let onClose: () -> Void

    public init(title: String = "Subscription Expired", message: String = "Assistant has stopped handling your calls", onClose: @escaping () -> Void = {}) {
        self.title = title
        self.message = message
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                EqualImage.crownGoldTilted.image.aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                EqualIllustration(.crossRedCircle, size: 34).offset(x: 56, y: 44)
            }
            .frame(width: 99, height: 90, alignment: .topLeading)
            .accessibilityHidden(true)
            .padding(.top, 94)

            VStack(spacing: EqualSpacing.s2) {
                Text(title).equalTextStyle(.headlineEm).foregroundStyle(EqualColor.textPrimary)
                Text(message).equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary)
            }
            .multilineTextAlignment(.center)
            .padding(.top, 7)
        }
        .padding(.bottom, 19)
        .frame(maxWidth: .infinity)
        .background(alignment: .top) {
            Circle()
                .fill(LinearGradient(colors: [Self.domeTop, Self.domeBottom], startPoint: .top, endPoint: .bottom))
                .frame(width: 547, height: 547)
                .offset(y: -253)
                .frame(width: 547)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: onClose) {
                EqualIconView(.close, size: 16, weight: .semibold)
                    .foregroundStyle(EqualColor.grey05)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color.white))
                    .equalShadow(.close)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close")
            .padding(.top, 51)
            .padding(.trailing, 25)
        }
    }

    static let domeTop = Color.equalDynamic(light: 0xF1FFF5, dark: 0x000000)
    static let domeBottom = Color.equalDynamic(light: 0xCEFFDB, dark: 0x0F3B1E)
}

struct EqualExpiredHeader_Previews: PreviewProvider {
    static var previews: some View {
        EqualExpiredHeader().frame(width: 393).clipped().background(Color.white)
    }
}
