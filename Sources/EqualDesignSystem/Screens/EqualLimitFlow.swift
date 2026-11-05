import SwiftUI

/// The four "can't make a call" flows (Figma sections 26242:66883, 72196, 76964, 80940). This
/// file holds the chat-side copy; paywall, App Store and success copy live with those screens.
public enum EqualLimitFlow: String, CaseIterable, Hashable, Sendable {
    /// 1/4 · A Gold subscriber used all 30 calls this month and is offered Gold Plus.
    case goldLimit
    /// 2/4 · A trial user used all 20 trial calls and is asked to pick a plan.
    case trialLimit
    /// 3/4 · The 7-day trial is over.
    case trialEnded
    /// 4/4 · The Gold subscription has expired.
    case planExpired

    /// Section name, e.g. "Gold limit".
    public var title: String {
        switch self {
        case .goldLimit: "Gold limit"
        case .trialLimit: "Trial limit"
        case .trialEnded: "Trial ended"
        case .planExpired: "Plan expired"
        }
    }

    /// Header badge before the purchase (steps 01–02).
    public var chatBadge: EqualPlanBadge.Kind {
        switch self {
        case .goldLimit: .gold
        case .trialLimit: .trial
        case .trialEnded: .trialEnded
        case .planExpired: .expired
        }
    }

    /// Header badge back in chat after the purchase (step 06).
    public var chatUpgradedBadge: EqualPlanBadge.Kind { self == .planExpired ? .gold : .goldPlus }

    /// First assistant bubble of the limit message (step 02).
    public var chatLimitMessage: String {
        switch self {
        case .goldLimit: "You’ve used all 30 AI calls on your Gold plan this month."
        case .trialLimit: "You’ve used all 20 free calls in your trial."
        case .trialEnded: "Your Equal Gold trial is over."
        case .planExpired: "Your Equal Gold subscription has expired."
        }
    }

    /// Second assistant bubble, which carries the inline action (step 02).
    public var chatLimitFollowUp: String {
        switch self {
        case .goldLimit: "Upgrade to Gold Plus for unlimited calls, or wait till 1 Nov for your Gold calls to reset."
        case .trialLimit: "Pick a plan to keep making calls with Equal."
        case .trialEnded: "Subscribe to a plan to keep making calls with Equal."
        case .planExpired: "Renew your plan to keep making calls with Equal."
        }
    }

    /// The inline action under the second bubble.
    public var chatActionTitle: String {
        switch self {
        case .goldLimit: "Get more calls"
        case .trialLimit: "See plans"
        case .trialEnded: "Subscribe now"
        case .planExpired: "Renew now"
        }
    }

    /// The inline action's SF Symbol: plus for Gold limit, star for the others.
    public var chatActionIcon: EqualIcon { self == .goldLimit ? .plus : .star }

    /// First assistant bubble back in chat (step 06).
    public var chatBackMessage: String {
        self == .planExpired ? "You’re on Gold now, with 30 calls a month." : "You’re on Gold Plus now. Call as much as you need."
    }

    /// Second assistant bubble back in chat (step 06).
    public static let chatBackFollowUp = "Who should I call?"
}

public extension EqualLimitFlow {
    /// The matching purchase flow, for the paywall, App Store confirmation and success screens
    /// that follow this chat (`LimitPaywallScreen(flow: limitFlow.purchaseFlow)`).
    var purchaseFlow: EqualPurchaseFlow {
        switch self {
        case .goldLimit: .goldLimit
        case .trialLimit: .trialLimit
        case .trialEnded: .trialEnded
        case .planExpired: .planExpired
        }
    }
}
