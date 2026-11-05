import SwiftUI

/// Paywall top: gold glow with sun rays, frost close button, "Restore purchases", crown, title.
public struct EqualPaywallHero: View {
    let title: String
    let subtitle: Text
    let onClose: () -> Void
    let onRestore: () -> Void

    public init(title: String = "Choose your plan", subtitle: Text = Text("1 day").bold() + Text(" left in your free trial"), onClose: @escaping () -> Void = {}, onRestore: @escaping () -> Void = {}) {
        self.title = title
        self.subtitle = subtitle
        self.onClose = onClose
        self.onRestore = onRestore
    }

    public var body: some View {
        VStack(spacing: EqualSpacing.s4) {
            HStack {
                EqualIconButton(.close, variant: .frost, label: "Close", action: onClose)
                Spacer()
                Button(action: onRestore) {
                    Text("Restore purchases").font(.equal(size: 13, weight: .medium)).foregroundStyle(EqualColor.grey01)
                        .padding(.horizontal, EqualSpacing.s12).frame(height: 35)
                        .background(Capsule().fill(Color.white.opacity(0.6)))
                        .overlay(Capsule().stroke(Color.white.opacity(0.8)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, EqualSpacing.s16)
            EqualIllustration(.crown, size: 90).padding(.top, 2)
            Text(title).font(.equal(size: 28, weight: .bold)).tracking(-0.73).foregroundStyle(EqualColor.grey01)
            subtitle.font(.equal(size: 15)).foregroundStyle(EqualColor.grey03)
        }
        .padding(.bottom, 60)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                EqualGradient.goldHero
                SunRays().fill(Color.white.opacity(0.45)).mask(RadialGradient(colors: [.white, .clear], center: .center, startRadius: 10, endRadius: 220))
            }
            .ignoresSafeArea()
        }
    }
}

/// Sixteen soft rays behind the crown.
struct SunRays: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY * 0.9)
        let r = max(rect.width, rect.height)
        for i in 0..<16 {
            let a = Double(i) / 16 * 2 * .pi
            let w = 0.09
            p.move(to: c)
            p.addLine(to: CGPoint(x: c.x + r * cos(a - w), y: c.y + r * sin(a - w)))
            p.addLine(to: CGPoint(x: c.x + r * cos(a + w), y: c.y + r * sin(a + w)))
            p.closeSubpath()
        }
        return p
    }
}

struct EqualPaywallParts_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                EqualPaywallHero()
                ScrollView(.horizontal) { HStack(spacing: 24) { EqualFeatureCard(); EqualFeatureCard(title: "Call Screening", message: "Spam, sales or someone who actually needs you. Your assistant finds out first.", isExclusive: false, art: .mascot) }.padding() }
                EqualStickyPlanSheet(selection: .constant(.goldPlus))
            }
        }
        .equalScreenBackground()
    }
}
