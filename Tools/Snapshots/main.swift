// Renders every catalog entry to PNG (light and dark) with SwiftUI's ImageRenderer.
// Usage: swift run equal-snapshots <output-dir>
import SwiftUI
import AppKit
import EqualDesignSystem

@MainActor
func render(_ item: EqualCatalogItem, scheme: ColorScheme, to dir: URL) {
    let isScreen = item.level == .screens
    let width: CGFloat = isScreen ? 393 : 393
    let content = item.view
        .frame(width: isScreen ? 393 : width - 48, height: isScreen ? 852 : nil, alignment: .top)
        .padding(isScreen ? 0 : 24)
        .background(EqualColor.bgPrimary)
        .environment(\.colorScheme, scheme)
    let renderer = ImageRenderer(content: content)
    renderer.scale = 2
    renderer.proposedSize = ProposedViewSize(width: width, height: isScreen ? 852 : nil)
    guard let cg = renderer.cgImage else { print("FAILED", item.id); return }
    let rep = NSBitmapImageRep(cgImage: cg)
    guard let data = rep.representation(using: .png, properties: [:]) else { return }
    let slug = item.id.lowercased().replacingOccurrences(of: " · ", with: "-").replacingOccurrences(of: " & ", with: "-").replacingOccurrences(of: ", ", with: "-").replacingOccurrences(of: " ", with: "-")
    let url = dir.appendingPathComponent("\(slug)-\(scheme == .dark ? "dark" : "light").png")
    try? data.write(to: url)
    print("wrote", url.lastPathComponent, cg.width, "x", cg.height)
}

let out = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "snapshots")
try? FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
MainActor.assumeIsolated {
    _ = NSApplication.shared
    for item in EqualCatalog.items {
        render(item, scheme: .light, to: out)
        if item.level != .screens { render(item, scheme: .dark, to: out) }
    }
}
