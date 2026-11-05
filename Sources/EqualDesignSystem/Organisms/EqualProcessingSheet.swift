import SwiftUI

/// Generic payment wait sheet: "Processing payment" with a small ring spinner and "Please wait.
/// Don't close this page", on a grey `#E5E5E5` sheet with radii 30/30/10/10.
///
/// The sheet alone is 377×472 (8pt in from the screen edges). Present it over a screen with
/// `.equalProcessingSheet(isPresented:)`, which blurs the screen and adds the black 40% scrim.
public struct EqualProcessingSheet: View {
    let title: String
    let message: String

    public init(title: String = "Processing payment", message: String = "Please wait.\nDon’t close this page") {
        self.title = title
        self.message = message
    }

    public var body: some View {
        let ink = Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7)
        VStack(spacing: 15) {
            HStack(spacing: 7) {
                Text(title).font(.equal(size: 18, weight: .semibold)).foregroundStyle(ink)
                EqualRingLoader(.small)
            }
            Text(message).font(.equal(size: 12)).foregroundStyle(ink).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 472)
        .background(
            Color.equalDynamic(light: 0xE5E5E5, dark: 0x222222),
            in: UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 30, style: .continuous)
        )
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.updatesFrequently)
    }
}

public extension View {
    /// Covers the view with the processing sheet: the view blurs (Figma background blur 12), a black
    /// 40% scrim goes on top and the sheet sits 8pt in from the left, right and bottom edges.
    func equalProcessingSheet(isPresented: Bool, title: String = "Processing payment", message: String = "Please wait.\nDon’t close this page") -> some View {
        self
            .blur(radius: isPresented ? 6 : 0, opaque: true)
            .overlay {
                if isPresented {
                    ZStack(alignment: .bottom) {
                        Color.black.opacity(0.4)
                        EqualProcessingSheet(title: title, message: message)
                            .padding(EqualSpacing.s8)
                            .transition(.move(edge: .bottom))
                    }
                    .ignoresSafeArea()
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
}

struct EqualProcessingSheet_Previews: PreviewProvider {
    static var previews: some View {
        EqualProcessingSheet().padding(8).background(Color.gray)
    }
}
