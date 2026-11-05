import SwiftUI

/// Payment-confirmation wait screen: crown ring loader, title and subtitle, then how to confirm the
/// payment (Apple Pay hint and/or the four UPI AutoPay steps with the coded phone illustration).
///
/// Laid out on the 393×852 Figma frame from the top edge (loader at y 62, title block at y 231), so
/// give it the full screen and let it ignore the safe area; the phone is cropped by the bottom edge.
/// Layouts:
/// - `.processing` (default): "Processing payment", the loading-state education version: UPI label
///   between 69pt rules, one 18/22 step, floating phone. Has a dark variant (follows the colour scheme).
/// - `.floating` (family B): "Activating Equal Gold", HOW TO CONFIRM, raised Apple Pay card,
///   "Using UPI? Follow these steps:", one 16/21 step, floating phone.
/// - `.translucent` (B′): as B with the 20% white Apple Pay card.
/// - `.backdrop` (C): as B with the phone in the 232pt dark gold panel.
/// - `.list` (A): plain Apple Pay card, then the small phone beside the 4-row step list.
/// - `.upiOnly` (E) / `.upiOnlyBackdrop` (D): no Apple Pay; UPI label between rules, one step and
///   the floating phone or the phone in the 362pt gold panel.
public struct EqualPaymentProcessing: View {
    /// The four UPI AutoPay instructions.
    public static let steps = [
        "Open your UPI app, via notifications or directly",
        "Review and approve the autopay request",
        "Enter your UPI pin to confirm purchase",
        "Come back to Equal AI app to continue"
    ]

    /// Screen family from the Figma explorations.
    public enum Layout: String, CaseIterable, Sendable {
        case processing, floating, translucent, backdrop, list, upiOnly, upiOnlyBackdrop

        /// Default title for the layout.
        public var defaultTitle: String { self == .processing ? "Processing payment" : "Activating Equal Gold" }
        var hasApplePay: Bool { ![.processing, .upiOnly, .upiOnlyBackdrop].contains(self) }
    }

    let step: Int
    let layout: Layout
    let title: String
    let subtitle: String
    let appearance: EqualUpiPhoneIllustration.Appearance?
    @Environment(\.colorScheme) private var colorScheme

    /// - Parameters:
    ///   - step: current UPI step, 1 to 4.
    ///   - layout: screen family (see the type documentation).
    ///   - title: defaults to "Processing payment" for `.processing`, else "Activating Equal Gold".
    ///   - subtitle: line under the title.
    ///   - phoneAppearance: phone styling; by default `.wireframe` in light and `.upiBrand` in dark,
    ///     as in Figma.
    public init(step: Int = 1, layout: Layout = .processing, title: String? = nil,
                subtitle: String = "Waiting for your confirmation...",
                phoneAppearance: EqualUpiPhoneIllustration.Appearance? = nil) {
        self.step = min(max(step, 1), 4)
        self.layout = layout
        self.title = title ?? layout.defaultTitle
        self.subtitle = subtitle
        self.appearance = phoneAppearance
    }

    public var body: some View {
        ZStack(alignment: .top) {
            EqualCrownLoader().padding(.top, 62)
            header.padding(.top, 231)
            switch layout {
            case .processing, .upiOnly:
                upiLabel(rules: true).padding(.top, 314)
                stepView(size: layout == .processing ? .large : .regular).padding(.top, 355)
                phone(.large).padding(.top, 468)
            case .upiOnlyBackdrop:
                upiLabel(rules: true).padding(.top, 314)
                stepView(size: .regular).padding(.top, 359)
                phone(.tall, container: .backdrop(height: 362)).padding(.top, 461)
            case .floating, .translucent, .backdrop:
                EqualSectionLabel("How to confirm", style: .howToConfirm).frame(height: 18).padding(.top, 301)
                EqualApplePayHintCard(style: layout == .translucent ? .translucent : .raised).frame(width: 332).padding(.top, 337)
                upiLabel(rules: false).padding(.top, 435)
                stepView(size: .regular).padding(.top, 473)
                if layout == .backdrop {
                    phone(.backdrop, container: .backdrop(height: 232)).padding(.top, 575)
                } else {
                    phone(.large).padding(.top, 576)
                }
            case .list:
                EqualSectionLabel("How to confirm", style: .howToConfirm).frame(height: 18).padding(.top, 313)
                EqualApplePayHintCard(style: .plain).frame(width: 332).padding(.top, 349)
                upiLabel(rules: false).padding(.top, 465)
                HStack(alignment: .top, spacing: 25) {
                    phone(.small)
                    EqualUpiStepList(current: step).padding(.top, 24)
                }
                .frame(width: 345, alignment: .leading)
                .padding(.top, 513)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .clipped()
        .equalProcessingBackground()
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    private var header: some View {
        VStack(spacing: 2) {
            Text(title)
                .equalTextStyle(.title2Em)
                .foregroundStyle(Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7))
                .frame(height: 28)
            Text(subtitle)
                .equalTextStyle(.footnote)
                .foregroundStyle(Color.equalDynamic(light: 0x555555, dark: 0xF7F7F7))
                .frame(height: 18)
        }
        .multilineTextAlignment(.center)
        .frame(width: 308)
        .accessibilityElement(children: .combine)
    }

    private func upiLabel(rules: Bool) -> some View {
        EqualSectionLabel("Using UPI? Follow these steps:", style: rules ? .goldSentenceRules : .goldSentence)
            .frame(height: 18)
    }

    private func stepView(size: EqualUpiStep.Size) -> some View {
        EqualUpiStep(step, Self.steps[step - 1], size: size)
            .id(step)
            .transition(.opacity)
    }

    private func phone(_ size: EqualUpiPhoneIllustration.Size, container: EqualUpiPhoneIllustration.Container = .floating) -> some View {
        EqualUpiPhoneIllustration(step: step, size: size, container: container,
                                  appearance: appearance ?? (colorScheme == .dark ? .upiBrand : .wireframe))
    }
}

public extension View {
    /// The payment wait screen background, edge to edge: the cream-to-gold `EqualGradient.processing`
    /// in light; black into dark gold with a soft top glow in dark.
    func equalProcessingBackground() -> some View {
        modifier(EqualProcessingBackground())
    }
}

private struct EqualProcessingBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content.background {
            Group {
                if colorScheme == .dark {
                    ZStack {
                        LinearGradient(stops: [
                            .init(color: Color(equalHex: 0x24211A), location: 0),
                            .init(color: Color(equalHex: 0x13120E), location: 0.07),
                            .init(color: Color(equalHex: 0x020201), location: 0.18),
                            .init(color: Color(equalHex: 0x120C01), location: 0.3),
                            .init(color: Color(equalHex: 0x2C2203), location: 0.4),
                            .init(color: Color(equalHex: 0x413306), location: 0.5),
                            .init(color: Color(equalHex: 0x67520F), location: 0.7),
                            .init(color: Color(equalHex: 0x896F15), location: 0.9),
                            .init(color: Color(equalHex: 0x987B1A), location: 1)
                        ], startPoint: .top, endPoint: .bottom)
                        // Figma: 510pt ellipse #FDEFC6 at 40%, layer blur 166, above the top edge.
                        RadialGradient(colors: [Color(equalHex: 0xFDEFC6, alpha: 0.3), Color(equalHex: 0xFDEFC6, alpha: 0)],
                                       center: .top, startRadius: 0, endRadius: 240)
                    }
                } else {
                    EqualGradient.processing
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct EqualPaymentProcessing_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EqualPaymentProcessing(step: 1)
            EqualPaymentProcessing(step: 2, layout: .floating)
            EqualPaymentProcessing(step: 3, layout: .list)
            EqualPaymentProcessing(step: 1).environment(\.colorScheme, .dark)
        }
        .frame(width: 393, height: 852)
    }
}
