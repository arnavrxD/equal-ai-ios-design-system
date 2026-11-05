import SwiftUI

/// Post-purchase confirmation: the crowned mascot with a green check badge, a white star outline
/// and a warm glow ("subscribed glow"), then "Congratulations!", the title and a subtitle.
///
/// - `.upgraded(plan)`: "You’re on Gold Plus 🎉" / "Unlimited AI calls start now" (pass `subtitle`
///   for the free-trial copy "Your assistant stays on your calls").
/// - `.welcomeBack(plan)`: plan-expired renewals, "Welcome back 🎉" / "Your Gold plan is active again".
/// - `.trialStarted(days:)`: "7 days of / Equal Gold / Starts Today!" with the larger 200pt mascot.
///
/// Mascot 190 with a 40pt #00B140 check, star outline 240 (white 75% / 45%), radial glow 520
/// (#FCDE8C 85% → #FCE8AF 55% → #FAF0D7 25% → clear). The halo draws outside the view's frame.
public struct EqualSuccessState: View {
    public enum Kind: Sendable {
        case upgraded(String, subtitle: String? = nil)
        case welcomeBack(String = "Gold")
        case trialStarted(days: Int)
    }

    let kind: Kind

    public init(_ kind: Kind) { self.kind = kind }

    private var isTrial: Bool { if case .trialStarted = kind { return true } else { return false } }

    public var body: some View {
        VStack(spacing: 0) {
            mascot
            switch kind {
            case .upgraded(let plan, let subtitle):
                copy(title: "You’re on \(plan) 🎉", subtitle: subtitle ?? (plan == "Gold" ? "Your Gold plan is active" : "Unlimited AI calls start now"))
            case .welcomeBack(let plan):
                copy(title: "Welcome back 🎉", subtitle: "Your \(plan) plan is active again")
            case .trialStarted(let days):
                VStack(spacing: 2) {
                    Text("\(days) days of").font(.equal(size: 28, weight: .bold)).foregroundStyle(Color.black)
                        .shadow(color: .black.opacity(0.2), radius: 41, y: 16)
                    Text("Equal Gold").font(.equal(size: 34, weight: .bold)).foregroundStyle(EqualColor.goldInk)
                }
                .padding(.top, 40)
                Text("Starts Today!").font(.equal(size: 20)).foregroundStyle(Color.black.opacity(0.7)).padding(.top, 8)
            }
        }
        .multilineTextAlignment(.center)
        .environment(\.colorScheme, .light)
    }

    private func copy(title: String, subtitle: String) -> some View {
        VStack(spacing: 0) {
            Text("Congratulations!").font(.equal(size: 14)).foregroundStyle(EqualColor.grey05).frame(height: 18)
            Text(title).font(.equal(size: 28, weight: .bold)).foregroundStyle(Color.black).frame(height: 36).padding(.top, 4)
                .accessibilityAddTraits(.isHeader)
            Text(subtitle).font(.equal(size: 16)).foregroundStyle(EqualColor.grey05).padding(.top, 6)
        }
        .padding(.top, 38)
    }

    private var mascot: some View {
        let size: CGFloat = isTrial ? 200 : 190
        return EqualIllustration(.mascotCrown, size: size)
            .overlay(alignment: .topLeading) {
                EqualCheckBadge(size: isTrial ? 52 : 40)
                    .offset(x: isTrial ? 146 : 130, y: isTrial ? 125 : 136)
            }
            .background {
                ZStack {
                    if isTrial {
                        Circle().fill(LinearGradient(stops: [
                            .init(color: .white, location: 0), .init(color: Color(equalHex: 0xFFFEFC), location: 0.4),
                            .init(color: Color(equalHex: 0xFFC927), location: 1)
                        ], startPoint: .top, endPoint: .bottom))
                        .frame(width: 280, height: 280).blur(radius: 77)
                        EqualRoundedStar().stroke(Color.white.opacity(0.4), lineWidth: 3).frame(width: 251, height: 251)
                        EqualRoundedStar().stroke(Color.white.opacity(0.4), lineWidth: 2).frame(width: 168, height: 168)
                    } else {
                        Circle().fill(RadialGradient(stops: [
                            .init(color: Color(equalHex: 0xFCDE8C, alpha: 0.85), location: 0),
                            .init(color: Color(equalHex: 0xFCE8AF, alpha: 0.55), location: 0.3),
                            .init(color: Color(equalHex: 0xFAF0D7, alpha: 0.25), location: 0.55),
                            .init(color: Color(equalHex: 0xFAFAFA, alpha: 0), location: 0.72)
                        ], center: .center, startRadius: 0, endRadius: 260))
                        .frame(width: 520, height: 520)
                        EqualRoundedStar().stroke(Color.white.opacity(0.75), lineWidth: 2.4).frame(width: 228, height: 228)
                        EqualRoundedStar().stroke(Color.white.opacity(0.45), lineWidth: 2).frame(width: 152, height: 152)
                    }
                }
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
    }
}

/// Green verified check on the success mascot: #00B140 circle, white tick.
struct EqualCheckBadge: View {
    let size: CGFloat
    var body: some View {
        ZStack {
            Circle().fill(Color(equalHex: 0x00B13E))
            Path { p in
                p.move(to: CGPoint(x: size * 0.29, y: size * 0.51))
                p.addLine(to: CGPoint(x: size * 0.44, y: size * 0.65))
                p.addLine(to: CGPoint(x: size * 0.71, y: size * 0.37))
            }
            .stroke(Color(equalHex: 0xFAFFF6), style: StrokeStyle(lineWidth: size / 10, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.25), radius: 2.2, y: 2.2)
        .accessibilityLabel("Purchased")
    }
}

/// An 8-point star (inner radius 68%) with rounded corners: the halo outline behind the success mascot.
struct EqualRoundedStar: Shape {
    var points = 8
    var innerRatio: CGFloat = 0.682
    var cornerRatio: CGFloat = 18.0 / 251.0

    func path(in rect: CGRect) -> Path {
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let R = min(rect.width, rect.height) / 2, r = R * innerRatio
        let n = points * 2
        let verts: [CGPoint] = (0..<n).map { i in
            let a = Double(i) / Double(n) * 2 * .pi - .pi / 2
            let rad = i % 2 == 0 ? R : r
            return CGPoint(x: c.x + cos(a) * rad, y: c.y + sin(a) * rad)
        }
        let radius = R * 2 * cornerRatio
        var p = Path()
        let mid = { (a: CGPoint, b: CGPoint) in CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2) }
        p.move(to: mid(verts[n - 1], verts[0]))
        for i in 0..<n {
            p.addArc(tangent1End: verts[i], tangent2End: verts[(i + 1) % n], radius: radius)
        }
        p.closeSubpath()
        return p
    }
}

struct EqualSuccessState_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 120) {
            EqualSuccessState(.upgraded("Gold Plus"))
            EqualSuccessState(.welcomeBack())
        }
        .padding(80)
        .background(EqualColor.grey14)
    }
}
