import SwiftUI

/// Green unread count (18pt) under a chat's time and on the Chats tab; `dot` is the 8pt variant.
public struct EqualUnreadCount: View {
    let count: Int?

    public init(_ count: Int) { self.count = count }
    /// The 8pt dot.
    public init() { self.count = nil }

    public var body: some View {
        if let count {
            Text(count > 99 ? "99+" : "\(count)")
                .font(.equal(size: 11, weight: .bold)).foregroundStyle(.white)
                .padding(.horizontal, 5).frame(minWidth: 18, minHeight: 18)
                .background(Capsule().fill(EqualColor.green))
                .accessibilityLabel("\(count) unread")
        } else {
            Circle().fill(EqualColor.green).frame(width: 8, height: 8).accessibilityLabel("Unread")
        }
    }
}
