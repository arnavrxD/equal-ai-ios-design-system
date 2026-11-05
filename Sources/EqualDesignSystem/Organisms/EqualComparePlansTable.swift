import SwiftUI

/// Gold vs Gold Plus table. The Gold Plus column is washed gold; "AI calls a month" is highlighted.
public struct EqualComparePlansTable: View {
    let features: [String]
    let goldCalls: String

    public init(features: [String] = ["Call screening", "Handles calls from contacts", "Speaks your language", "Instructions", "Saved addresses", "Post-call actions"], goldCalls: String = "30") {
        self.features = features
        self.goldCalls = goldCalls
    }

    public var body: some View {
        VStack(spacing: 0) {
            row(highlight: false, divider: false) {
                Color.clear.frame(height: 18)
            } gold: {
                Text("Gold").font(.equal(size: 13, weight: .semibold)).foregroundStyle(EqualColor.grey05)
            } plus: {
                Text("Gold Plus").font(.equal(size: 13, weight: .semibold)).foregroundStyle(EqualColor.grey01)
            }
            .background(alignment: .trailing) { EqualColor.goldHeader.frame(width: 103) }

            row(highlight: true) {
                label("AI calls a month")
            } gold: {
                Text(goldCalls).font(.equal(size: 15, weight: .semibold)).foregroundStyle(Color(equalHex: 0x282828))
            } plus: {
                Text("Unlimited").font(.equal(size: 15, weight: .semibold)).foregroundStyle(EqualColor.successText)
            }
            ForEach(features, id: \.self) { f in
                row(highlight: false) { label(f) } gold: { EqualCompareCheck() } plus: { EqualCompareCheck() }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(EqualColor.compareBorder, lineWidth: 1))
    }

    private func label(_ s: String) -> some View {
        Text(s).font(.equal(size: 15)).tracking(-0.39).foregroundStyle(Color(equalHex: 0x282828))
    }

    private func row<L: View, G: View, P: View>(highlight: Bool, divider: Bool = true, @ViewBuilder label: () -> L, @ViewBuilder gold: () -> G, @ViewBuilder plus: () -> P) -> some View {
        HStack(spacing: 0) {
            label().frame(maxWidth: .infinity, alignment: .leading).padding(EqualSpacing.s12)
            gold().frame(width: 103).padding(.vertical, EqualSpacing.s12)
            plus().frame(width: 103).frame(maxHeight: .infinity).background(EqualColor.goldColumn)
        }
        .fixedSize(horizontal: false, vertical: true)
        .background(highlight ? EqualColor.goldRow : .clear)
        .overlay(alignment: .top) { if divider { Rectangle().fill(EqualColor.compareLine).frame(height: 1) } }
    }
}

struct EqualGoldCards_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                EqualRecapCard()
                EqualMembershipCard(status: .active)
                EqualMembershipCard(status: .trial)
                EqualMembershipCard(status: .expired)
                EqualProfileHeader(onBack: {})
                EqualComparePlansTable()
            }
            .padding(24)
        }
        .equalScreenBackground()
    }
}
