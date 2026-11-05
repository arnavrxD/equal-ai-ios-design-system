import SwiftUI

/// Live-call explainer card: caller, a timer pill with a 3-bar signal, "Your assistant is on call."
/// at 68% and quick replies including **Takeover**, over a lime → green audio glow.
public struct EqualLiveCallCard: View {
    let number: String
    let duration: String
    let status: String
    let replies: [String]
    let onReply: (String) -> Void

    public init(number: String = "+91 98765 43210", duration: String = "00:06", status: String = "Your assistant is on call.", replies: [String] = ["Takeover", "I’m Interested", "Please, Call me later"], onReply: @escaping (String) -> Void = { _ in }) {
        self.number = number; self.duration = duration; self.status = status; self.replies = replies; self.onReply = onReply
    }

    private let ink = Color(equalHex: 0x0B1215)

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: EqualSpacing.s12) {
                EqualIllustration(.callerPhone, size: 46)
                VStack(alignment: .leading, spacing: 4) {
                    Text(number).font(.equal(size: 13.3))
                    HStack(spacing: 4) {
                        SignalBars().fill(EqualColor.green).frame(width: 9, height: 10)
                        Text(duration).font(.equal(size: 11.4)).foregroundStyle(ink.opacity(0.7)).monospacedDigit()
                    }
                    .padding(.horizontal, 7).frame(height: 17.2)
                    .background(Capsule().fill(Color.white.opacity(0.88)))
                }
                Spacer()
                EqualLogo(height: 14.4)
            }
            Text(status).font(.equal(size: 15.2)).tracking(-0.3).opacity(0.68)
            HStack(spacing: EqualSpacing.s8) {
                ForEach(replies, id: \.self) { r in
                    Button { onReply(r) } label: {
                        HStack(spacing: 4) {
                            if r == replies.first { EqualIconView(.phone, size: 10).foregroundStyle(Color(equalHex: 0x1C1B1F)) }
                            Text(r).font(.equal(size: 11.6)).lineLimit(1)
                        }
                        .padding(.horizontal, 12).frame(height: 35)
                        .background(Capsule().fill(Color(equalHex: 0xFDFFFD, alpha: 0.75)))
                        .overlay(Capsule().strokeBorder(LinearGradient(colors: [.white, Color(equalHex: 0x75AC00)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.8))
                        .shadow(color: .black.opacity(0.1), radius: 3.6, x: 2.5, y: 3.3)
                    }
                    .buttonStyle(.plain)
                    .fixedSize()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
        }
        .foregroundStyle(ink)
        .padding(14.3)
        .background {
            ZStack(alignment: .bottom) {
                Color.white
                RadialGradient(colors: [.white, Color(equalHex: 0xEAEAEA, alpha: 0.76)], center: UnitPoint(x: 0.3, y: 0.2), startRadius: 0, endRadius: 300)
                AudioWave().fill(LinearGradient(colors: [EqualColor.brandLime, EqualColor.brandGreen], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 70).blur(radius: 9.5).opacity(0.32).offset(y: 20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15.9))
            .shadow(color: .black.opacity(0.25), radius: 2, y: 4)
        }
        .environment(\.colorScheme, .light)
    }
}

/// Three rising bars (live-call signal).
struct SignalBars: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width / 5
        for (i, h) in [0.55, 0.55, 1.0].enumerated() {
            p.addRoundedRect(in: CGRect(x: r.minX + CGFloat(i) * 2 * w, y: r.maxY - r.height * h, width: w, height: r.height * h), cornerSize: CGSize(width: w / 2, height: w / 2))
        }
        return p
    }
}

/// A soft audio-waveform silhouette for the live-call glow.
struct AudioWave: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.maxY))
        let n = 9
        for i in 0...n {
            let x = r.minX + r.width * CGFloat(i) / CGFloat(n)
            let amp = [0.3, 0.7, 0.45, 0.95, 0.6, 0.85, 0.4, 0.75, 0.5, 0.35][i]
            p.addLine(to: CGPoint(x: x, y: r.maxY - r.height * amp))
        }
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

struct EqualStates_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                EqualValueRecapStory().frame(height: 760)
                EqualAppStoreSheet()
                EqualPaymentProcessing(step: 1)
                EqualSuccessState(.upgraded("Gold Plus"))
                EqualSuccessState(.trialStarted(days: 7))
                EqualEmptyState()
                EqualInviteCard()
                EqualLiveCallCard()
            }
            .padding(24)
        }
        .equalScreenBackground()
    }
}
