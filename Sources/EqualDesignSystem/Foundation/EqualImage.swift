import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// The 3D illustrations and app icons bundled with the package (Resources/Images).
public enum EqualImage: String, CaseIterable, Sendable {
    case crown, mascot, mascotWave = "mascot-wave", mascotCrown = "mascot-crown", assistantBot = "assistant-bot"
    case bell, gear, avatarMale = "avatar-male", avatarFemale = "avatar-female", flagIndia = "flag-india"
    case categoryFinance = "category-finance", categoryRide = "category-ride", categoryDelivery = "category-delivery"
    case categoryOthers = "category-others", callerPhone = "caller-phone", inviteHands = "invite-hands"
    case appIconGreen = "app-icon-equal-green", goldCrownGradient = "equal-gold-crown-gradient", goldCrownDark = "equal-gold-crown-dark"
    case goldMascotGradient = "equal-gold-mascot-gradient", goldMascotDark = "equal-gold-mascot-dark", goldLogoCrownDark = "equal-gold-logo-crown-dark"

    /// The image as a SwiftUI `Image` (resizable).
    public var image: Image {
        #if canImport(UIKit)
        if let ui = UIImage(named: rawValue, in: .module, with: nil) { return Image(uiImage: ui).resizable() }
        #elseif canImport(AppKit)
        if let ns = Bundle.module.image(forResource: rawValue) { return Image(nsImage: ns).resizable() }
        #endif
        return Image(systemName: "photo").resizable()
    }
}

/// `EqualImage.crown.view` style convenience with aspect-fit.
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
