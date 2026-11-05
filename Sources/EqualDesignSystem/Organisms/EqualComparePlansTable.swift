import SwiftUI

/// Gold vs Gold Plus table. The selected plan's column is washed gold with a #FCEFC2 header, and
/// "AI calls a month" is highlighted. Columns 139 / 103 / 103, header 42, rows 44 (64 for two lines).
///
/// - `.standard`: green checks on #E6F6EA, wash 16%, #F3F0E6 dividers.
/// - `.dark`: Gold Plus checks in dark gold (#5A4918 with a #FFF0C3 tick), wash 24%, black 8%
///   dividers; "Unlimited" turns dark gold while Gold Plus is selected.
public struct EqualComparePlansTable: View {
    public typealias Plan = EqualStickyPlanSheet.Plan
    public enum Style: Sendable { case standard, dark }

    let features: [String]
    let goldCalls: String
    let selected: Plan
    let style: Style

    public init(features: [String] = ["Call screening", "Handles calls from contacts", "Speaks your language", "Instructions", "Saved addresses", "Post-call actions"],
                goldCalls: String = "30", selected: Plan = .goldPlus, style: Style = .standard) {
        self.features = features
        self.goldCalls = goldCalls
        self.selected = selected
        self.style = style
    }

    private var isDark: Bool { style == .dark }
    private var wash: Color { EqualColor.goldLabel.opacity(isDark ? 0.24 : 0.16) }
    private var divider: Color { isDark ? Color.black.opacity(0.08) : EqualColor.compareLine }
    private var labelColor: Color { isDark ? EqualColor.grey01 : Color(equalHex: 0x282828) }

    public var body: some View {
        VStack(spacing: 0) {
            row(highlight: false, divider: false, height: 42) {
                Color.clear
            } gold: {
                header("Gold", plan: .gold)
            } plus: {
                header("Gold Plus", plan: .goldPlus)
            }
            row(highlight: true) {
                label("AI calls a month")
            } gold: {
                Text(goldCalls).font(.equal(size: 15, weight: .semibold)).foregroundStyle(EqualColor.grey01)
            } plus: {
                Text("Unlimited").font(.equal(size: 15, weight: .semibold))
                    .foregroundStyle(isDark && selected == .goldPlus ? Color(equalHex: 0x5A4A1A) : EqualColor.successText)
            }
            ForEach(features, id: \.self) { f in
                row(highlight: false) { label(f) } gold: { check(.gold) } plus: { check(.goldPlus) }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).strokeBorder(EqualColor.compareBorder, lineWidth: 1))
        .environment(\.colorScheme, .light)
    }

    private func header(_ s: String, plan: Plan) -> some View {
        Text(s).font(.equal(size: 13, weight: .semibold))
            .foregroundStyle(selected == plan ? EqualColor.grey01 : EqualColor.grey05)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(selected == plan ? EqualColor.goldHeader : .clear)
    }

    private func label(_ s: String) -> some View {
        Text(s).font(.equal(size: 15)).tracking(-0.39).foregroundStyle(labelColor)
    }

    @ViewBuilder private func check(_ column: Plan) -> some View {
        if isDark && column == .goldPlus {
            EqualTableCheck(circle: Color(equalHex: 0x5A4918), tick: Color(equalHex: 0xFFF0C3))
        } else if isDark && selected == .gold {
            EqualTableCheck(circle: EqualColor.green.opacity(0.1), tick: EqualColor.green)
        } else {
            EqualTableCheck(circle: Color(equalHex: 0xE6F6EA), tick: EqualColor.successText)
        }
    }

    private func row<L: View, G: View, P: View>(highlight: Bool, divider showsDivider: Bool = true, height: CGFloat? = nil,
                                                @ViewBuilder label: () -> L, @ViewBuilder gold: () -> G, @ViewBuilder plus: () -> P) -> some View {
        HStack(spacing: 0) {
            label().frame(maxWidth: .infinity, alignment: .leading).padding(EqualSpacing.s12)
            gold().frame(width: 103).frame(maxHeight: .infinity).background(selected == .gold ? wash : .clear)
            plus().frame(width: 103).frame(maxHeight: .infinity).background(selected == .goldPlus ? wash : .clear)
        }
        .frame(height: height)
        .fixedSize(horizontal: false, vertical: true)
        .background(highlight ? EqualColor.goldRow : .clear)
        .overlay(alignment: .top) { if showsDivider { Rectangle().fill(divider).frame(height: 1) } }
    }
}

/// 20pt "included" mark: a filled circle with an 8×5.4 tick stroked 1.8pt.
struct EqualTableCheck: View {
    let circle: Color
    let tick: Color
    var body: some View {
        ZStack {
            Circle().fill(circle)
            Path { p in
                p.move(to: CGPoint(x: 6, y: 10.2))
                p.addLine(to: CGPoint(x: 8.9, y: 13))
                p.addLine(to: CGPoint(x: 14, y: 7.6))
            }
            .stroke(tick, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
        }
        .frame(width: 20, height: 20)
        .accessibilityLabel("Included")
    }
}

struct EqualComparePlansTable_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualComparePlansTable()
            EqualComparePlansTable(selected: .gold, style: .dark)
        }
        .padding(24)
        .frame(width: 393)
        .background(EqualColor.grey14)
    }
}
