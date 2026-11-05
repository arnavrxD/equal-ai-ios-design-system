import SwiftUI

/// Trial started (21402:47745): the crowned mascot with a green check badge inside the gold star
/// halo, then "7 days of / Equal Gold / Starts Today!" on `#FAFAFA`. Differs from
/// `EqualSuccessState(.trialStarted)` in the halo, badge, 200pt mascot and the 34pt gold line.
public struct TrialStartedScreen: View {
    let days: Int
    let plan: String

    public init(days: Int = 7, plan: String = "Equal Gold") {
        self.days = days
        self.plan = plan
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0).frame(maxHeight: 160)
            stage
            VStack(spacing: 8) {
                VStack(spacing: 2) {
                    Text("\(days) days of")
                        .equalTextStyle(.title1Em).foregroundStyle(Self.ink)
                        .shadow(color: .black.opacity(0.2), radius: 41, x: 0, y: 16)
                    Text(plan).equalTextStyle(.largeTitleEm).foregroundStyle(Self.gold)
                }
                Text("Starts Today!").equalTextStyle(.title3).foregroundStyle(Self.ink.opacity(0.7))
            }
            .multilineTextAlignment(.center)
            .accessibilityElement(children: .combine)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Self.page.ignoresSafeArea())
    }

    /// 393×339 stage from Figma y 160: glow + stars, mascot 200 and the badge at (146, 125) on it.
    private var stage: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            EqualStarHalo().offset(x: 55.5, y: 74.5)
            FramedArt.mascotCrown(200).offset(x: 102, y: 128)
            EqualCheckBadge().offset(x: 238, y: 253)
        }
        .frame(width: 393, height: 339)
        .accessibilityHidden(true)
    }

    static let page = Color.equalDynamic(light: 0xFAFAFA, dark: 0x000000)
    static let ink = Color.equalDynamic(light: 0x000000, dark: 0xF7F7F7)
    static let gold = Color.equalDynamic(light: 0xB17300, dark: 0xFFC14E)
}

struct TrialStartedScreen_Previews: PreviewProvider {
    static var previews: some View { TrialStartedScreen() }
}
