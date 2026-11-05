import SwiftUI
import ImageIO
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A bundled render or photo (Resources/Images). Only art that cannot be drawn in code ships as an
/// image; logos, flags, icons, app tiles, glows and rings are SwiftUI views.
///
/// Images are static members, so an area can add its own art in an extension:
/// `extension EqualImage { static let myArt = EqualImage("my-art") }`.
public struct EqualImage: Hashable, Sendable {
    /// File name in Resources/Images, without `.png` (other extensions are spelled out, e.g. `"x.jpg"`).
    public let name: String

    public init(_ name: String) { self.name = name }

    public static let crown = EqualImage("crown")
    public static let mascot = EqualImage("mascot")
    public static let mascotWave = EqualImage("mascot-wave")
    public static let mascotCrown = EqualImage("mascot-crown")
    public static let assistantBot = EqualImage("assistant-bot")
    public static let bell = EqualImage("bell")
    public static let gear = EqualImage("gear")
    public static let avatarMale = EqualImage("avatar-male")
    public static let avatarFemale = EqualImage("avatar-female")
    public static let categoryFinance = EqualImage("category-finance")
    public static let categoryRide = EqualImage("category-ride")
    public static let categoryDelivery = EqualImage("category-delivery")
    public static let categoryOthers = EqualImage("category-others")
    public static let callerPhone = EqualImage("caller-phone")
    public static let inviteHands = EqualImage("invite-hands")
    public static let coupleCricketFans = EqualImage("couple-cricket-fans")
    public static let starGold = EqualImage("star-gold")
    public static let phoneHandsetGreen = EqualImage("phone-handset-green")
    public static let iosWallpaper = EqualImage("ios-wallpaper-blue.jpg")
    /// White line-art mask of the doodle wallpaper (392 vector icons; tint it with `EqualDoodlePattern`).
    public static let doodlePattern = EqualImage("doodle-pattern")

    /// Every image file in the bundle (for the catalog).
    public static var all: [EqualImage] {
        let urls = ["png", "jpg"].flatMap { Bundle.module.urls(forResourcesWithExtension: $0, subdirectory: nil) ?? [] }
        return urls.map { $0.pathExtension == "png" ? EqualImage($0.deletingPathExtension().lastPathComponent) : EqualImage($0.lastPathComponent) }
            .sorted { $0.name < $1.name }
    }

    var url: URL? {
        let hasExt = name.hasSuffix(".jpg") || name.hasSuffix(".png") || name.hasSuffix(".gif")
        let base = hasExt ? String(name.dropLast(4)) : name
        return Bundle.module.url(forResource: base, withExtension: hasExt ? String(name.suffix(3)) : "png")
    }

    /// The image as a SwiftUI `Image` (resizable).
    public var image: Image {
        if let url, let src = CGImageSourceCreateWithURL(url as CFURL, nil),
           let cg = CGImageSourceCreateImageAtIndex(src, 0, nil) {
            return Image(decorative: cg, scale: 1).resizable()
        }
        return Image(systemName: "photo").resizable()
    }
}

/// `EqualImage` at a square size, aspect-fit.
public struct EqualIllustration: View {
    let image: EqualImage
    let size: CGFloat

    public init(_ image: EqualImage, size: CGFloat) {
        self.image = image
        self.size = size
    }

    public var body: some View {
        image.image
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

/// The doodle wallpaper (phones, rickshaws, cards, buildings…) used behind the splash, the trial
/// screens and the Equal chat. A tinted image: 392 hand-drawn vectors are too heavy to draw in code.
public struct EqualDoodlePattern: View {
    let color: Color

    public init(color: Color = Color(equalHex: 0x737373)) { self.color = color }

    public var body: some View {
        EqualImage.doodlePattern.image
            .renderingMode(.template)
            .aspectRatio(contentMode: .fill)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
}

/// Animated GIFs bundled with the package.
public struct EqualAnimation: Hashable, Sendable {
    public let rawValue: String
    public init(_ name: String) { self.rawValue = name }
    /// 3D waving hand with sparkles (welcome break screen).
    public static let waveHand = EqualAnimation("wave-hand")
    /// Green/lime swoosh (Lottie preview on the soft paywall).
    public static let greenSwoosh = EqualAnimation("lottie-preview-green-swoosh")
    /// Ripple rings with a gold glow (payment loading state).
    public static let rippleShine = EqualAnimation("ripple-bottom-shine")
}

/// Plays a bundled GIF with SwiftUI only (TimelineView), so it also renders in previews and snapshots.
public struct EqualAnimatedImage: View {
    private let frames: [CGImage]
    private let durations: [Double]
    private let total: Double
    let size: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ animation: EqualAnimation, size: CGFloat) {
        self.size = size
        var f: [CGImage] = [], d: [Double] = []
        if let url = Bundle.module.url(forResource: animation.rawValue, withExtension: "gif"),
           let src = CGImageSourceCreateWithURL(url as CFURL, nil) {
            for i in 0..<CGImageSourceGetCount(src) {
                guard let cg = CGImageSourceCreateImageAtIndex(src, i, nil) else { continue }
                let props = CGImageSourceCopyPropertiesAtIndex(src, i, nil) as? [CFString: Any]
                let gif = props?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
                let delay = (gif?[kCGImagePropertyGIFUnclampedDelayTime] as? Double) ?? (gif?[kCGImagePropertyGIFDelayTime] as? Double) ?? 0.1
                f.append(cg); d.append(max(0.02, delay))
            }
        }
        frames = f
        durations = d
        total = d.reduce(0, +)
    }

    public var body: some View {
        TimelineView(.animation(paused: reduceMotion || frames.count < 2)) { context in
            if let frame = frame(at: context.date) {
                Image(decorative: frame, scale: 1).resizable().aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    private func frame(at date: Date) -> CGImage? {
        guard !frames.isEmpty else { return nil }
        guard total > 0, !reduceMotion else { return frames[0] }
        var t = date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: total)
        for (i, d) in durations.enumerated() {
            if t < d { return frames[i] }
            t -= d
        }
        return frames.last
    }
}
