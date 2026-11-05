import SwiftUI

/// Signup step 1: phone number, WhatsApp opt-in, Send OTP and the terms line.
public struct PhoneNumberScreen: View {
    @State private var phone: String
    @State private var whatsapp = true
    let onSendOTP: (String) -> Void

    public init(phone: String = "", onSendOTP: @escaping (String) -> Void = { _ in }) {
        self._phone = State(initialValue: phone)
        self.onSendOTP = onSendOTP
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualOnboardingHeader("Enter phone number", subtitle: "Assistant will handle calls for this number")
            EqualTextField("Enter mobile number", text: $phone, kind: .phone).padding(.top, 35)
            Spacer()
            EqualCheckbox("I want to receive updates on Whatsapp", isOn: $whatsapp)
            EqualButton("Send OTP", fullWidth: true) { onSendOTP(phone) }
                .disabled(phone.filter(\.isNumber).count < 10)
                .padding(.top, 12)
            Text("By continuing, you agree to our Terms & Conditions and Privacy Statement")
                .equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary).multilineTextAlignment(.center)
                .padding(.top, 15)
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 38)
        .padding(.bottom, EqualSpacing.s16)
        .equalAmbientGlow(.signup)
    }
}

/// Signup step 2: OTP sent → entered → verifying → error, with the resend countdown and link.
public struct OTPScreen: View {
    public enum Phase: Sendable { case waiting, verifying, error }

    let phone: String
    @State private var code: String
    @State private var phase: Phase
    @State private var secondsLeft: Int
    let onVerify: (String) -> Void
    let onEdit: () -> Void
    let onResend: () -> Void

    public init(phone: String = "+91-8172033604", code: String = "", phase: Phase = .waiting, secondsLeft: Int = 30,
                onVerify: @escaping (String) -> Void = { _ in }, onEdit: @escaping () -> Void = {}, onResend: @escaping () -> Void = {}) {
        self.phone = phone
        self._code = State(initialValue: code)
        self._phase = State(initialValue: phase)
        self._secondsLeft = State(initialValue: secondsLeft)
        self.onVerify = onVerify
        self.onEdit = onEdit
        self.onResend = onResend
    }

    public var body: some View {
        VStack(spacing: 0) {
            EqualOnboardingHeader("Enter OTP sent to", editableValue: phone, onEdit: onEdit)
            EqualOTPField(code: $code, isError: phase == .error).padding(.top, 34)
            if phase == .error {
                EqualFieldMessage(.error("Incorrect OTP, try again")).padding(.top, 11)
            }
            Group {
                if secondsLeft > 0 {
                    EqualFieldMessage(.countdown(seconds: secondsLeft))
                } else {
                    EqualFieldMessage(.link("Resend OTP")) { secondsLeft = 30; onResend() }
                }
            }
            .padding(.top, phase == .error ? 14 : 12)
            EqualButton(phase == .verifying ? "Verifying" : "Confirm", fullWidth: true, isLoading: phase == .verifying) {
                phase = .verifying
                onVerify(code)
            }
            .disabled(code.count < 6)
            .padding(.top, 40)
            Spacer()
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 38)
        .equalAmbientGlow(.signup)
        .onChange(of: code) { _, _ in if phase == .error { phase = .waiting } }
        .task {
            while secondsLeft > 0 {
                try? await Task.sleep(for: .seconds(1))
                secondsLeft -= 1
            }
        }
    }
}

/// Signup step 3: name (letters only) and gender; Next needs both.
public struct NameGenderScreen: View {
    @State private var name: String
    @State private var gender: EqualGenderCard.Gender?
    let onNext: (String, EqualGenderCard.Gender) -> Void

    public init(name: String = "", gender: EqualGenderCard.Gender? = nil, onNext: @escaping (String, EqualGenderCard.Gender) -> Void = { _, _ in }) {
        self._name = State(initialValue: name)
        self._gender = State(initialValue: gender)
        self.onNext = onNext
    }

    private var isInvalid: Bool { name.contains { !($0.isLetter || $0 == " ") } }

    public var body: some View {
        VStack(spacing: 0) {
            EqualOnboardingHeader("Set Name & Gender", subtitle: "Your AI will address you accordingly")
            EqualTextField("Enter name", text: $name, kind: .name, isError: isInvalid).padding(.top, 35)
            if isInvalid {
                EqualFieldMessage(.error("Special characters and numbers not allowed")).padding(.top, 9)
            } else if !name.isEmpty {
                EqualFieldMessage(.helper("Your AI will call you ", emphasis: "‘\(name)’")).padding(.top, 9)
            }
            HStack(spacing: 23) {
                EqualGenderCard(.male, isSelected: gender == .male) { gender = .male }
                EqualGenderCard(.female, isSelected: gender == .female) { gender = .female }
            }
            .padding(.top, 18)
            EqualButton("Next", fullWidth: true) { if let gender { onNext(name, gender) } }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || isInvalid || gender == nil)
                .padding(.top, 40)
            Spacer()
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 38)
        .equalAmbientGlow(.signup)
    }
}

/// The welcome break after signup.
public struct WelcomeScreen: View {
    let name: String
    let onContinue: () -> Void
    public init(name: String = "Keshav", onContinue: @escaping () -> Void = {}) { self.name = name; self.onContinue = onContinue }
    public var body: some View { EqualWelcomeIntro(name: name, onContinue: onContinue) }
}

/// Walkthrough slide 2: unknown callers are screened automatically.
public struct IntroScreeningScreen: View {
    @State private var muted = false
    public init() {}
    public var body: some View {
        EqualIntroSlide(isMuted: $muted) { EqualLiveCallCard() }
    }
}

/// Permission step: the walkthrough intro with the "Notification permission required" sheet
/// over it. `PermissionIntroScreen` has every walkthrough state.
public struct PermissionScreen: View {
    public init() {}
    public var body: some View { PermissionIntroScreen(state: .notificationDenied) }
}

struct OnboardingScreens_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberScreen()
        OTPScreen()
        OTPScreen(code: "194226", phase: .error)
        NameGenderScreen(name: "Keshav", gender: .male)
        WelcomeScreen()
        IntroScreeningScreen()
        PermissionScreen()
    }
}
