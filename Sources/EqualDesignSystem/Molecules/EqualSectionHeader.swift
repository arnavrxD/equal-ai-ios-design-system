import SwiftUI

/// A list section header with a trailing glass ⋯ button: "CONVERSATIONS" in DM Sans ExtraBold 14
/// `#8A8888` on the left, a 36pt glass more button on the right (row 36 tall).
public struct EqualSectionHeader: View {
    let title: String
    let showsMore: Bool
    let onMore: () -> Void

    public init(_ title: String = "Conversations", showsMore: Bool = true, onMore: @escaping () -> Void = {}) {
        self.title = title
        self.showsMore = showsMore
        self.onMore = onMore
    }

    public var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.equal(size: 14, weight: .heavy))
                .foregroundStyle(Color(equalHex: 0x8A8888))
                .accessibilityAddTraits(.isHeader)
            Spacer()
            if showsMore {
                Button(action: onMore) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(equalHex: 0x1C1B1F))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Color.white.opacity(0.3)))
                        .background(.ultraThinMaterial, in: Circle())
                        .padding(0.9)
                        .background(Circle().fill(Color(equalHex: 0xF4F4F4)))
                        .shadow(color: .black.opacity(0.08), radius: 3.45, y: 1.7)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("More options")
            }
        }
        .frame(height: 36)
    }
}

struct EqualSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        EqualSectionHeader().padding(24).background(Color(equalHex: 0xF7F7F7))
    }
}
