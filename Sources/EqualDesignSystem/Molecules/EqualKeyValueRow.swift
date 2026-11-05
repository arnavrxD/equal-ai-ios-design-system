import SwiftUI

/// Label–value line in the App Store confirmation card (grey label, hairline).
public struct EqualKeyValueRow: View {
    let label: String
    let value: String
    public init(_ label: String, _ value: String) { self.label = label; self.value = value }
    public var body: some View {
        HStack {
            Text(label).foregroundStyle(EqualColor.iosGray)
            Spacer()
            Text(value).foregroundStyle(EqualColor.grey01)
        }
        .font(.equal(size: 15))
        .padding(.vertical, 12)
    }
}

struct EqualPillsAndBanners_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualPushBanner("Only 1 day left", message: "Your trial ends tomorrow. Subscribe to Gold before your assistant goes off duty.")
                        HStack { EqualAvailabilityPill(); EqualTrialPill() }
            EqualSheetHeader()
            HStack { EqualUpiStep(1, "Open your UPI app, via notifications or directly"); EqualUpiStep(2, "Review and approve the autopay request") }
            VStack(spacing: 0) { EqualKeyValueRow("Price", "₹499.00 per month"); Divider(); EqualKeyValueRow("Starts", "Today") }
                .padding(.horizontal).background(Color.white, in: RoundedRectangle(cornerRadius: 14))
        }
        .padding(24)
        .equalScreenBackground()
    }
}
