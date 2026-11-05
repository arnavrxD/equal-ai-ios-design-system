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
