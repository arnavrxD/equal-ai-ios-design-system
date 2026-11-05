import SwiftUI

/// A `ScrollView`, or a plain clipped stack when the `EQUAL_STATIC_SCROLL=1` environment variable
/// is set. `ImageRenderer` cannot draw scroll view contents, so snapshot runs set the variable to
/// see the home list, chip rows and chat threads (the search bar also skips its `TextField`,
/// which `ImageRenderer` draws as a placeholder glyph). Interaction is unchanged in apps.
struct EqualScrollContent<Content: View>: View {
    let axis: Axis
    let content: Content

    init(_ axis: Axis = .vertical, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.content = content()
    }

    var body: some View {
        if EqualSnapshotMode.isStatic {
            if axis == .vertical {
                Color.clear.overlay(alignment: .top) { content.fixedSize(horizontal: false, vertical: true) }.clipped()
            } else {
                content.fixedSize(horizontal: true, vertical: false)
                    .frame(width: 0, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading).clipped()
            }
        } else {
            ScrollView(axis == .vertical ? .vertical : .horizontal, showsIndicators: false) { content }
        }
    }
}

/// Snapshot mode switch (`EQUAL_STATIC_SCROLL=1`), read by `EqualScrollContent` and the search bar.
enum EqualSnapshotMode {
    static let isStatic = ProcessInfo.processInfo.environment["EQUAL_STATIC_SCROLL"] == "1"
}
