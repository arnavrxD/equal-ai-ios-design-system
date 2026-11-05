import SwiftUI

/// Top of the Gold free-week screens: crown (or crowned mascot), "Equal Gold / Free for a week!",
/// "No card, no autopay, nothing to cancel." and the trial progress, over one of four backgrounds.
/// The `.price` variant ("Equal Gold / ₹249/month") swaps the subtitle and progress for the
/// free-week recap strip. Place it edge to edge at the very top of the screen (it includes the
/// status-bar inset).
public struct EqualTrialHero: View {
    public enum Background: Sendable {
        /// Soft-paywall gold dome (547 ellipse, white → gold; black → gold in dark mode) with 8 white rays.
        case goldDome
        /// Gold glow (148, blur 160) with 8 rays on the light doodle page.
        case goldGlow
        /// Green → lime disc over the top of the page.
        case limeDisc
        /// Black page with a 70% gold glow; always rendered in dark appearance.
        case dark
    }

    public enum Art: Sendable { case crown, mascot }

    public enum Variant: Sendable {
        /// "Free for a week!", subtitle and progress.
        case freeWeek
        /// Second line is the price ("₹249/month"); the recap strip replaces subtitle and progress.
        case price(String)
    }

    let background: Background
    let art: Art
    let variant: Variant
    let progressDay: Int?
    let stats: [EqualRecapStrip.Stat]

    /// - Parameters:
    ///   - progressDay: day shown on the progress bar; nil hides it (the long gold-dome page).
    ///   - stats: recap columns for `.price`.
    public init(background: Background = .goldDome, art: Art = .crown, variant: Variant = .freeWeek, progressDay: Int? = 1, stats: [EqualRecapStrip.Stat] = EqualRecapStrip.sampleStats) {
        self.background = background
        self.art = art
        self.variant = variant
        self.progressDay = progressDay
        self.stats = stats
    }

    private var isPrice: Bool { if case .price = variant { return true } else { return false } }
    private var usesMascot: Bool { art == .mascot }

    public var body: some View {
        let l = layout
        VStack(spacing: 0) {
            artView.padding(.top, l.artTop)
            VStack(spacing: 2) {
                Text("Equal Gold").equalTextStyle(usesMascot ? .title1 : .largeTitle).foregroundStyle(EqualColor.textPrimary)
                Text(secondLine).equalTextStyle(.title1Em).foregroundStyle(accent)
            }
            .padding(.top, l.titleGap)
            if isPrice {
                EqualRecapStrip(stats: stats).padding(.top, l.subtitleGap)
            } else {
                Text("No card, no autopay, nothing to cancel.\nJust use and explore")
                    .equalTextStyle(l.subtitleStyle)
                    .foregroundStyle(subtitleColor)
                    .multilineTextAlignment(.center)
                    .fixedSize()
                    .frame(minWidth: l.subtitleWidth)
                    .padding(.top, l.subtitleGap)
                if let progressDay {
                    EqualTrialProgress(progressStyle, day: progressDay).padding(.top, l.progressGap)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: l.minHeight, alignment: .top)
        .background(alignment: .top) { backgroundLayer(l) }
        .environment(\.colorScheme, forcedScheme ?? scheme)
        .accessibilityElement(children: .combine)
    }

    @Environment(\.colorScheme) private var scheme
    private var forcedScheme: ColorScheme? { background == .dark ? .dark : nil }

    private var secondLine: String {
        if case .price(let p) = variant { return p }
        return "Free for a week!"
    }

    private var accent: Color {
        switch background {
        case .goldDome: return Color.equalDynamic(light: 0xB17300, dark: 0xFFC14E)
        case .limeDisc where usesMascot: return Color(equalHex: 0xE09200)
        default: return EqualColor.goldInk
        }
    }

    private var subtitleColor: Color {
        background == .goldDome ? Color.equalDynamic(light: 0x555555, dark: 0xF7F7F7) : EqualColor.textSecondary
    }

    private var progressStyle: EqualTrialProgress.Style {
        switch background {
        case .goldDome: return .timeline
        case .goldGlow: return .continuous
        case .limeDisc, .dark: return .segmented
        }
    }

    @ViewBuilder private var artView: some View {
        switch art {
        case .crown:
            let size: CGFloat = background == .limeDisc ? 132 : 90
            EqualImage.crown.image.aspectRatio(contentMode: .fit)
                .frame(width: size * 0.95, height: size)
        case .mascot:
            FramedArt.mascotCrown(160)
        }
    }

    // MARK: Layout (Figma y positions on a 393pt frame, status bar included)

    struct Layout {
        var artTop: CGFloat
        var titleGap: CGFloat
        var subtitleGap: CGFloat
        var subtitleStyle: EqualTextStyle
        var subtitleWidth: CGFloat
        var progressGap: CGFloat
        var minHeight: CGFloat
        /// Centre of the rays / glow / disc.
        var decorCenterY: CGFloat
        var domeTop: CGFloat
    }

    private var layout: Layout {
        switch background {
        case .goldDome:
            if isPrice {
                return Layout(artTop: 69, titleGap: 4, subtitleGap: 42, subtitleStyle: .footnote, subtitleWidth: 221, progressGap: 20, minHeight: 268, decorCenterY: 119, domeTop: -279)
            }
            let domeTop: CGFloat = progressDay == nil ? -216 : -154
            return Layout(artTop: 69, titleGap: 4, subtitleGap: 12, subtitleStyle: .footnote, subtitleWidth: 221, progressGap: 20, minHeight: domeTop + 547, decorCenterY: 119, domeTop: domeTop)
        case .goldGlow:
            return Layout(artTop: 77, titleGap: 3, subtitleGap: 11, subtitleStyle: .footnote, subtitleWidth: 221, progressGap: 27, minHeight: 0, decorCenterY: 131, domeTop: 0)
        case .dark:
            return Layout(artTop: 77, titleGap: 7, subtitleGap: 23, subtitleStyle: .body, subtitleWidth: 289, progressGap: 38, minHeight: 0, decorCenterY: 45, domeTop: 0)
        case .limeDisc:
            if usesMascot {
                return Layout(artTop: 66, titleGap: -5, subtitleGap: 16, subtitleStyle: .subhead, subtitleWidth: 255, progressGap: 53, minHeight: 0, decorCenterY: 128, domeTop: 0)
            }
            return Layout(artTop: 105, titleGap: 1, subtitleGap: 9, subtitleStyle: .body, subtitleWidth: 289, progressGap: 38, minHeight: 0, decorCenterY: -50, domeTop: 0)
        }
    }

    @ViewBuilder private func backgroundLayer(_ l: Layout) -> some View {
        switch background {
        case .goldDome:
            ZStack(alignment: .top) {
                Circle()
                    .fill(LinearGradient(stops: [
                        .init(color: Color.equalDynamic(light: 0xFFFFFF, dark: 0x000000), location: 0),
                        .init(color: Color.equalDynamic(light: 0xFFFEFC, dark: 0x000000), location: 0.001),
                        .init(color: Color(equalHex: 0xFFC927), location: 1)
                    ], startPoint: .top, endPoint: .bottom))
                    .frame(width: 547, height: 547)
                    .offset(y: l.domeTop)
                EqualTrialRays().opacity(0.6).offset(y: l.decorCenterY - 173)
            }
            .frame(width: 547)
        case .goldGlow:
            ZStack(alignment: .top) {
                Circle().fill(Color(equalHex: 0xFFCE49)).frame(width: 148, height: 148).blur(radius: 80).offset(y: 31)
                EqualTrialRays().offset(y: l.decorCenterY - 173)
            }
            .frame(width: 393)
        case .dark:
            Circle().fill(Color(equalHex: 0xFFCE49, alpha: 0.7)).frame(width: 148, height: 148).blur(radius: 80).offset(y: -29)
        case .limeDisc:
            ZStack(alignment: .top) {
                Circle()
                    .fill(LinearGradient(colors: [EqualColor.brandGreen, EqualColor.brandLime], startPoint: .top, endPoint: .bottom))
                    .frame(width: 504, height: 504)
                    .offset(y: l.decorCenterY - 252)
                if usesMascot { EqualTrialRays().opacity(0.5).offset(y: 153 - 173) }
            }
            .frame(width: 504)
        }
    }
}

/// Eight 54×137 white rays at 45° steps, starting 36pt from the centre, clear at the root and
/// white 50% at the tip. 346pt square, centred on the crown.
struct EqualTrialRays: View {
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Rectangle()
                    .fill(LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 54, height: 137)
                    .offset(y: -(36 + 137 / 2))
                    .rotationEffect(.degrees(Double(i) * 45))
            }
        }
        .frame(width: 346, height: 346)
        .blur(radius: 5)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct EqualTrialHero_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            EqualTrialHero()
            EqualTrialHero(background: .limeDisc, art: .mascot)
        }
        .frame(width: 393)
        .clipped()
        .background(EqualColor.bgPrimary)
    }
}
