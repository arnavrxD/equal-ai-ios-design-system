import SwiftUI

/// Home search: a 52pt white pill with a 20pt search glyph and a placeholder that rolls through
/// "Search for names → numbers → categories → keywords" (vertical ticker), plus the 42pt glass ⋯
/// button (Select chats, Read all) 16pt to its right.
public struct EqualSearchBar: View {
    @Binding var query: String
    let placeholder: String?
    let terms: [String]
    let showsMore: Bool
    let onMore: () -> Void
    @State private var index = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// - Parameters:
    ///   - placeholder: a fixed placeholder. Leave `nil` for the rolling "Search for …" ticker.
    ///   - terms: the words the ticker rolls through.
    public init(query: Binding<String>, placeholder: String? = nil, terms: [String] = ["names", "numbers", "categories", "keywords"], showsMore: Bool = true, onMore: @escaping () -> Void = {}) {
        self._query = query
        self.placeholder = placeholder
        self.terms = terms
        self.showsMore = showsMore
        self.onMore = onMore
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s16) {
            HStack(spacing: EqualSpacing.s12) {
                EqualIconView(.search, size: 20, weight: .medium).foregroundStyle(EqualColor.textPlaceholder)
                ZStack(alignment: .leading) {
                    if query.isEmpty { placeholderView }
                    if !EqualSnapshotMode.isStatic {
                        TextField("", text: $query)
                            .font(.equal(.body))
                            .foregroundStyle(EqualColor.textPrimary)
                            .accessibilityLabel(placeholder ?? "Search")
                    }
                }
            }
            .padding(.horizontal, EqualSpacing.s16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 52)
            .background(Capsule().fill(EqualColor.bgSurface))
            .overlay(Capsule().stroke(EqualColor.strokeSubtle, lineWidth: 1))

            if showsMore {
                Button(action: onMore) {
                    EqualIconView(.more, size: 20, weight: .bold)
                        .foregroundStyle(EqualColor.textPrimary)
                        .frame(width: 42, height: 42)
                        .equalGlass(Circle())
                        .equalShadow(.glass)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("More options")
            }
        }
        .task(id: placeholder == nil && !reduceMotion) {
            guard placeholder == nil, !reduceMotion, terms.count > 1 else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2.2))
                guard !Task.isCancelled else { return }
                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) { index = (index + 1) % terms.count }
            }
        }
    }

    @ViewBuilder private var placeholderView: some View {
        if let placeholder {
            Text(placeholder).font(.equal(.body)).foregroundStyle(EqualColor.textPlaceholder)
        } else {
            HStack(spacing: 0) {
                Text("Search for ")
                ZStack(alignment: .leading) {
                    Text(terms[index % terms.count])
                        .id(index)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                                removal: .move(edge: .top).combined(with: .opacity)))
                }
                .frame(height: 32)
                .clipped()
            }
            .font(.equal(.body))
            .foregroundStyle(EqualColor.textPlaceholder)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

struct EqualSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        EqualSearchBar(query: .constant("")).padding(24).equalScreenBackground()
    }
}
