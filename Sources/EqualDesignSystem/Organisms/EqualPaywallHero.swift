import SwiftUI

/// Paywall top: a gold shape (circle, shallow arc or rounded-bottom block) fading from white to
/// gold, eight soft rays and the 3D crown, the frost close button with "Restore purchases", and
/// the title block.
///
/// Positions follow the 393pt Figma frames and are measured from the top of the screen, so place
/// the hero under the status bar (`.ignoresSafeArea(edges: .top)`). Shapes:
/// - `.circle` (A): 547pt circle, crown and rays, title at y191 (the default paywall).
/// - `.compactArc` (B): the same circle pushed up, no crown, title at y110.
/// - `.shallowArc` (C): 1114pt circle with a gentle curve, crown at y69.
/// - `.roundedBottom(28)` (D, with crown) / `.roundedBottom(48)` (E, compact, no crown).
///
/// Limit paywalls pass `preTitle`: a SemiBold 16 line ("Equal made 30 calls for you") sits above
/// an ExtraBold 28 title, the crown is always shown, and `.roundedBottom` / `.circle` switch to
/// the limit geometry (248pt hero, shape overflowing to y270–279).
public struct EqualPaywallHero: View {
    public enum Shape: Sendable, Equatable {
        case circle, compactArc, shallowArc
        case roundedBottom(CGFloat)
    }

    /// The shape's vertical gradient.
    public enum Tint: Sendable {
        /// White → #FFC927 (free-trial paywalls, settings).
        case gold
        /// White → #FED354 (Gold limit).
        case sunrise
        /// #FEF9E8 → #FFF1C8 → #FEE497 → #FED354 (trial limit, trial ended, plan expired).
        case warm

        var gradient: LinearGradient {
            switch self {
            case .gold: LinearGradient(colors: [.white, Color(equalHex: 0xFFC927)], startPoint: .top, endPoint: .bottom)
            case .sunrise: LinearGradient(colors: [.white, Color(equalHex: 0xFED354)], startPoint: .top, endPoint: .bottom)
            case .warm: LinearGradient(stops: [
                .init(color: Color(equalHex: 0xFEF9E8), location: 0.32),
                .init(color: Color(equalHex: 0xFFF1C8), location: 0.5),
                .init(color: Color(equalHex: 0xFEE497), location: 0.72),
                .init(color: Color(equalHex: 0xFED354), location: 1)
            ], startPoint: .top, endPoint: .bottom)
            }
        }
    }

    let title: String
    let subtitle: Text
    let preTitle: String?
    let shape: Shape
    let tint: Tint
    let showsCrown: Bool
    let showsTopBar: Bool
    let onClose: () -> Void
    let onRestore: () -> Void

    /// - Parameters:
    ///   - preTitle: limit-paywall line above the title; switches the title to ExtraBold and hides `subtitle`.
    ///   - showsCrown: `nil` picks the shape's default (A, C, D and limit heroes have the crown and rays).
    ///   - showsTopBar: close button and "Restore purchases". Keep it on: App Review expects a visible dismiss.
    public init(title: String = "Choose your plan",
                subtitle: Text = Text("1 day").bold() + Text(" left in your free trial"),
                preTitle: String? = nil,
                shape: Shape = .circle,
                tint: Tint = .gold,
                showsCrown: Bool? = nil,
                showsTopBar: Bool = true,
                onClose: @escaping () -> Void = {},
                onRestore: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.preTitle = preTitle
        self.shape = shape
        self.tint = tint
        self.showsCrown = showsCrown ?? Self.defaultCrown(shape, isLimit: preTitle != nil)
        self.showsTopBar = showsTopBar
        self.onClose = onClose
        self.onRestore = onRestore
    }

    static func defaultCrown(_ shape: Shape, isLimit: Bool) -> Bool {
        if isLimit { return true }
        switch shape {
        case .circle, .shallowArc: return true
        case .compactArc: return false
        case .roundedBottom(let r): return r < 40
        }
    }

    /// Absolute positions inside the 393pt frame.
    struct Metrics {
        /// Gold shape: width (`nil` = full width), height, top y and corner radius.
        var shapeWidth: CGFloat?
        var shapeHeight: CGFloat
        var shapeY: CGFloat
        var cornerRadius: CGFloat
        var crownY: CGFloat
        var titleY: CGFloat
        /// Bottom of the hero (where the shape ends).
        var height: CGFloat
        /// Bottom of the subtitle (or the title on limit heroes): cards that overlap the hero start 22pt below.
        var textBottom: CGFloat
    }

    var metrics: Metrics { Self.metrics(shape: shape, isLimit: preTitle != nil, showsCrown: showsCrown) }

    static func metrics(shape: Shape, isLimit: Bool, showsCrown: Bool) -> Metrics {
        if isLimit {
            switch shape {
            case .roundedBottom(let r):
                return Metrics(shapeWidth: nil, shapeHeight: 547, shapeY: -277, cornerRadius: r, crownY: 96, titleY: 216, height: 270, textBottom: 248)
            default:
                return Metrics(shapeWidth: 547, shapeHeight: 547, shapeY: -268, cornerRadius: 273.5, crownY: 96, titleY: 216, height: 279, textBottom: 248)
            }
        }
        switch shape {
        case .circle:
            return Metrics(shapeWidth: 547, shapeHeight: 547, shapeY: -184, cornerRadius: 273.5, crownY: 101, titleY: 191, height: 363, textBottom: 249)
        case .compactArc:
            return Metrics(shapeWidth: 547, shapeHeight: 547, shapeY: -265, cornerRadius: 273.5, crownY: 20, titleY: 110, height: 282, textBottom: 168)
        case .shallowArc:
            return Metrics(shapeWidth: 1114, shapeHeight: 1114, shapeY: -857, cornerRadius: 557, crownY: 69, titleY: 170, height: 257, textBottom: 228)
        case .roundedBottom(let r):
            return showsCrown
                ? Metrics(shapeWidth: nil, shapeHeight: 530, shapeY: -245, cornerRadius: r, crownY: 106, titleY: 207, height: 285, textBottom: 265)
                : Metrics(shapeWidth: nil, shapeHeight: 446, shapeY: -239, cornerRadius: r, crownY: 29, titleY: 119, height: 207, textBottom: 177)
        }
    }

    public var body: some View {
        let m = metrics
        ZStack(alignment: .top) {
            Color.clear
            if showsCrown {
                EqualIllustration(.crown, size: 90).offset(y: m.crownY)
            }
            if showsTopBar { topBar.offset(y: 58) }
            if let preTitle {
                Text(preTitle).font(.equal(size: 16, weight: .semibold)).foregroundStyle(EqualColor.grey05)
                    .frame(height: 18).offset(y: 196)
                Text(title).font(.equal(size: 28, weight: .heavy)).foregroundStyle(EqualColor.grey01)
                    .frame(height: 32).offset(y: m.titleY)
                    .accessibilityAddTraits(.isHeader)
            } else {
                Text(title).font(.equal(size: 28, weight: .bold)).foregroundStyle(EqualColor.grey01)
                    .frame(height: 36).offset(y: m.titleY)
                    .accessibilityAddTraits(.isHeader)
                subtitle.font(.equal(size: 15)).foregroundStyle(EqualColor.grey03)
                    .frame(height: 20).offset(y: m.titleY + 38)
            }
        }
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .frame(maxWidth: .infinity)
        .frame(height: m.height, alignment: .top)
        .background(alignment: .top) {
            ZStack(alignment: .top) {
                goldShape(m)
                if showsCrown {
                    EqualPaywallRays().offset(y: m.crownY + 45 + 4 - EqualPaywallRays.size / 2)
                }
            }
        }
        .clipped()
        .environment(\.colorScheme, .light)
    }

    @ViewBuilder private func goldShape(_ m: Metrics) -> some View {
        let fill = tint.gradient
        Group {
            if let w = m.shapeWidth {
                RoundedRectangle(cornerRadius: m.cornerRadius).fill(fill).frame(width: w, height: m.shapeHeight)
            } else {
                UnevenRoundedRectangle(bottomLeadingRadius: m.cornerRadius, bottomTrailingRadius: m.cornerRadius).fill(fill)
                    .frame(maxWidth: .infinity).frame(height: m.shapeHeight)
            }
        }
        .offset(y: m.shapeY)
        .accessibilityHidden(true)
    }

    private var topBar: some View {
        HStack {
            EqualIconButton(.close, variant: .frost, label: "Close", action: onClose)
            Spacer()
            Button(action: onRestore) {
                Text("Restore purchases").font(.equal(size: 13, weight: .medium)).foregroundStyle(EqualColor.grey01)
                    .padding(.horizontal, EqualSpacing.s12).frame(width: 139, height: 35)
                    .background(Capsule().fill(Color.white.opacity(0.6)))
                    .overlay(Capsule().strokeBorder(Color.white.opacity(0.8), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, EqualSpacing.s16)
        .frame(height: 38)
    }
}

/// The eight soft rays behind the paywall crown: 54×137 wedges (wide end outward, 36–173pt from
/// the centre) fading from white 50% at the centre to clear, at 60% group opacity.
struct EqualPaywallRays: View {
    static let size: CGFloat = 346
    static let angles: [Double] = [0, 49.8, 90, 130.2, 180, -130.2, -90, -49.8]

    var body: some View {
        ZStack {
            ForEach(Self.angles, id: \.self) { a in
                RayWedge()
                    .fill(LinearGradient(colors: [.white.opacity(0), .white.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 53.8, height: 136.6)
                    .offset(y: -(36 + 136.6 / 2))
                    .rotationEffect(.degrees(a))
            }
        }
        .frame(width: Self.size, height: Self.size)
        .opacity(0.6)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private struct RayWedge: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let s = rect.width / 53.8
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX + 39.32 * s, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX + 17.15 * s, y: rect.maxY))
            p.closeSubpath()
            return p
        }
    }
}

struct EqualPaywallHero_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            EqualPaywallHero()
            EqualPaywallHero(shape: .roundedBottom(48))
            EqualPaywallHero(title: "Now go unlimited", preTitle: "Equal made 30 calls for you", shape: .roundedBottom(48), tint: .sunrise)
        }
        .frame(width: 393)
        .background(EqualColor.grey14)
    }
}
