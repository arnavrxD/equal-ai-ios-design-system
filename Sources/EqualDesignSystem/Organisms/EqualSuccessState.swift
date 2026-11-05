import SwiftUI

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
