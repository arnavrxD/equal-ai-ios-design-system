import SwiftUI

/// "What you get" carousel card: an art panel over a title and a short description.
///
/// - `.exclusive` (280×292, radius 20): gold border with a 3pt #F7CB3C 14% ring, cream panel with
///   a warm glow, the crown and the "30 calls a month → Unlimited" pills, "Only in Gold Plus" tag.
/// - `.standard` (303×292, radius 16): black 8% border, the 303×207 product art on #F7F7F7 with
///   a warm glow, "Both plans" tag.
/// - `.trial` (303×292): the soft-paywall card, no border and no tag.
/// - `.hero`: the full-bleed top of the carousel-first paywall (393×319 art, centred text).
///
/// Use `EqualFeatureCard.Content.paywall` for the seven Figma cards.
public struct EqualFeatureCard: View {
    public enum Style: Sendable { case exclusive, standard, trial, hero }

    /// One card's copy and art.
    public struct Content: Identifiable, Sendable {
        public let title: String
        public let message: String
        public let art: EqualImage
        /// Gold Plus only (drawn with the `.exclusive` style).
        public let isExclusive: Bool
        public var id: String { title }

        public init(_ title: String, _ message: String, art: EqualImage, isExclusive: Bool = false) {
            self.title = title
            self.message = message
            self.art = art
            self.isExclusive = isExclusive
        }

        /// The seven cards of the paywall carousel, in Figma order.
        public static let paywall: [Content] = [
            Content("Unlimited AI calls", "No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.", art: .crown, isExclusive: true),
            Content("Call Screening", "Spam, sales, or someone who actually needs you. Your assistant finds out first.", art: .featureArtCallScreening),
            Content("Handles calls from your contacts", "In a meeting? It takes the message and tells you what mattered.", art: .featureArtContacts),
            Content("Speaks your language", "Choose from 10+ languages and 4 voices to make your assistant feel more like you.", art: .featureArtLanguage),
            Content("Instructions", "Tell Equal what to do or say. It does exactly that, for any call that you want.", art: .featureArtInstructions),
            Content("Saved addresses", "Delivery and cab drivers get it without calling you multiple times to confirm.", art: .featureArtAddresses),
            Content("Post-call Actions", "Take relevant actions based on your calls. Set reminder, reply on WhatsApp, mute, and more.", art: .featureArtPostCall)
        ]
    }

    let content: Content
    let style: Style

    public init(_ content: Content, style: Style? = nil) {
        self.content = content
        self.style = style ?? (content.isExclusive ? .exclusive : .standard)
    }

    /// Back-compatible initialiser: exclusive cards draw the crown panel, others show `art`.
    public init(title: String = "Unlimited AI calls", message: String = "No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.", isExclusive: Bool = true, art: EqualImage = .crown) {
        self.init(Content(title, message, art: art, isExclusive: isExclusive))
    }

    /// Card width in the carousel.
    public var width: CGFloat {
        switch style {
        case .exclusive: 280
        case .standard, .trial: 303
        case .hero: 393
        }
    }

    public var body: some View {
        switch style {
        case .exclusive: exclusive
        case .standard, .trial: standard
        case .hero: hero
        }
    }

    // MARK: Styles

    private var exclusive: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                LinearGradient(colors: [Color(equalHex: 0xFFF3C9), Color(equalHex: 0xFBF8EE)], startPoint: .top, endPoint: .bottom)
                RadialGradient(stops: [
                    .init(color: Color(equalHex: 0xFCDE8C, alpha: 0.85), location: 0),
                    .init(color: Color(equalHex: 0xFAF0D6, alpha: 0.25), location: 0.5),
                    .init(color: Color(equalHex: 0xFAF0D6, alpha: 0), location: 1)
                ], center: .center, startRadius: 0, endRadius: 110)
                .frame(width: 220, height: 220)
                .offset(y: -30)
                EqualIllustration(.crown, size: 84).offset(y: 32)
                HStack(spacing: 10) {
                    Text("30 calls a month").font(.equal(size: 13, weight: .semibold)).strikethrough()
                        .foregroundStyle(Color(equalHex: 0x9C9682))
                        .frame(width: 127, height: 31)
                        .background(Capsule().fill(Color.white))
                        .overlay(Capsule().strokeBorder(Color(equalHex: 0xE7E2D2), lineWidth: 1))
                    EqualArrowGlyph().stroke(Color(equalHex: 0xC9960C), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .frame(width: 18, height: 10)
                    Text("Unlimited").font(.equal(size: 13, weight: .bold)).foregroundStyle(EqualColor.grey01)
                        .frame(width: 85, height: 31)
                        .background(Capsule().fill(Color(equalHex: 0xEEFBC9)))
                        .overlay(Capsule().strokeBorder(Color(equalHex: 0xD2EE8A), lineWidth: 1))
                }
                .offset(y: 130)
            }
            .frame(width: 278, height: 192)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 19, topTrailingRadius: 19))
            .padding([.top, .horizontal], 1)
            .overlay(alignment: .topLeading) { EqualFeatureTag("Only in Gold Plus", exclusive: true).padding(11) }
            text(width: 238)
        }
        .frame(width: 280, height: 292, alignment: .top)
        .background(RoundedRectangle(cornerRadius: EqualRadius.l).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.l).strokeBorder(EqualColor.goldBorder, lineWidth: 1))
        // outer ring: #F7CB3C 14%, spread 3, no blur
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.l + 1.5).stroke(EqualColor.goldLabel.opacity(0.14), lineWidth: 3).padding(-1.5))
        .accessibilityElement(children: .combine)
    }

    private var standard: some View {
        VStack(spacing: 0) {
            artPanel(width: 303, height: 207)
                .overlay(alignment: .topLeading) {
                    if style == .standard { EqualFeatureTag("Both plans", exclusive: false).padding(11) }
                }
            text(width: 264)
        }
        .frame(width: 303, height: 292, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .overlay {
            if style == .standard { RoundedRectangle(cornerRadius: EqualRadius.m).strokeBorder(EqualColor.strokeMedium, lineWidth: 1) }
        }
        .accessibilityElement(children: .combine)
    }

    private var hero: some View {
        VStack(spacing: 20) {
            artPanel(width: nil, height: 319, glowBlur: 81)
            VStack(spacing: 1) {
                Text(content.title).font(.equal(size: 17, weight: .semibold)).tracking(-0.44).foregroundStyle(EqualColor.grey01)
                Text(content.message).font(.equal(size: 12)).foregroundStyle(EqualColor.grey05).lineSpacing(0.4)
            }
            .multilineTextAlignment(.center)
            .frame(width: 264)
        }
        .padding(.top, 4)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: Parts

    /// #F7F7F7 panel with two #FFF4BB 80% glows (blur 124) under the flattened product art.
    private func artPanel(width: CGFloat?, height: CGFloat, glowBlur: CGFloat = 62) -> some View {
        ZStack {
            Color(equalHex: 0xF7F7F7)
            Ellipse().fill(Color(equalHex: 0xFFF4BB, alpha: 0.8)).frame(width: 323, height: 323).blur(radius: glowBlur).offset(x: -120, y: -160)
            Ellipse().fill(Color(equalHex: 0xFFF4BB, alpha: 0.8)).frame(width: 323, height: 323).blur(radius: glowBlur).offset(x: 140, y: 170)
            if content.art.name.hasPrefix("feature-art") {
                content.art.image.aspectRatio(contentMode: .fill)
            } else {
                EqualIllustration(content.art, size: 140)
            }
        }
        .frame(width: width, height: height)
        .frame(maxWidth: width == nil ? .infinity : nil)
        .clipped()
        .accessibilityHidden(true)
    }

    private func text(width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(content.title).font(.equal(size: 17, weight: .semibold)).tracking(-0.44).foregroundStyle(EqualColor.grey01)
                .lineLimit(1).minimumScaleFactor(0.9)
            Text(content.message).font(.equal(size: 12)).tracking(-0.31).lineSpacing(0.4).foregroundStyle(EqualColor.grey05)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: width, alignment: .leading)
        .padding(.leading, 19).padding(.top, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Tag at the card's top-left: "Only in Gold Plus" (#2B2416, gold text) or "Both plans" (grey).
struct EqualFeatureTag: View {
    let text: String
    let exclusive: Bool
    init(_ text: String, exclusive: Bool) { self.text = text; self.exclusive = exclusive }
    var body: some View {
        Text(text).font(.equal(size: 11, weight: .bold))
            .foregroundStyle(exclusive ? EqualColor.goldLabel : EqualColor.grey05)
            .padding(.horizontal, 12).frame(height: exclusive ? 22 : 24)
            .background(RoundedRectangle(cornerRadius: EqualRadius.tag).fill(exclusive ? EqualColor.goldDeep : Color(equalHex: 0xF7F7F7)))
            .overlay { if !exclusive { RoundedRectangle(cornerRadius: EqualRadius.tag).strokeBorder(EqualColor.strokeMedium, lineWidth: 1) } }
            .fixedSize()
    }
}

/// The 18×10 chevron arrow between the "Was" and "Now" pills.
struct EqualArrowGlyph: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + 1, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX - 1, y: rect.midY))
        p.move(to: CGPoint(x: rect.maxX - rect.height / 2 - 1, y: rect.minY + 1))
        p.addLine(to: CGPoint(x: rect.maxX - 1, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX - rect.height / 2 - 1, y: rect.maxY - 1))
        return p
    }
}

struct EqualFeatureCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            HStack(alignment: .top, spacing: 28) {
                EqualFeatureCard()
                EqualFeatureCard(EqualFeatureCard.Content.paywall[1])
            }
            EqualFeatureCard(EqualFeatureCard.Content.paywall[1], style: .hero).frame(width: 393)
        }
        .padding(24)
        .background(EqualColor.grey14)
    }
}
