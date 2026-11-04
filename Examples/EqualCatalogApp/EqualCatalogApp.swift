// Catalog app: create a new iOS App in Xcode, add this package (File → Add Package Dependencies →
// Add Local…, pick the repo root), replace the generated App file with this one and run.
import SwiftUI
import EqualDesignSystem

@main
struct EqualCatalogApp: App {
    init() { EqualFonts.register() }

    var body: some Scene {
        WindowGroup {
            EqualCatalogView()
        }
    }
}
