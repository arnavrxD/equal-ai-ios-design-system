import SwiftUI

/// Home banner cards (345 wide, radius 16). One at a time, above the search bar.
public struct EqualPromoCard: View {
    public enum Kind: Sendable {
        /// "Only 1 day of Gold left" on a white-to-red wash with a gold Subscribe pill.
        case trialEnding
        /// Day-count ring + "7 days of Gold, on us".
        case goldDays(Int)
        /// Orange "Enable Permissions" with a 3D gear.
        case permissions
        /// Green "Meet Your Assistant" with the mascot and "Call me".
        case meetAssistant
    }

    let kind: Kind
    let action: () -> Void

    public init(_ kind: Kind, action: @escaping () -> Void = {}) {
        self.kind = kind
        self.action = action
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s12) {
            if case .goldDays(let d) = kind {
                Text("\(d)").font(.equal(size: 26, weight: .medium)).foregroundStyle(EqualColor.goldInk)
                    .frame(width: 48, height: 48).overlay(Circle().stroke(EqualColor.goldInk, lineWidth: 2.5))
            }
            VStack(alignment: .leading, spacing: EqualSpacing.s4) {
                Text(title).font(.equal(size: 18, weight: .semibold)).tracking(-0.47).foregroundStyle(EqualColor.grey01)
                Text(subtitle).font(.equal(size: 12)).foregroundStyle(EqualColor.grey05)
                if let cta { cta.padding(.top, EqualSpacing.s12) }
            }
            Spacer(minLength: 0)
            EqualIllustration(art, size: artSize)
        }
        .padding(.horizontal, EqualSpacing.s18)
        .padding(.vertical, EqualSpacing.s16)
        .frame(minHeight: 118)
        .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(fill))
        .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(border, lineWidth: 1))
    }

    private var title: String {
        switch kind {
        case .trialEnding: "Only 1 day of Gold left"
        case .goldDays(let d): "\(d) days of Gold, on us"
        case .permissions: "Enable Permissions"
        case .meetAssistant: "Meet Your Assistant"
        }
    }
    private var subtitle: String {
        switch kind {
        case .trialEnding: "From tomorrow, assistant stops answering calls."
        case .goldDays: "Everything is unlocked. Nothing to pay yet."
        case .permissions: "Allow notifications and contacts for real-time call recognition"
        case .meetAssistant: "Get to know your assistant better."
        }
    }
    private var cta: EqualButton? {
        switch kind {
        case .trialEnding: EqualButton("Subscribe", variant: .goldPill, size: .small, action: action)
        case .goldDays: nil
        case .permissions: EqualButton("Open settings", variant: .goldPill, size: .small, icon: .gear, action: action)
        case .meetAssistant: EqualButton("Call me", size: .medium, icon: .phone, action: action)
        }
    }
    private var art: EqualImage {
        switch kind {
        case .trialEnding, .goldDays: .crown
        case .permissions: .gear
        case .meetAssistant: .mascot
        }
    }
    private var artSize: CGFloat { if case .goldDays = kind { return 84 } else { return 104 } }
    private var fill: LinearGradient {
        switch kind {
        case .trialEnding: EqualGradient.trialCard
        case .goldDays: LinearGradient(colors: [Color(equalHex: 0xFFFDF6), Color(equalHex: 0xFFF3D1)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .permissions: LinearGradient(colors: [Color(equalHex: 0xFFF7F0), Color(equalHex: 0xFFD6BF)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .meetAssistant: LinearGradient(colors: [Color(equalHex: 0xF1FBF3), Color(equalHex: 0xD8F5DF)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    private var border: Color {
        switch kind {
        case .trialEnding: Color(equalHex: 0xC64040)
        case .goldDays: Color(equalHex: 0xF3E3B1)
        case .permissions: Color(equalHex: 0xF4B08A)
        case .meetAssistant: EqualColor.unreadStroke
        }
    }
}

struct EqualPromoCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            EqualPromoCard(.trialEnding); EqualPromoCard(.goldDays(7)); EqualPromoCard(.permissions); EqualPromoCard(.meetAssistant)
        }
        .padding(24).equalScreenBackground()
    }
}
