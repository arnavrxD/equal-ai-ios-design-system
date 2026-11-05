import SwiftUI

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
