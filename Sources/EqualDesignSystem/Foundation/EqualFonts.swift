import SwiftUI
import CoreText
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Registers the bundled DM Sans files. Call once at launch:
///
/// ```swift
/// @main struct MyApp: App {
///     init() { EqualFonts.register() }
///     var body: some Scene { WindowGroup { ContentView() } }
/// }
/// ```
public enum EqualFonts {
    /// The family name used by every DM Sans style.
    public static let family = "DM Sans"

    private static var registered = false

    /// Registers every .ttf / .otf in `Resources/Fonts`. Safe to call more than once.
    public static func register() {
        guard !registered else { return }
        registered = true
        let urls = (Bundle.module.urls(forResourcesWithExtension: "ttf", subdirectory: "Fonts") ?? [])
            + (Bundle.module.urls(forResourcesWithExtension: "otf", subdirectory: "Fonts") ?? [])
        for url in urls {
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }

    /// `true` once DM Sans is available; otherwise text uses the system font.
    public static var isDMSansAvailable: Bool {
        #if canImport(UIKit)
        return !UIFont.fontNames(forFamilyName: family).isEmpty
        #else
        return NSFontManager.shared.availableMembers(ofFontFamily: family) != nil
        #endif
    }
}

public extension Font {
    /// DM Sans at a size and weight. DM Sans sets all text; SF Pro is only for SF Symbols icons.
    static func equal(size: CGFloat, weight: Font.Weight = .regular, italic: Bool = false) -> Font {
        var font: Font = EqualFonts.isDMSansAvailable
            ? .custom(EqualFonts.family, fixedSize: size).weight(weight)
            : .system(size: size, weight: weight)
        if italic { font = font.italic() }
        return font
    }

    /// The font for an `EqualTextStyle`.
    static func equal(_ style: EqualTextStyle) -> Font {
        return .equal(size: style.size, weight: style.weight, italic: style.isItalic)
    }
}
