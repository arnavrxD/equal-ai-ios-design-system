import SwiftUI

// TEMPORARY: windows into scrolling screens for ImageRenderer verification. Delete before commit.
extension EqualCatalog {
    static var paywallTmpItems: [EqualCatalogItem] {
        var items: [EqualCatalogItem] = []
        for (i, v) in PaywallConfig.variants.enumerated() {
            for off in [0, 800] {
                items.append(EqualCatalogItem("zzpw\(i)-\(off)", .screens, "") {
                    PaywallScreen(config: v.config).content.offset(y: -CGFloat(off)).frame(width: 393, height: 852, alignment: .top).clipped()
                        .background(EqualColor.grey14)
                })
            }
            items.append(EqualCatalogItem("zzpw\(i)-sheet", .screens, "") {
                VStack { Spacer(); PaywallScreen(config: v.config).sheet }.background(EqualColor.grey14)
            })
        }
        for flow in EqualPurchaseFlow.allCases.filter(\.isLimit) {
            items.append(EqualCatalogItem("zzlim-\(flow.rawValue)", .screens, "") {
                ZStack(alignment: .bottom) {
                    LimitPaywallScreen(flow: flow).content.frame(width: 393, height: 852, alignment: .top).clipped()
                    LimitPaywallScreen(flow: flow).sheet
                }
                .background(EqualColor.grey14)
            })
            items.append(EqualCatalogItem("zzapp-\(flow.rawValue)", .screens, "") {
                ZStack(alignment: .bottom) {
                    LimitPaywallScreen(flow: flow).content.frame(width: 393, height: 852, alignment: .top).clipped()
                    LimitPaywallScreen(flow: flow).sheet
                    Color.black.opacity(0.4)
                    EqualAppStoreSheet(flow: flow, plan: flow.defaultPlan).padding(8)
                }
                .overlay(alignment: .topTrailing) { EqualSideButtonCue() }
                .background(EqualColor.grey14)
            })
        }
        return items
    }
}
