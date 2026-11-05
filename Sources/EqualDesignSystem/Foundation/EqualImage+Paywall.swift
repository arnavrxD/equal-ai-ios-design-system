// Paywall art: the "What you get" carousel panels, exported flat from Figma at @3x (303×207 each).
// They are product mock-ups built from hundreds of layers plus 3D renders, so they ship as images;
// the card around them (tag, border, text) is drawn in code by `EqualFeatureCard`.
import SwiftUI

public extension EqualImage {
    /// Call Screening panel: iPhone with the live chat, call-summary card and the phone mascot (Figma 25683:26844).
    static let featureArtCallScreening = EqualImage("feature-art-call-screening")
    /// Handles calls from your contacts panel: iPhone with the live-call card and Takeover (25683:27214).
    static let featureArtContacts = EqualImage("feature-art-contacts")
    /// Speaks your language panel: language letter tiles and the talking mascot (25683:28353).
    static let featureArtLanguage = EqualImage("feature-art-language")
    /// Instructions panel: call log with an instruction and the reading mascot (25683:28411).
    static let featureArtInstructions = EqualImage("feature-art-instructions")
    /// Saved addresses panel: assistant address settings and the map mascot (25683:28516).
    static let featureArtAddresses = EqualImage("feature-art-addresses")
    /// Post-call Actions panel: chat with WhatsApp / reminder action chips (25683:28564).
    static let featureArtPostCall = EqualImage("feature-art-post-call")
    /// Full-bleed Call Screening art for the carousel-first paywall (25749:21790, 393×319 @2x).
    static let featureArtHero = EqualImage("feature-art-hero")
}
