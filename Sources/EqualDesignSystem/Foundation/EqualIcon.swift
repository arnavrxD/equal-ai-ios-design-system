import SwiftUI

/// UI glyphs mapped to SF Symbols, the icon system the Figma file uses
/// (the exported SVG originals live in design/icons).
public enum EqualIcon: String, CaseIterable, Sendable {
    case chevronRight = "chevron.right"
    case chevronDown = "chevron.down"
    case chevronLeft = "chevron.left"
    case close = "xmark"
    case search = "magnifyingglass"
    case check = "checkmark"
    case plus = "plus"
    case phone = "phone.fill"
    case phoneOutline = "phone"
    case mic = "mic.fill"
    case keyboard = "keyboard"
    case bell = "bell"
    case bellSlash = "bell.slash"
    case document = "doc.text"
    case globe = "globe"
    case shield = "shield"
    case message = "message"
    case messageFill = "message.fill"
    case bolt = "bolt"
    case person = "person.fill"
    case more = "ellipsis"
    case wand = "wand.and.stars"
    case gear = "gearshape"
    case share = "square.and.arrow.up"
    case replay = "play.fill"
    case support = "headphones"
    case faceID = "faceid"
    case calendar = "calendar"
    case pencil = "pencil"
    case chat = "bubble.left.fill"
    case compass = "safari"
    case waveform = "waveform"
    case speaker = "speaker.wave.2.fill"
    case lock = "lock.fill"
    case creditCard = "creditcard"
    case star = "star"
    case seal = "checkmark.seal.fill"

    public var image: Image { Image(systemName: rawValue) }
}

/// An SF Symbol icon at a size, inheriting the foreground style.
public struct EqualIconView: View {
    let icon: EqualIcon
    let size: CGFloat
    let weight: Font.Weight

    public init(_ icon: EqualIcon, size: CGFloat = 20, weight: Font.Weight = .medium) {
        self.icon = icon
        self.size = size
        self.weight = weight
    }

    public var body: some View {
        icon.image
            .font(.system(size: size, weight: weight))
            .accessibilityHidden(true)
    }
}
