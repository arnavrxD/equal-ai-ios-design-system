import SwiftUI

/// Why the paywall opened. Drives every piece of copy along the purchase path (hero, plan sheet,
/// App Store confirmation, success) so the CTA, billing line and store sheet always name the plan
/// and price that is actually selected.
///
/// - `trialLastDay`: the free-trial → Gold default flow ("Choose your plan", 1 day left).
/// - `goldLimit`: a Gold subscriber used all 30 calls and upgrades to Gold Plus.
/// - `trialLimit`: a trial user used all 20 trial calls.
/// - `trialEnded`: the 7-day trial is over.
/// - `planExpired`: a Gold subscription lapsed; Gold is pre-selected and success says "Welcome back".
public enum EqualPurchaseFlow: String, CaseIterable, Identifiable, Sendable {
    case trialLastDay, goldLimit, trialLimit, trialEnded, planExpired

    public typealias Plan = EqualStickyPlanSheet.Plan

    public var id: String { rawValue }

    /// Readable name for catalogs and analytics.
    public var displayName: String {
        switch self {
        case .trialLastDay: "Free trial · last day"
        case .goldLimit: "Gold limit"
        case .trialLimit: "Trial limit"
        case .trialEnded: "Trial ended"
        case .planExpired: "Plan expired"
        }
    }

    /// The four limit flows use the pre-title hero and the limit plan sheet.
    public var isLimit: Bool { self != .trialLastDay }

    /// The plan selected when the paywall opens.
    public var defaultPlan: Plan { self == .planExpired ? .gold : .goldPlus }

    /// The plan the user is already on (tagged "Your plan" on its card).
    public var currentPlan: Plan? { self == .goldLimit ? .gold : nil }

    // MARK: Hero

    /// Small line above the title on limit paywalls.
    public var heroPreTitle: String? {
        switch self {
        case .trialLastDay: nil
        case .goldLimit: "Equal made 30 calls for you"
        case .trialLimit: "Equal handled all 20 trial calls"
        case .trialEnded: "Trial over. Liked having an assistant?"
        case .planExpired: "Your plan expired. Your setup didn’t."
        }
    }

    public var heroTitle: String {
        switch self {
        case .trialLastDay: "Choose your plan"
        case .goldLimit: "Now go unlimited"
        case .trialLimit: "Don’t stop now"
        case .trialEnded: "Make it yours"
        case .planExpired: "Switch Equal back on"
        }
    }

    public var heroShape: EqualPaywallHero.Shape {
        switch self {
        case .trialLastDay: .circle
        case .goldLimit, .trialLimit: .roundedBottom(48)
        case .trialEnded, .planExpired: .circle
        }
    }

    public var heroTint: EqualPaywallHero.Tint {
        switch self {
        case .trialLastDay: .gold
        case .goldLimit: .sunrise
        case .trialLimit, .trialEnded, .planExpired: .warm
        }
    }

    // MARK: Plan sheet

    /// The grey line above the CTA. Follows the selected plan where it mentions calls.
    public func note(for plan: Plan) -> String {
        let calls = plan == .goldPlus ? "unlimited calls" : "30 calls a month"
        switch self {
        case .trialLastDay: return "Subscribing now ends your free trial immediately."
        case .goldLimit: return "Starts right away with unlimited calls. Apple refunds the unused part of your Gold plan."
        case .trialLimit: return "Subscribing ends your free trial."
        case .trialEnded, .planExpired: return "Starts right away with \(calls). Billed monthly, cancel anytime in Settings."
        }
    }

    /// The CTA label, always naming the selected plan and its (discounted) price.
    public func ctaTitle(for plan: Plan, price: Int) -> String {
        let p = Plan.rupees(price)
        switch self {
        case .trialLastDay, .trialLimit, .trialEnded: return "Get \(plan.title) for \(p)/month"
        case .goldLimit: return plan == .gold ? "You’re on Gold" : "Upgrade to \(plan.title) for \(p)"
        case .planExpired: return plan == .gold ? "Renew Gold for \(p)/month" : "Get \(plan.title) for \(p)/month"
        }
    }

    /// The CTA is disabled when the selection is the plan the user already has.
    public func canPurchase(_ plan: Plan) -> Bool { plan != currentPlan }

    // MARK: App Store

    public func appStoreProduct(for plan: Plan) -> String { "Equal \(plan.title)" }

    public func appStorePrice(_ price: Int) -> String { "₹\(price).00 per month" }

    public func appStoreNote(for plan: Plan, price: Int) -> String {
        let p = Plan.rupees(price)
        switch self {
        case .trialLastDay: return "Your free trial ends today and \(plan.title) starts now. Renews monthly at \(p) until cancelled in Settings."
        case .goldLimit: return "Your Equal Gold subscription ends today and you’ll get a prorated refund for the unused time. Renews monthly until cancelled in Settings."
        case .trialLimit: return "Your free trial ends today. Renews monthly at \(p) until cancelled in Settings."
        case .trialEnded, .planExpired: return "Starts today. Renews monthly at \(p) until cancelled in Settings."
        }
    }

    // MARK: Success

    public func successKind(for plan: Plan) -> EqualSuccessState.Kind {
        switch self {
        case .planExpired where plan == .gold: return .welcomeBack(plan.title)
        case .trialLastDay: return .upgraded(plan.title, subtitle: "Your assistant stays on your calls")
        default: return .upgraded(plan.title)
        }
    }
}
