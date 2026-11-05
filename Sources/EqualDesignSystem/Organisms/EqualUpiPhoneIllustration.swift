import SwiftUI

/// Coded wireframe phone that shows what the user sees in their UPI app at each AutoPay step:
/// 1 the AutoPay request notification, 2 "Approve AutoPay", 3 "Enter UPI PIN", 4 the check seal.
///
/// The phone is open at the bottom (top corners 33.18, stroke and fill fade out downwards), so place
/// it where the screen edge or a container crops it. Changing `step` fades the new screen in while
/// it rises 41pt (the Figma smart-animate stack); under Reduce Motion it only cross-fades.
/// Drawn at 215.68×365 and scaled to `size`. Follows the colour scheme (dark: black phone, white
/// outline, `#222` card). `.upiBrand` swaps the grey placeholders for UPI-app styling: "AS"
/// avatars on `#61799B` and purple `#680EC6` "View details" / "Set AutoPay" buttons.
public struct EqualUpiPhoneIllustration: View {
    /// Phone width presets from the Figma layouts (the height is always width × 365 / 215.68).
    public struct Size: Hashable, Sendable {
        public let width: CGFloat
        public init(width: CGFloat) { self.width = width }
        /// 215.68 wide: floating under the single step.
        public static let large = Size(width: 215.68)
        /// 214 wide: inside the tall (362pt) gold backdrop.
        public static let tall = Size(width: 214)
        /// 156 wide: beside the step list.
        public static let small = Size(width: 156)
        /// 152 wide: inside the 232pt gold backdrop.
        public static let backdrop = Size(width: 152)
        /// 143 wide: the compact floating variant.
        public static let compact = Size(width: 143)
    }

    /// What the phone sits in.
    public struct Container: Hashable, Sendable {
        let backdropHeight: CGFloat?
        let top: CGFloat
        let width: CGFloat
        /// No container: the phone floats on the screen background.
        public static let floating = Container(backdropHeight: nil, top: 0, width: 0)
        /// A dark gold panel (`#674F16` → `#251A00`, radius 16) that clips the phone. The phone is
        /// centred `top` points below the panel's top edge (19 for the 232pt panel, 41 for 362pt).
        public static func backdrop(height: CGFloat = 232, top: CGFloat? = nil, width: CGFloat = 345) -> Container {
            Container(backdropHeight: height, top: top ?? (height > 300 ? 41 : 19), width: width)
        }
    }

    /// Visual style of the phone's screen content.
    public enum Appearance: Sendable {
        /// Grey placeholder avatars and buttons.
        case wireframe
        /// UPI-app look: "AS" avatar on blue-grey, purple buttons.
        case upiBrand
    }

    let step: Int
    let size: Size
    let container: Container
    let appearance: Appearance
    let merchant: String
    let initials: String
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// - Parameters:
    ///   - step: 1…4.
    ///   - size: phone width preset.
    ///   - container: `.floating` or `.backdrop(height:)`.
    ///   - appearance: `.wireframe` or `.upiBrand`.
    ///   - merchant: the payee shown on the request ("Apple", or "Apple Media Services").
    ///   - initials: the payee avatar initials in `.upiBrand` ("AS", Apple Services).
    public init(step: Int, size: Size = .large, container: Container = .floating, appearance: Appearance = .wireframe, merchant: String = "Apple", initials: String = "AS") {
        self.step = min(max(step, 1), 4)
        self.size = size
        self.container = container
        self.appearance = appearance
        self.merchant = merchant
        self.initials = initials
    }

    public var body: some View {
        if let h = container.backdropHeight {
            phone
                .padding(.top, container.top)
                .frame(width: container.width, height: h, alignment: .top)
                .background(LinearGradient(colors: [Color(equalHex: 0x674F16), Color(equalHex: 0x251A00)], startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
                .accessibilityHidden(true)
        } else {
            phone.accessibilityHidden(true)
        }
    }

    // MARK: Phone

    static let baseWidth: CGFloat = 215.68
    static let baseHeight: CGFloat = 365

    private var phone: some View {
        let s = size.width / Self.baseWidth
        return canvas
            .scaleEffect(s, anchor: .topLeading)
            .frame(width: size.width, height: Self.baseHeight * s, alignment: .topLeading)
    }

    private var canvas: some View {
        let shape = UnevenRoundedRectangle(topLeadingRadius: 33.18, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 33.18, style: .circular)
        let fillEnd: Double = container.backdropHeight == nil ? 0 : 0.4
        let body = Color.equalDynamic(light: 0xFFFFFF, dark: 0x000000)
        let outline = Color.equalDynamic(light: 0x000000, dark: 0xFFFFFF)
        return ZStack(alignment: .topLeading) {
            LinearGradient(colors: [body, body.opacity(fillEnd)], startPoint: .top, endPoint: .bottom)
            ForEach(1...4, id: \.self) { n in
                screen(n)
                    .opacity(n == step ? 1 : 0)
                    .offset(y: n == step || reduceMotion ? 0 : 41.48)
            }
            Capsule().fill(outline).frame(width: 55.3, height: 13.83).offset(x: 80.19, y: 12.44)
        }
        .frame(width: Self.baseWidth, height: Self.baseHeight, alignment: .topLeading)
        .clipShape(shape)
        .overlay(shape.stroke(LinearGradient(colors: [outline, outline.opacity(0)], startPoint: .top, endPoint: .bottom), lineWidth: 5.53))
        .animation(reduceMotion ? .easeInOut(duration: 0.25) : .easeOut(duration: 0.45), value: step)
    }

    // MARK: Screens

    private var ink: Color { .equalDynamic(light: 0x000000, dark: 0xFFFFFF) }
    private var skeleton: Color { .equalDynamic(light: 0x000000, lightAlpha: 0.08, dark: 0xFFFFFF, darkAlpha: 0.12) }
    private static let purple = Color(equalHex: 0x680EC6)
    private static let avatarBlue = Color(equalHex: 0x61799B)

    @ViewBuilder private func screen(_ n: Int) -> some View {
        switch n {
        case 1: requestScreen
        case 2: approveScreen
        case 3: pinScreen
        default: doneScreen
        }
    }

    /// Step 1: home-screen placeholders with the AutoPay request notification.
    private var requestScreen: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8.3).fill(skeleton).frame(width: 33.18, height: 33.18).offset(x: 23.5, y: 44.24)
            RoundedRectangle(cornerRadius: 8.3).fill(skeleton).frame(width: 113.37, height: 13.83).offset(x: 70.51, y: 55.3)
            HStack(spacing: 9.68) {
                ForEach(0..<4, id: \.self) { _ in RoundedRectangle(cornerRadius: 9.68).fill(skeleton).frame(width: 35.26, height: 35.26) }
            }
            .offset(x: 20.74, y: 103.69)
            requestCard.offset(x: 20.74, y: 165.91)
            RoundedRectangle(cornerRadius: 9.68)
                .fill(LinearGradient(colors: [skeleton, skeleton.opacity(0)], startPoint: .top, endPoint: .bottom))
                .frame(width: 170.06, height: 56.69)
                .offset(x: 20.74, y: 300.02)
        }
    }

    private var requestCard: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 8.3) {
                Text("AUTOPAY REQUEST")
                    .font(.equal(size: 9.68, weight: .semibold)).tracking(-0.25)
                    .foregroundStyle(Color.equalDynamic(light: 0x674F16, dark: 0xE0C171))
                HStack(spacing: 6.91) {
                    avatar(24.89, initialsSize: 10)
                    VStack(alignment: .leading, spacing: 1.38) {
                        Text(merchant).font(.equal(size: 11.06, weight: .medium)).tracking(-0.29).foregroundStyle(ink)
                        HStack(spacing: 2.77) {
                            Text("Equal Gold Plan")
                            Circle().fill(Color(equalHex: 0x8E8E8E)).frame(width: 2.77, height: 2.77)
                            Text("Monthly")
                        }
                        .font(.equal(size: 8.3)).tracking(-0.22).foregroundStyle(ink.opacity(0.7))
                    }
                }
            }
            .lineLimit(1)
            .offset(x: 13.83, y: 11.06)
            button(width: 139.64, height: 22.12, radius: appearance == .upiBrand ? 5 : 11.06, wireframeOpacity: 0.1, title: "View details", textSize: 8)
                .offset(x: 16.59, y: 73.28)
        }
        .frame(width: 170.06, height: 106.46, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 11.06).fill(EqualColor.bgSurface).shadow(color: .black.opacity(0.25), radius: 1.38))
    }

    /// Step 2: the "Approve AutoPay" sheet.
    private var approveScreen: some View {
        ZStack(alignment: .topLeading) {
            screenTitle("Approve AutoPay")
            VStack(spacing: 9.68) {
                avatar(58.07, initialsSize: 24)
                VStack(spacing: 2.77) {
                    Text(merchant).font(.equal(size: 13.83, weight: .semibold)).tracking(-0.36).foregroundStyle(ink)
                    Text("Equal Gold Subscription").font(.equal(size: 11.06)).tracking(-0.29).foregroundStyle(ink.opacity(0.7))
                }
                .lineLimit(1)
                .fixedSize()
            }
            .frame(width: Self.baseWidth)
            .offset(y: 85.72)
            Rectangle().fill(ink.opacity(0.08)).frame(width: 172.13, height: 0.69).offset(x: 22.12, y: 208.42)
            detailRow("Frequency", "Monthly").offset(y: 228.13)
            detailRow("Valid till", "Until cancelled").offset(y: 247.48)
            button(width: 171.44, height: 34.56, radius: appearance == .upiBrand ? 8 : 17.28, wireframeOpacity: 0.12, title: "Set AutoPay", textSize: 12)
                .offset(x: 22.12, y: 291.72)
        }
    }

    /// Step 3: PIN entry, four of six digits entered.
    private var pinScreen: some View {
        ZStack(alignment: .topLeading) {
            screenTitle("Enter UPI PIN")
            HStack(spacing: 6.91) {
                ForEach(0..<6, id: \.self) { i in
                    Circle().fill(ink.opacity(i < 4 ? 0.52 : 0.12)).frame(width: 16.59, height: 16.59)
                }
            }
            .offset(x: 41.48, y: 87.1)
            ForEach(Array(Self.keys.enumerated()), id: \.offset) { _, key in
                RoundedRectangle(cornerRadius: 6.91).fill(ink.opacity(0.08)).frame(width: 49.77, height: 33.18)
                    .offset(x: key.x, y: key.y)
            }
        }
    }

    private static let keys: [CGPoint] = {
        var k: [CGPoint] = []
        for y in [196.33, 241.95, 287.58] { for x in [19.36, 82.95, 146.55] { k.append(CGPoint(x: x, y: y)) } }
        k.append(CGPoint(x: 82.95, y: 333.2))
        return k
    }()

    /// Step 4: the check seal (payment confirmed, back to Equal).
    private var doneScreen: some View {
        EqualIconView(.seal, size: 68, weight: .regular)
            .foregroundStyle(ink.opacity(0.6))
            .frame(width: Self.baseWidth)
            .frame(height: 81)
            .offset(y: 117.52)
    }

    // MARK: Parts

    private func screenTitle(_ text: String) -> some View {
        Text(text)
            .font(.equal(size: 16.59, weight: .semibold)).tracking(-0.43)
            .foregroundStyle(ink)
            .frame(width: Self.baseWidth, height: 22)
            .offset(y: 45.63)
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.equal(size: 11.06))
            Spacer(minLength: 0)
            Text(value).font(.equal(size: 11.06, weight: .semibold))
        }
        .tracking(-0.29)
        .foregroundStyle(ink.opacity(0.7))
        .frame(height: 14)
        .padding(.horizontal, 22.12)
        .frame(width: Self.baseWidth)
    }

    @ViewBuilder private func avatar(_ d: CGFloat, initialsSize: CGFloat) -> some View {
        if appearance == .upiBrand {
            Text(initials).font(.equal(size: initialsSize, weight: .semibold)).foregroundStyle(.white)
                .frame(width: d, height: d)
                .background(Circle().fill(Self.avatarBlue))
        } else {
            Circle().fill(ink.opacity(0.6)).frame(width: d, height: d)
        }
    }

    @ViewBuilder private func button(width: CGFloat, height: CGFloat, radius: CGFloat, wireframeOpacity: Double, title: String, textSize: CGFloat) -> some View {
        if appearance == .upiBrand {
            Text(title).font(.equal(size: textSize, weight: .semibold)).foregroundStyle(.white)
                .frame(width: width, height: height)
                .background(Self.purple, in: RoundedRectangle(cornerRadius: radius))
        } else {
            Capsule().fill(ink.opacity(wireframeOpacity)).frame(width: width, height: height)
        }
    }
}

struct EqualUpiPhoneIllustration_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(1...4, id: \.self) { EqualUpiPhoneIllustration(step: $0, size: .small) }
            }
            HStack(alignment: .top, spacing: 16) {
                ForEach(1...4, id: \.self) { EqualUpiPhoneIllustration(step: $0, size: .small, appearance: .upiBrand, merchant: "Apple Media Services") }
            }
            EqualUpiPhoneIllustration(step: 1, size: .backdrop, container: .backdrop())
        }
        .padding(24)
        .background(EqualGradient.processing)
    }
}
