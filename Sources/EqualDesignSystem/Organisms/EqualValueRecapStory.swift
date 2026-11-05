import SwiftUI

/// Full-screen story shown on the last trial day: time saved as a 76pt gold number, four stat
/// rows and "Don’t make it start over."
///
/// #0B0B0A with a green glow (320×420 #0E7A38 45%, blur 110); 3pt story progress (#F4C21B on
/// white 18%); Skip pill (white 10% + 15% stroke, Bold 13); kicker Bold 12 tracking 12% #E9C66B;
/// number SemiBold 76 tracking −4% with a #FFF6D6 → #F4C21B → #C9960C gradient; subtitle white 60%;
/// rows of `EqualStatRow`; closing line Bold 22 with "start over." in #F4C21B. Positions follow the
/// 852pt frame from the top of the screen, so it ignores the top safe area.
public struct EqualValueRecapStory: View {
    public struct Stat: Sendable {
        public let label: String
        public let value: String
        public let icon: EqualIcon
        public init(_ label: String, _ value: String, icon: EqualIcon) { self.label = label; self.value = value; self.icon = icon }
    }

    let name: String
    let saved: String
    let stats: [Stat]
    let progress: Double
    let onSkip: () -> Void

    public init(name: String = "Keshav", saved: String = "2h 22m", stats: [Stat] = [
        Stat("Calls handled", "18", icon: .phoneOutline),
        Stat("Spam and sales stopped", "7", icon: .shield),
        Stat("Messages taken", "5", icon: .message),
        Stat("Actions after calls", "9", icon: .bolt)
    ], progress: Double = 0.45, onSkip: @escaping () -> Void = {}) {
        self.name = name
        self.saved = saved
        self.stats = stats
        self.progress = progress
        self.onSkip = onSkip
    }

    private static let gold = Color(equalHex: 0xF4C21B)

    public var body: some View {
        VStack(spacing: 0) {
            // story progress, 357×3 at y58
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(.white.opacity(0.18))
                    RoundedRectangle(cornerRadius: 2).fill(Self.gold).frame(width: geo.size.width * min(max(progress, 0), 1))
                }
            }
            .frame(height: 3)
            .padding(.horizontal, 18)
            .padding(.top, 58)
            .accessibilityLabel("Story progress")
            .accessibilityValue("\(Int(progress * 100)) percent")

            HStack {
                Spacer()
                Button(action: onSkip) {
                    Text("Skip").font(.equal(size: 13, weight: .bold)).foregroundStyle(.white.opacity(0.85))
                        .padding(.horizontal, 14).frame(height: 33)
                        .background(Capsule().fill(.white.opacity(0.1)))
                        .overlay(Capsule().strokeBorder(.white.opacity(0.15), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 13)

            Text("\(name), your free week with Equal".uppercased())
                .font(.equal(size: 12, weight: .bold)).tracking(1.44).foregroundStyle(EqualColor.goldRecapLabel)
                .frame(height: 16)
                .padding(.top, 107)
            Text(saved).font(.equal(size: 76, weight: .semibold)).tracking(-3.04).monospacedDigit()
                .foregroundStyle(.clear)
                .fixedSize()
                .overlay {
                    LinearGradient(stops: [
                        .init(color: Color(equalHex: 0xFFF6D6), location: 0),
                        .init(color: Self.gold, location: 0.7),
                        .init(color: Color(equalHex: 0xC9960C), location: 1)
                    ], startPoint: .top, endPoint: .bottom)
                    .mask(Text(saved).font(.equal(size: 76, weight: .semibold)).tracking(-3.04).monospacedDigit().fixedSize())
                }
                .frame(height: 98)
                .padding(.top, 8)
                .accessibilityLabel(saved)
            Text("saved on calls you didn’t have to take").font(.equal(size: 15)).foregroundStyle(.white.opacity(0.6))
                .frame(height: 20)
            VStack(spacing: 0) {
                ForEach(Array(stats.enumerated()), id: \.offset) { _, s in EqualStatRow(s.label, value: s.value, icon: s.icon) }
            }
            .overlay(alignment: .top) { Rectangle().fill(.white.opacity(0.1)).frame(height: 1) }
            .padding(.horizontal, 24)
            .padding(.top, 22)
            (Text("Don’t make it ") + Text("start over.").foregroundColor(Self.gold))
                .font(.equal(size: 22, weight: .bold)).foregroundStyle(.white)
                .padding(.top, 26)
            Spacer(minLength: 0)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            ZStack(alignment: .topLeading) {
                Color(equalHex: 0x0B0B0A)
                Ellipse().fill(Color(equalHex: 0x0E7A38, alpha: 0.45)).frame(width: 320, height: 420).blur(radius: 55)
                    .offset(x: 37, y: 170)
            }
            .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
    }
}

struct EqualValueRecapStory_Previews: PreviewProvider {
    static var previews: some View { EqualValueRecapStory().frame(width: 393, height: 852) }
}
