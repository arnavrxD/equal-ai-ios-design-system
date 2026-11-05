import SwiftUI

/// Centred title block on signup screens: `title2Em` title over a `callout` subtitle, or over an
/// editable value with a pencil ("+91-8172033604 ✎") that returns to the previous step.
public struct EqualOnboardingHeader: View {
    let title: String
    let subtitle: String?
    let editableValue: String?
    let onEdit: () -> Void

    public init(_ title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.editableValue = nil
        self.onEdit = {}
    }

    /// The OTP variant: the number the code was sent to, with an edit pencil.
    public init(_ title: String, editableValue: String, onEdit: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = nil
        self.editableValue = editableValue
        self.onEdit = onEdit
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text(title).equalTextStyle(.title2Em).foregroundStyle(EqualColor.textPrimary)
            if let subtitle {
                Text(subtitle).equalTextStyle(.callout).foregroundStyle(EqualColor.textSecondary)
            }
            if let editableValue {
                Button(action: onEdit) {
                    HStack(spacing: EqualSpacing.s10) {
                        Text(editableValue).equalTextStyle(.headlineEm).foregroundStyle(EqualColor.textSecondary)
                        EqualIconView(.pencil, size: 13.5, weight: .semibold).foregroundStyle(Color(equalHex: 0x676767))
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Edit number \(editableValue)")
            }
        }
        .multilineTextAlignment(.center)
    }
}

struct EqualOnboardingHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            EqualOnboardingHeader("Enter phone number", subtitle: "Assistant will handle calls for this number")
            EqualOnboardingHeader("Enter OTP sent to", editableValue: "+91-8172033604")
        }
        .padding(24).equalScreenBackground()
    }
}
