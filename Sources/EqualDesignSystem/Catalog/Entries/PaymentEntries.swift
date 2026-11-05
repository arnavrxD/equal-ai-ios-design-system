import SwiftUI

// Payment processing: Apple Pay, UPI steps, processing sheet.
extension EqualCatalog {
    static let paymentItems: [EqualCatalogItem] = [
        // Atoms
        EqualCatalogItem("EqualRingLoader", .atoms, "Ring spinner: 29pt sheet spinner and the 160pt payment ring, with a centre slot.") {
            HStack(spacing: 20) {
                EqualRingLoader(.small)
                EqualRingLoader(.large, size: 96)
                EqualRingLoader(.large, size: 96) { EqualIllustration(.crown, size: 57) }
            }
        },

        // Molecules
        EqualCatalogItem("EqualApplePayHintCard", .molecules, "Apple Pay confirm hint: plain, raised, translucent.") {
            VStack(spacing: 12) {
                EqualApplePayHintCard(style: .plain)
                EqualApplePayHintCard()
                EqualApplePayHintCard(style: .translucent)
            }
            .padding(6)
            .equalProcessingBackground()
        },
        EqualCatalogItem("EqualUpiStepList", .molecules, "Four UPI steps; upcoming rows dimmed to 18%.") {
            HStack(alignment: .top, spacing: 12) {
                EqualUpiStepList(current: 1)
                EqualUpiStepList(current: 3)
            }
        },

        // Organisms
        EqualCatalogItem("EqualUpiPhoneIllustration", .organisms, "Coded UPI phone: four steps, wireframe or UPI-app styled, floating or in the gold panel.") {
            VStack(spacing: 16) {
                Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                    GridRow {
                        EqualUpiPhoneIllustration(step: 1, size: .small)
                        EqualUpiPhoneIllustration(step: 2, size: .small)
                    }
                    GridRow {
                        EqualUpiPhoneIllustration(step: 3, size: .small, appearance: .upiBrand)
                        EqualUpiPhoneIllustration(step: 4, size: .small, appearance: .upiBrand)
                    }
                }
                EqualUpiPhoneIllustration(step: 2, size: .backdrop, container: .backdrop(), appearance: .upiBrand, merchant: "Apple Media Services")
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .equalProcessingBackground()
        },
        EqualCatalogItem("EqualProcessingSheet", .organisms, "Grey \"Processing payment\" wait sheet with the small spinner.") {
            EqualProcessingSheet().frame(height: 472).padding(8).background(Color.black.opacity(0.4))
        },

        // Screens
        EqualCatalogItem("Activating Gold", .screens, "Wait screen, family B: Apple Pay hint, one UPI step, floating phone.") { ActivatingGoldScreen(step: 1) },
        EqualCatalogItem("Activating Gold · step 3", .screens, "Family B at step 3 (UPI PIN).") { ActivatingGoldScreen(step: 3) },
        EqualCatalogItem("Activating Gold · list", .screens, "Family A: small phone beside the step list.") { ActivatingGoldScreen(step: 2, layout: .list) },
        EqualCatalogItem("Activating Gold · translucent", .screens, "Family B′: translucent Apple Pay card.") { ActivatingGoldScreen(step: 1, layout: .translucent) },
        EqualCatalogItem("Activating Gold · backdrop", .screens, "Family C: phone in the dark gold panel.") { ActivatingGoldScreen(step: 2, layout: .backdrop) },
        EqualCatalogItem("Activating Gold · UPI only", .screens, "Family E: no Apple Pay, floating phone.") { ActivatingGoldScreen(step: 4, layout: .upiOnly) },
        EqualCatalogItem("Activating Gold · UPI only backdrop", .screens, "Family D: no Apple Pay, tall gold panel.") { ActivatingGoldScreen(step: 1, layout: .upiOnlyBackdrop) },
        EqualCatalogItem("UPI wait", .screens, "\"Processing payment\" with auto-advancing UPI steps.") { UpiWaitScreen() },
        EqualCatalogItem("UPI wait · dark", .screens, "Dark variant with the UPI-app styled phone.") { UpiWaitScreen(autoAdvance: false).environment(\.colorScheme, .dark) },
        EqualCatalogItem("Processing sheet", .screens, "Gateway wait sheet over the blurred wait screen.") { ProcessingSheetScreen() }
    ]
}
