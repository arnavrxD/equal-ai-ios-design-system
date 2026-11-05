import SwiftUI

/// The generic "Processing payment" sheet over a blurred, dimmed screen (the gateway wait state
/// before the purchase is confirmed). By default it covers the "Processing payment" wait screen.
public struct ProcessingSheetScreen<Background: View>: View {
    let background: Background
    let title: String
    let message: String

    public init(title: String = "Processing payment", message: String = "Please wait.\nDon’t close this page", @ViewBuilder background: () -> Background) {
        self.title = title
        self.message = message
        self.background = background()
    }

    public var body: some View {
        background.equalProcessingSheet(isPresented: true, title: title, message: message)
    }
}

public extension ProcessingSheetScreen where Background == UpiWaitScreen {
    /// The sheet over the "Processing payment" wait screen.
    init(title: String = "Processing payment", message: String = "Please wait.\nDon’t close this page") {
        self.init(title: title, message: message) { UpiWaitScreen(autoAdvance: false) }
    }
}

struct ProcessingSheetScreen_Previews: PreviewProvider {
    static var previews: some View { ProcessingSheetScreen() }
}
