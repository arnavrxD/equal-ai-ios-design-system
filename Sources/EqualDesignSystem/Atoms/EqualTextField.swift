import SwiftUI

/// 52pt single-line input: radius 16, surface fill, a hairline that turns green on focus.
/// `.phone` adds the 🇮🇳 flag, "+91" and a divider; `.name` centres a semibold value.
public struct EqualTextField: View {
    public enum Kind: Sendable { case plain, phone, name }

    let placeholder: String
    @Binding var text: String
    let kind: Kind
    let helper: String?
    let isError: Bool
    @FocusState private var focused: Bool

    /// - Parameter isError: red stroke on a rose fill (pair it with an `EqualFieldMessage(.error)`).
    public init(_ placeholder: String, text: Binding<String>, kind: Kind = .plain, helper: String? = nil, isError: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.kind = kind
        self.helper = helper
        self.isError = isError
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            HStack(spacing: 13) {
                if kind == .phone {
                    HStack(spacing: EqualSpacing.s8) {
                        EqualFlagIndia(size: 28)
                        Text("+91").equalTextStyle(.body).foregroundStyle(EqualColor.textPrimary)
                    }
                    Rectangle().fill(Color.black.opacity(0.1)).frame(width: 1, height: 30)
                }
                TextField(placeholder, text: $text)
                    .focused($focused)
                    .font(kind == .name ? .equal(size: 18, weight: text.isEmpty ? .regular : .semibold) : .equal(.body))
                    .multilineTextAlignment(kind == .name ? .center : .leading)
                    .foregroundStyle(EqualColor.textPrimary)
                    #if os(iOS)
                    .keyboardType(kind == .phone ? .phonePad : .default)
                    .textContentType(kind == .phone ? .telephoneNumber : (kind == .name ? .givenName : nil))
                    #endif
            }
            .padding(.horizontal, EqualSpacing.s18)
            .frame(height: 52)
            .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(isError ? Color(equalHex: 0xFCF3F3) : EqualColor.bgSurface))
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(isError ? Color(equalHex: 0xEC0033) : (focused || !text.isEmpty ? EqualColor.green : EqualColor.strokeMedium), lineWidth: 1))

            if let helper {
                Text(helper).equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary)
            }
        }
    }
}

struct EqualTextField_Previews: PreviewProvider {
    struct Demo: View {
        @State var phone = ""
        @State var name = "Keshav"
        var body: some View {
            VStack(spacing: 16) {
                EqualTextField("Enter mobile number", text: $phone, kind: .phone)
                EqualTextField("Your name", text: $name, kind: .name, helper: "Your AI will call you ‘\(name)’")
            }
            .padding(24)
            .equalScreenBackground()
        }
    }
    static var previews: some View { Demo() }
}
