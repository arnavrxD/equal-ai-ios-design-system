import SwiftUI

/// 231×52 one-time-code field. Empty + focused: green stroke and the "Enter OTP" placeholder;
/// filled: the code grouped 3 + 3; error: red stroke on a rose fill (capsule, as in Figma);
/// idle (timer ran out): grey hairline.
public struct EqualOTPField: View {
    @Binding var code: String
    let isError: Bool
    let length: Int
    @FocusState private var focused: Bool

    public init(code: Binding<String>, isError: Bool = false, length: Int = 6) {
        self._code = code
        self.isError = isError
        self.length = length
    }

    private var display: String {
        let digits = String(code.filter(\.isNumber).prefix(length))
        guard digits.count > 3 else { return digits }
        return String(digits.prefix(3)) + " " + String(digits.dropFirst(3))
    }

    public var body: some View {
        ZStack {
            TextField("", text: $code)
                .focused($focused)
                .opacity(0.02)
                #if os(iOS)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                #endif
                .onChange(of: code) { _, new in
                    let clean = String(new.filter(\.isNumber).prefix(length))
                    if clean != new { code = clean }
                }
            Text(code.isEmpty ? "Enter OTP" : display)
                .font(.equal(size: 18, weight: code.isEmpty ? .regular : .semibold)).tracking(-0.47)
                .foregroundStyle(code.isEmpty ? EqualColor.textPlaceholder : (isError ? Color.black : EqualColor.textPrimary))
                .monospacedDigit()
                .allowsHitTesting(false)
        }
        .padding(.horizontal, 18)
        .frame(width: 231, height: 52)
        .background(shape.fill(isError ? Color(equalHex: 0xFCF3F3) : EqualColor.bgSurface))
        .overlay(shape.strokeBorder(stroke, lineWidth: 1))
        .contentShape(Rectangle())
        .onTapGesture { focused = true }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("One-time code")
        .accessibilityValue(code.isEmpty ? "Empty" : code)
    }

    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: isError ? 26 : EqualRadius.m) }
    private var stroke: Color {
        if isError { return Color(equalHex: 0xEC0033) }
        return focused || !code.isEmpty ? EqualColor.green : EqualColor.strokeMedium
    }
}

struct EqualOTPField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualOTPField(code: .constant(""))
            EqualOTPField(code: .constant("194226"))
            EqualOTPField(code: .constant("194226"), isError: true)
        }
        .padding(24).equalScreenBackground()
    }
}
