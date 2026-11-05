import SwiftUI

/// Swatches for every color token.
public struct ColorTokensView: View {
    public init() {}
    private let groups: [(String, [(String, Color)])] = [
        ("Semantic", [("bgPrimary", EqualColor.bgPrimary), ("bgSurface", EqualColor.bgSurface), ("textPrimary", EqualColor.textPrimary), ("textSecondary", EqualColor.textSecondary), ("textPlaceholder", EqualColor.textPlaceholder), ("textAction", EqualColor.textAction), ("buttonPrimary", EqualColor.buttonPrimary), ("buttonSecondary", EqualColor.buttonSecondary), ("buttonDanger", EqualColor.buttonDanger), ("buttonDisabled", EqualColor.buttonDisabled), ("strokeSubtle", EqualColor.strokeSubtle), ("strokeMedium", EqualColor.strokeMedium), ("strokeDark", EqualColor.strokeDark), ("bubbleUserBg", EqualColor.bubbleUserBg), ("bubbleUserTitle", EqualColor.bubbleUserTitle), ("unreadFill", EqualColor.unreadFill), ("unreadStroke", EqualColor.unreadStroke), ("bgOverlay", EqualColor.bgOverlay)]),
        ("Brand", [("brandGreen", EqualColor.brandGreen), ("brandLime", EqualColor.brandLime), ("brandBlack", EqualColor.brandBlack), ("brandWhite", EqualColor.brandWhite)]),
        ("Neutrals", [("grey01", EqualColor.grey01), ("grey02", EqualColor.grey02), ("grey03", EqualColor.grey03), ("grey04", EqualColor.grey04), ("grey05", EqualColor.grey05), ("grey06", EqualColor.grey06), ("grey07", EqualColor.grey07), ("grey08", EqualColor.grey08), ("grey09", EqualColor.grey09), ("grey10", EqualColor.grey10), ("grey11", EqualColor.grey11), ("grey12", EqualColor.grey12), ("grey13", EqualColor.grey13), ("grey14", EqualColor.grey14)]),
        ("Reds", [("red01", EqualColor.red01), ("red04", EqualColor.red04), ("red07", EqualColor.red07), ("red08", EqualColor.red08), ("red10", EqualColor.red10), ("red12", EqualColor.red12), ("red14", EqualColor.red14)]),
        ("Gold", [("goldInk", EqualColor.goldInk), ("goldDeep", EqualColor.goldDeep), ("goldLabel", EqualColor.goldLabel), ("goldBorder", EqualColor.goldBorder), ("goldHeader", EqualColor.goldHeader), ("goldRow", EqualColor.goldRow), ("goldCoupon", EqualColor.goldCoupon), ("goldRecapLabel", EqualColor.goldRecapLabel), ("successText", EqualColor.successText)]),
        ("Avatar tints", [("avatarMint", EqualColor.avatarMint), ("avatarFinance", EqualColor.avatarFinance), ("avatarRide", EqualColor.avatarRide), ("avatarCareer", EqualColor.avatarCareer), ("avatarPeach", EqualColor.avatarPeach), ("avatarOthers", EqualColor.avatarOthers), ("avatarUnknown", EqualColor.avatarUnknown)])
    ]
    public var body: some View {
        List {
            ForEach(groups, id: \.0) { g in
                Section(g.0) {
                    ForEach(g.1, id: \.0) { item in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8).fill(item.1).frame(width: 44, height: 32)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(EqualColor.strokeMedium))
                            Text("EqualColor.\(item.0)").font(.system(.callout, design: .monospaced))
                        }
                    }
                }
            }
        }
        .navigationTitle("Color")
    }
}

/// Every text style rendered in its own style.
public struct TypographyTokensView: View {
    public init() {}
    public var body: some View {
        List(EqualTextStyle.allCases, id: \.self) { style in
            VStack(alignment: .leading, spacing: 4) {
                Text("Amit called to remind you").equalTextStyle(style).lineLimit(1)
                Text(".\(style.rawValue)  \(Int(style.size))/\(Int(style.lineHeight))").font(.system(.caption, design: .monospaced)).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Typography")
    }
}

/// Spacing, radius and shadow scales.
public struct ShapeTokensView: View {
    public init() {}
    public var body: some View {
        List {
            Section("Spacing") {
                ForEach([("s4", EqualSpacing.s4), ("s8", EqualSpacing.s8), ("s12", EqualSpacing.s12), ("s16", EqualSpacing.s16), ("s24", EqualSpacing.s24), ("s32", EqualSpacing.s32), ("s48", EqualSpacing.s48)], id: \.0) { s in
                    HStack { Rectangle().fill(EqualColor.green).frame(width: s.1, height: 16); Text("EqualSpacing.\(s.0) · \(Int(s.1))").font(.system(.callout, design: .monospaced)) }
                }
            }
            Section("Radius") {
                ForEach([("xs", EqualRadius.xs), ("s", EqualRadius.s), ("m", EqualRadius.m), ("l", EqualRadius.l), ("xl", EqualRadius.xl)], id: \.0) { r in
                    HStack { RoundedRectangle(cornerRadius: r.1).stroke(EqualColor.green, lineWidth: 2).frame(width: 64, height: 40); Text("EqualRadius.\(r.0) · \(Int(r.1))").font(.system(.callout, design: .monospaced)) }
                }
            }
            Section("Shadow") {
                ForEach([("card", EqualShadow.card), ("chip", EqualShadow.chip), ("sheet", EqualShadow.sheet), ("recap", EqualShadow.recap), ("push", EqualShadow.push)], id: \.0) { s in
                    HStack { RoundedRectangle(cornerRadius: 12).fill(EqualColor.bgSurface).frame(width: 64, height: 40).equalShadow(s.1).padding(8); Text("EqualShadow.\(s.0)").font(.system(.callout, design: .monospaced)) }
                }
            }
        }
        .navigationTitle("Spacing, radius, shadow")
    }
}

/// SF Symbols mapping and the bundled illustrations.
public struct IconographyView: View {
    public init() {}
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 72))], spacing: 16) {
                ForEach(EqualIcon.allCases, id: \.self) { icon in
                    VStack(spacing: 6) { EqualIconView(icon, size: 22); Text(String(describing: icon)).font(.caption2).lineLimit(1) }
                }
            }
            .padding()
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96))], spacing: 16) {
                ForEach(EqualImage.all, id: \.self) { img in
                    VStack(spacing: 6) { EqualIllustration(img, size: 72); Text(img.name).font(.caption2).lineLimit(1) }
                }
            }
            .padding()
        }
        .navigationTitle("Icons & illustrations")
    }
}
