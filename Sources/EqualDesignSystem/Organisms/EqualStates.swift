import SwiftUI

/// Full-screen story shown on the last trial day: time saved in gold, four stat rows, "Don’t make it start over."
public struct EqualValueRecapStory: View {
    let name: String
    let saved: String
    let progress: Double
    let onSkip: () -> Void

    public init(name: String = "Keshav", saved: String = "2h 22m", progress: Double = 0.45, onSkip: @escaping () -> Void = {}) {
        self.name = name
        self.saved = saved
        self.progress = progress
        self.onSkip = onSkip
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s16) {
            EqualProgressBar(value: progress, tone: .gold)
            HStack {
                Spacer()
                Button("Skip", action: onSkip).font(.equal(size: 13, weight: .semibold)).foregroundStyle(.white)
                    .padding(.horizontal, 12).frame(height: 32).background(Capsule().fill(.white.opacity(0.12))).buttonStyle(.plain)
            }
            Spacer().frame(height: 32)
            Text("\(name), your free week with Equal".uppercased()).font(.equal(size: 12, weight: .semibold)).tracking(1.2).foregroundStyle(EqualColor.goldRecapLabel)
            Text(saved).font(.equal(size: 60, weight: .semibold)).tracking(-1.8).foregroundStyle(EqualGradient.goldText)
            Text("saved on calls you didn’t have to take").font(.equal(size: 15)).foregroundStyle(.white.opacity(0.75)).padding(.top, -8)
            VStack(spacing: 0) {
                EqualStatRow("Calls handled", value: "18", icon: .phoneOutline)
                EqualStatRow("Spam and sales stopped", value: "7", icon: .shield)
                EqualStatRow("Messages taken", value: "5", icon: .message)
                EqualStatRow("Actions after calls", value: "9", icon: .bolt)
            }
            (Text("Don’t make it ") + Text("start over.").foregroundColor(EqualColor.goldLabel))
                .font(.equal(size: 20, weight: .bold)).foregroundStyle(.white).padding(.top, EqualSpacing.s16)
            Spacer(minLength: 0)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, EqualSpacing.s18)
        .padding(.top, EqualSpacing.s16)
        .background(EqualGradient.recapStory.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
    }
}

/// Recreation of the iOS purchase confirmation used in flow mocks. It is system UI: don't restyle it.
public struct EqualAppStoreSheet: View {
    let product: String
    let price: String
    let note: String

    public init(product: String = "Equal Gold Plus", price: String = "₹499.00 per month", note: String = "Your free trial ends today and Gold Plus starts now. Renews monthly at ₹499 until cancelled in Settings.") {
        self.product = product
        self.price = price
        self.note = note
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            HStack {
                Text("App Store").font(.system(size: 20, weight: .semibold))
                Spacer()
                Image(systemName: "xmark").font(.system(size: 12, weight: .bold)).foregroundStyle(.secondary)
                    .frame(width: 30, height: 30).background(Circle().fill(Color(equalHex: 0xE3E3E8)))
            }
            VStack(spacing: 0) {
                HStack(spacing: EqualSpacing.s12) {
                    EqualMark(size: 26, color: .white).frame(width: 48, height: 48).background(RoundedRectangle(cornerRadius: 11).fill(EqualColor.green))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(product).font(.system(size: 17, weight: .semibold))
                        Text("Equal AI · Subscription").font(.system(size: 13)).foregroundStyle(EqualColor.iosGray)
                    }
                    Spacer()
                }
                .padding(.bottom, EqualSpacing.s12)
                Divider()
                EqualKeyValueRow("Price", price); Divider()
                EqualKeyValueRow("Starts", "Today"); Divider()
                EqualKeyValueRow("Account", "Apple Account")
            }
            .padding(.horizontal, EqualSpacing.s16).padding(.vertical, EqualSpacing.s12)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
            Text(note).font(.system(size: 13)).foregroundStyle(EqualColor.iosGray)
            VStack(spacing: EqualSpacing.s10) {
                Image(systemName: "faceid").font(.system(size: 30)).frame(width: 56, height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(EqualColor.iosBlue, lineWidth: 2))
                Text("Double-click side button to pay").font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(EqualColor.iosBlue)
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(EqualColor.grey01)
        .padding(EqualSpacing.s24)
        .background(RoundedRectangle(cornerRadius: 34).fill(Color(equalHex: 0xF2F2F7)))
        .environment(\.colorScheme, .light)
    }
}

/// UPI autopay waiting screen: crown loader, "Processing payment" and the current step.
public struct EqualPaymentProcessing: View {
    public static let steps = [
        "Open your UPI app, via notifications or directly",
        "Review and approve the autopay request",
        "Enter your UPI pin to confirm purchase",
        "Come back to Equal AI app to continue"
    ]
    let step: Int

    /// - Parameter step: 1 to 4.
    public init(step: Int = 1) { self.step = min(max(step, 1), 4) }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            EqualCrownLoader(size: 80)
            Text("Processing payment").font(.equal(size: 22, weight: .bold)).foregroundStyle(Color.black)
            Text("Waiting for your confirmation...").font(.equal(size: 15)).foregroundStyle(Color.black.opacity(0.6))
            HStack(spacing: EqualSpacing.s8) {
                Rectangle().fill(Color(equalHex: 0x553B00, alpha: 0.2)).frame(height: 1)
                Text("Using UPI? Follow these steps:").font(.equal(size: 13, weight: .semibold)).foregroundStyle(Color(equalHex: 0x553B00)).fixedSize()
                Rectangle().fill(Color(equalHex: 0x553B00, alpha: 0.2)).frame(height: 1)
            }
            .padding(.vertical, EqualSpacing.s8)
            EqualUpiStep(step, Self.steps[step - 1])
        }
        .multilineTextAlignment(.center)
        .padding(EqualSpacing.s24)
        .frame(maxWidth: .infinity)
        .background(EqualGradient.processing)
    }
}

/// Post-purchase confirmation: crowned mascot, "Congratulations!" and the plan, or the trial start.
public struct EqualSuccessState: View {
    public enum Kind: Sendable { case upgraded(String), trialStarted(days: Int) }
    let kind: Kind

    public init(_ kind: Kind) { self.kind = kind }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            EqualIllustration(.mascotCrown, size: 180)
            switch kind {
            case .upgraded(let plan):
                Text("Congratulations!").font(.equal(size: 13)).foregroundStyle(EqualColor.textSecondary)
                Text("You’re on \(plan) 🎉").font(.equal(size: 28, weight: .bold)).foregroundStyle(EqualColor.textPrimary)
                Text("Unlimited AI calls start now").font(.equal(size: 15)).foregroundStyle(EqualColor.textSecondary)
            case .trialStarted(let days):
                VStack(spacing: 0) {
                    Text("\(days) days of").font(.equal(size: 28, weight: .bold)).foregroundStyle(EqualColor.textPrimary)
                    Text("Equal Gold").font(.equal(size: 28, weight: .bold)).foregroundStyle(EqualColor.goldInk)
                }
                Text("Starts Today!").font(.equal(size: 20)).foregroundStyle(EqualColor.textSecondary)
            }
        }
        .multilineTextAlignment(.center)
        .padding(EqualSpacing.s24)
    }
}

/// Home before any calls: waving mascot, "Your chats will appear here", one line inviting a demo.
public struct EqualEmptyState: View {
    let title: String
    let message: String

    public init(title: String = "Your chats will appear here", message: String = "Talk to your assistant and try a demo of how it answers calls and helps you afterwards.") {
        self.title = title
        self.message = message
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s12) {
            EqualIllustration(.mascotWave, size: 120)
            Text(title).font(.equal(size: 18, weight: .bold)).foregroundStyle(EqualColor.textPrimary)
            Text(message).font(.equal(size: 15)).foregroundStyle(EqualColor.textSecondary).frame(maxWidth: 300)
        }
        .multilineTextAlignment(.center)
        .padding(EqualSpacing.s24)
    }
}

/// Centred title block on signup screens.
public struct EqualOnboardingHeader: View {
    let title: String
    let subtitle: String
    public init(_ title: String, subtitle: String) { self.title = title; self.subtitle = subtitle }
    public var body: some View {
        VStack(spacing: 0) {
            Text(title).equalTextStyle(.title2Em).foregroundStyle(EqualColor.textPrimary)
            Text(subtitle).equalTextStyle(.callout).foregroundStyle(EqualColor.textSecondary)
        }
        .multilineTextAlignment(.center)
    }
}

/// Referral card at the bottom of Settings.
public struct EqualInviteCard: View {
    let onShare: () -> Void
    public init(onShare: @escaping () -> Void = {}) { self.onShare = onShare }
    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text("Invite a Friend").font(.equal(size: 16, weight: .black)).foregroundStyle(EqualColor.textPrimary)
                Text("Give them the same superpower that you have").font(.equal(size: 14)).foregroundStyle(EqualColor.textSecondary).frame(maxWidth: 170, alignment: .leading)
                EqualButton("Share now", size: .medium, icon: .share, action: onShare).padding(.top, EqualSpacing.s8)
            }
            Spacer(minLength: 0)
            EqualIllustration(.inviteHands, size: 110)
        }
        .padding(.horizontal, EqualSpacing.s18).padding(.vertical, EqualSpacing.s16)
        .background {
            RoundedRectangle(cornerRadius: EqualRadius.s).fill(EqualColor.unreadFill)
                .overlay(alignment: .bottomLeading) { Circle().fill(EqualColor.unreadStroke).frame(width: 197).blur(radius: 60).offset(x: -60, y: 120) }
                .clipShape(RoundedRectangle(cornerRadius: EqualRadius.s))
        }
    }
}

/// Live-call explainer card: caller, timer, "Your assistant is on call." and quick replies incl. Takeover.
public struct EqualLiveCallCard: View {
    let number: String
    let duration: String
    let status: String
    let replies: [String]
    let onReply: (String) -> Void

    public init(number: String = "+91 98765 43210", duration: String = "00:06", status: String = "Your assistant is on call.", replies: [String] = ["Takeover", "I’m Interested", "Please, Call me later"], onReply: @escaping (String) -> Void = { _ in }) {
        self.number = number; self.duration = duration; self.status = status; self.replies = replies; self.onReply = onReply
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: EqualSpacing.s16) {
            HStack(spacing: EqualSpacing.s12) {
                EqualIllustration(.callerPhone, size: 46)
                VStack(alignment: .leading, spacing: 2) {
                    Text(number).font(.equal(size: 13.3))
                    HStack(spacing: 4) {
                        Image(systemName: "waveform").font(.system(size: 10)).foregroundStyle(EqualColor.green)
                        Text(duration).font(.equal(size: 11.4)).foregroundStyle(Color(equalHex: 0x0B1215, alpha: 0.7))
                    }
                }
                Spacer()
                EqualLogo(height: 11)
            }
            Text(status).font(.equal(size: 15.2))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: EqualSpacing.s8) {
                    ForEach(replies, id: \.self) { r in
                        Button { onReply(r) } label: {
                            HStack(spacing: 4) {
                                if r == replies.first { Image(systemName: "phone.fill").font(.system(size: 10)) }
                                Text(r).font(.equal(size: 11.6))
                            }
                            .padding(.horizontal, 12).frame(height: 35)
                            .background(Capsule().fill(Color.white.opacity(0.75)))
                            .overlay(Capsule().stroke(Color(equalHex: 0x75AC00), lineWidth: 0.8))
                            .shadow(color: .black.opacity(0.1), radius: 3.5, x: 3, y: 3)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(4)
            }
        }
        .foregroundStyle(Color(equalHex: 0x0B1215))
        .padding(EqualSpacing.s16)
        .background {
            ZStack(alignment: .bottom) {
                RadialGradient(colors: [.white, Color(equalHex: 0xEAEAEA)], center: UnitPoint(x: 0.3, y: 0.2), startRadius: 0, endRadius: 300)
                LinearGradient(colors: [EqualColor.brandLime, EqualColor.brandGreen], startPoint: .leading, endPoint: .trailing)
                    .frame(height: 90).blur(radius: 30).opacity(0.45).offset(y: 50)
            }
            .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
            .shadow(color: .black.opacity(0.25), radius: 2, y: 4)
        }
        .environment(\.colorScheme, .light)
    }
}

struct EqualStates_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                EqualValueRecapStory().frame(height: 760)
                EqualAppStoreSheet()
                EqualPaymentProcessing(step: 1)
                EqualSuccessState(.upgraded("Gold Plus"))
                EqualSuccessState(.trialStarted(days: 7))
                EqualEmptyState()
                EqualOnboardingHeader("Enter phone number", subtitle: "Assistant will handle calls for this number")
                EqualInviteCard()
                EqualLiveCallCard()
            }
            .padding(24)
        }
        .equalScreenBackground()
    }
}
