import SwiftUI

/// Plan summary on the Subscription Expired page: plan name, price and date rows with icons,
/// a hairline and a centred "Cancellation Policy" link. White, radius 18, 18% hairline border.
public struct EqualPlanDetailsCard: View {
    let plan: String
    let price: String
    let dateLine: String
    let onCancellationPolicy: () -> Void

    public init(plan: String = "Equal Gold", price: String = "₹ 249 per month", dateLine: String = "Expired on 16th May, 2026", onCancellationPolicy: @escaping () -> Void = {}) {
        self.plan = plan
        self.price = price
        self.dateLine = dateLine
        self.onCancellationPolicy = onCancellationPolicy
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            Text(plan).equalTextStyle(.calloutEm).foregroundStyle(EqualColor.textPrimary)
            VStack(alignment: .leading, spacing: EqualSpacing.s8) {
                row(.creditCard, price)
                row(.calendar, dateLine)
            }
            Rectangle().fill(Self.rule).frame(width: 261, height: 1).frame(maxWidth: .infinity)
            Button(action: onCancellationPolicy) {
                Text("Cancellation Policy").equalTextStyle(.subheadEm).foregroundStyle(EqualColor.textPrimary.opacity(0.6))
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
        }
        .padding(EqualSpacing.s24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: EqualRadius.goldCard).fill(EqualColor.bgSurface))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.goldCard).strokeBorder(Self.border, lineWidth: 1))
    }

    private func row(_ icon: EqualIcon, _ text: String) -> some View {
        HStack(spacing: EqualSpacing.s8) {
            EqualIconView(icon, size: 16, weight: .regular).frame(width: 20, height: 20)
                .foregroundStyle(Self.icon)
            Text(text).equalTextStyle(.callout).foregroundStyle(EqualColor.textSecondary)
        }
    }

    static let border = Color.equalDynamic(light: 0x000000, lightAlpha: 0.18, dark: 0xFFFFFF, darkAlpha: 0.16)
    static let rule = Color.equalDynamic(light: 0x000000, lightAlpha: 0.2, dark: 0xFFFFFF, darkAlpha: 0.2)
    static let icon = Color.equalDynamic(light: 0x1C1B1F, lightAlpha: 0.7, dark: 0xF7F7F7, darkAlpha: 0.7)
}

struct EqualPlanDetailsCard_Previews: PreviewProvider {
    static var previews: some View {
        EqualPreviewPair { EqualPlanDetailsCard() }
    }
}
