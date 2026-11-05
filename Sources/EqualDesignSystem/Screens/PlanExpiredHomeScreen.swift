import SwiftUI

/// Subscription Expired page (21402:67090), reached from the expired home's "Renew Gold" card:
/// mint `EqualExpiredHeader`, the expired membership card, "WHAT YOU'RE MISSING" feature pills,
/// plan details, FAQ and the green "Renew - ₹249/month" sticky bar.
public struct PlanExpiredHomeScreen: View {
    let expiredOn: String
    let onRenew: () -> Void
    let onClose: () -> Void

    public init(expiredOn: String = "16th May, 2026", onRenew: @escaping () -> Void = {}, onClose: @escaping () -> Void = {}) {
        self.expiredOn = expiredOn
        self.onRenew = onRenew
        self.onClose = onClose
    }

    public var body: some View {
        ScrollView { page }
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                EqualStickyCTABar(.renew, action: onRenew).ignoresSafeArea(edges: .bottom)
            }
            .background {
                ZStack(alignment: .topLeading) {
                    Self.page
                    // Lime glow 272 at 18%, blur 300, low on the right.
                    Circle().fill(EqualColor.brandLime.opacity(0.18)).frame(width: 272, height: 272).blur(radius: 150)
                        .offset(x: 226, y: 610)
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea(edges: .top)
    }

    var page: some View {
        VStack(spacing: 0) {
            EqualExpiredHeader(onClose: onClose)
            EqualMembershipCard(status: .expired, detail: "Expired on \(expiredOn)", price: "₹ 249/month")
                .padding(.horizontal, EqualSpacing.s24)
            VStack(spacing: 36) {
                VStack(spacing: EqualSpacing.s24) {
                    EqualSectionLabel("What you’re missing", style: .gold).padding(.horizontal, 8)
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            EqualFeaturePill.contacts
                            EqualFeaturePill.screening
                            EqualFeaturePill.languages
                            EqualFeaturePill.voices
                        }
                        .padding(.horizontal, EqualSpacing.s24)
                        .padding(.vertical, 2)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, -EqualSpacing.s24)
                }
                EqualPlanDetailsCard(dateLine: "Expired on \(expiredOn)")
                VStack(spacing: EqualSpacing.s24) {
                    faqHeader
                    EqualFAQList()
                }
            }
            .padding(.horizontal, EqualSpacing.s24)
            .padding(.top, 36)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity)
    }

    /// Expired-page FAQ header: SemiBold 15 sentence case at 70%, between short gold rules.
    private var faqHeader: some View {
        let rule = Color(equalHex: 0xA37135, alpha: 0.5)
        return HStack(spacing: 6) {
            LinearGradient(colors: [rule.opacity(0), rule], startPoint: .leading, endPoint: .trailing).frame(height: 1)
            Text("Frequently Asked Questions").equalTextStyle(.subheadEm).foregroundStyle(EqualColor.textPrimary).fixedSize()
            LinearGradient(colors: [rule, rule.opacity(0)], startPoint: .leading, endPoint: .trailing).frame(height: 1)
        }
        .opacity(0.7)
        .padding(.horizontal, 9)
    }

    static let page = Color.equalDynamic(light: 0xFFFFFF, dark: 0x000000)
}

struct PlanExpiredHomeScreen_Previews: PreviewProvider {
    static var previews: some View { PlanExpiredHomeScreen() }
}
