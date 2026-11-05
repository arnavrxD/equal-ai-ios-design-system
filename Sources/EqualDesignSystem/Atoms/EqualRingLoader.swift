import SwiftUI

/// Ring spinner: a full-circle track with a flat-ended quarter arc turning on top, and an optional
/// centre slot (the payment loader puts the 3D crown in it).
///
/// Two Figma sizes of the shared `loader` component: `.small` (29pt frame, 24pt ring, 2.4pt thick,
/// `#D0D0D0` track, `#070707` arc; the processing sheet) and `.large` (160pt frame, 133pt ring,
/// 6.65pt thick, black 12% track, `#5E460C` arc; the payment wait screen). Both have dark colours
/// (`.large`: white 18% / `#C88D00`). Pass `size` to scale a style. Under Reduce Motion the arc
/// stays still.
public struct EqualRingLoader<Content: View>: View {
    /// Geometry and colours of a ring loader.
    public struct Style: Sendable {
        /// Frame side.
        public var frame: CGFloat
        /// Outer diameter of the ring, centred in the frame.
        public var ringDiameter: CGFloat
        /// Ring thickness.
        public var lineWidth: CGFloat
        /// Track colour (adapts to the colour scheme).
        public var track: Color
        /// Spinning arc colour (adapts to the colour scheme).
        public var indicator: Color
        /// Arc length as a fraction of the circle.
        public var arc: Double
        /// Seconds per turn.
        public var period: Double

        public init(frame: CGFloat, ringDiameter: CGFloat, lineWidth: CGFloat, track: Color, indicator: Color, arc: Double = 0.25, period: Double = 1) {
            self.frame = frame
            self.ringDiameter = ringDiameter
            self.lineWidth = lineWidth
            self.track = track
            self.indicator = indicator
            self.arc = arc
            self.period = period
        }

        /// 29pt sheet spinner: 24pt ring, 2.4pt thick, `#D0D0D0` / `#070707`.
        public static var small: Style { Style(
            frame: 29, ringDiameter: 24, lineWidth: 2.4,
            track: .equalDynamic(light: 0xD0D0D0, dark: 0xFFFFFF, darkAlpha: 0.18),
            indicator: .equalDynamic(light: 0x070707, dark: 0xF7F7F7)
        ) }

        /// 160pt payment loader: 133pt ring, 6.65pt thick, black 12% / `#5E460C`
        /// (dark: white 18% / `#C88D00`).
        public static var large: Style { Style(
            frame: 160, ringDiameter: 133, lineWidth: 6.65,
            track: .equalDynamic(light: 0x000000, lightAlpha: 0.12, dark: 0xFFFFFF, darkAlpha: 0.18),
            indicator: .equalDynamic(light: 0x5E460C, dark: 0xC88D00)
        ) }
    }

    let style: Style
    let scale: CGFloat
    let content: Content
    @State private var spinning = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// - Parameters:
    ///   - style: `.small` or `.large`, or a custom `Style`.
    ///   - size: frame side; scales the whole style. Defaults to the style's own frame.
    ///   - content: drawn in the centre (e.g. the crown).
    public init(_ style: Style = .small, size: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.style = style
        self.scale = (size ?? style.frame) / style.frame
        self.content = content()
    }

    public var body: some View {
        let ring = style.ringDiameter * scale
        let width = style.lineWidth * scale
        ZStack {
            Circle().inset(by: width / 2).stroke(style.track, lineWidth: width)
                .frame(width: ring, height: ring)
            Circle().inset(by: width / 2).trim(from: 0, to: style.arc)
                .stroke(style.indicator, style: StrokeStyle(lineWidth: width, lineCap: .butt))
                .frame(width: ring, height: ring)
                // Trim starts at 3 o'clock; Figma's arc starts at 12 o'clock.
                .rotationEffect(.degrees(-90 + (spinning ? 360 : 0)))
            content
        }
        .frame(width: style.frame * scale, height: style.frame * scale)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: style.period).repeatForever(autoreverses: false)) { spinning = true }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading")
        .accessibilityAddTraits(.updatesFrequently)
    }
}

public extension EqualRingLoader where Content == EmptyView {
    /// A ring loader with nothing in the centre.
    init(_ style: Style = .small, size: CGFloat? = nil) {
        self.init(style, size: size) { EmptyView() }
    }
}

struct EqualRingLoader_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 24) {
            EqualRingLoader(.small)
            EqualRingLoader(.large, size: 80)
            EqualRingLoader(.large) { EqualIllustration(.crown, size: 95) }
        }
        .padding(24)
        .background(EqualGradient.processing)
    }
}
