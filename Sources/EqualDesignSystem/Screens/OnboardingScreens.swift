import SwiftUI

/// Signup step 1: phone number, WhatsApp opt-in, Send OTP and the terms line.
public struct PhoneNumberScreen: View {
    @State private var phone = ""
    @State private var whatsapp = true
    let onSendOTP: (String) -> Void

    public init(onSendOTP: @escaping (String) -> Void = { _ in }) { self.onSendOTP = onSendOTP }

    public var body: some View {
        VStack(spacing: EqualSpacing.s32) {
            EqualOnboardingHeader("Enter phone number", subtitle: "Assistant will handle calls for this number")
            EqualTextField("Enter mobile number", text: $phone, kind: .phone)
            Spacer()
            EqualCheckbox("I want to receive updates on Whatsapp", isOn: $whatsapp)
            VStack(spacing: EqualSpacing.s16) {
                EqualButton("Send OTP", fullWidth: true) { onSendOTP(phone) }
                    .disabled(phone.filter(\.isNumber).count < 10)
                Text("By continuing, you agree to our Terms & Conditions and Privacy Statement")
                    .equalTextStyle(.caption1).foregroundStyle(EqualColor.textSecondary).multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 48)
        .padding(.bottom, EqualSpacing.s16)
        .background(alignment: .bottom) {
            Circle().fill(EqualColor.brandLime.opacity(0.28)).frame(width: 272).blur(radius: 150).offset(y: 80)
        }
        .equalScreenBackground()
    }
}

/// Signup step 3: name and gender.
public struct NameGenderScreen: View {
    public enum Gender: Sendable { case male, female }
    @State private var name: String
    @State private var gender: Gender = .male
    let onNext: (String, Gender) -> Void

    public init(name: String = "Keshav", onNext: @escaping (String, Gender) -> Void = { _, _ in }) {
        self._name = State(initialValue: name)
        self.onNext = onNext
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s32) {
            EqualOnboardingHeader("Set Name & Gender", subtitle: "Your AI will address you accordingly")
            EqualTextField("Your name", text: $name, kind: .name, helper: "Your AI will call you ‘\(name)’")
            HStack(spacing: 23) {
                EqualGenderCard("Male", image: .avatarMale, isSelected: gender == .male) { gender = .male }
                EqualGenderCard("Female", image: .avatarFemale, isSelected: gender == .female) { gender = .female }
            }
            EqualButton("Next", fullWidth: true) { onNext(name, gender) }.disabled(name.isEmpty)
            Spacer()
        }
        .padding(.horizontal, EqualSpacing.s24)
        .padding(.top, 48)
        .equalScreenBackground()
    }
}

/// Permission step: the walkthrough card with the notification permission sheet over it.
public struct PermissionScreen: View {
    public init() {}
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: EqualSpacing.s24) {
                VStack(spacing: EqualSpacing.s8) {
                    Text("Give your assistant the essentials").font(.equal(size: 24, weight: .semibold))
                    Text("Notifications help you stay informed, while contacts help your assistant recognize who’s calling.")
                        .font(.equal(size: 16)).foregroundStyle(EqualColor.textPrimary.opacity(0.7))
                }
                .multilineTextAlignment(.center)
                EqualLiveCallCard()
                Spacer()
            }
            .padding(EqualSpacing.s24)
            EqualColor.bgOverlay.ignoresSafeArea()
            EqualPermissionSheet()
        }
        .background(EqualColor.bgSurface)
    }
}

struct OnboardingScreens_Previews: PreviewProvider {
    static var previews: some View {
        Group { PhoneNumberScreen(); NameGenderScreen(); PermissionScreen() }
    }
}
