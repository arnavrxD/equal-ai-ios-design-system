import SwiftUI

/// Home search: a 52pt white pill with a search glyph and placeholder, plus the glass ⋯ button
/// (Select chats, Read all) 16pt to its right.
public struct EqualSearchBar: View {
    @Binding var query: String
    let placeholder: String
    let showsMore: Bool
    let onMore: () -> Void

    public init(query: Binding<String>, placeholder: String = "Search for names", showsMore: Bool = true, onMore: @escaping () -> Void = {}) {
        self._query = query
        self.placeholder = placeholder
        self.showsMore = showsMore
        self.onMore = onMore
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s16) {
            HStack(spacing: EqualSpacing.s12) {
                EqualIconView(.search, size: 18, weight: .semibold).foregroundStyle(EqualColor.textPlaceholder)
                TextField(placeholder, text: $query)
                    .font(.equal(.body))
                    .foregroundStyle(EqualColor.textPrimary)
            }
            .padding(.horizontal, EqualSpacing.s16)
            .frame(height: 52)
            .background(Capsule().fill(EqualColor.bgSurface))
            .overlay(Capsule().stroke(EqualColor.strokeSubtle, lineWidth: 1))

            if showsMore {
                EqualIconButton(.more, variant: .glass, label: "More options", action: onMore)
            }
        }
    }
}

struct EqualSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        EqualSearchBar(query: .constant("")).padding(24).equalScreenBackground()
    }
}
