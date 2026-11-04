import SwiftUI

/// Green unread count (18pt) under a chat's time and on the Chats tab; `dot` is the 8pt variant.
public struct EqualUnreadCount: View {
    let count: Int?

    public init(_ count: Int) { self.count = count }
    /// The 8pt dot.
    public init() { self.count = nil }

    public var body: some View {
        if let count {
            Text(count > 99 ? "99+" : "\(count)")
                .font(.equal(size: 11, weight: .bold)).foregroundStyle(.white)
                .padding(.horizontal, 5).frame(minWidth: 18, minHeight: 18)
                .background(Capsule().fill(EqualColor.green))
                .accessibilityLabel("\(count) unread")
        } else {
            Circle().fill(EqualColor.green).frame(width: 8, height: 8).accessibilityLabel("Unread")
        }
    }
}

/// iOS-style switch, 44×24, green when on. Used for "AI Assistant is On".
public struct EqualToggle: View {
    @Binding var isOn: Bool
    let label: String

    public init(_ label: String, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }

    public var body: some View {
        Button { withAnimation(.snappy(duration: 0.2)) { isOn.toggle() } } label: {
            Capsule()
                .fill(isOn ? EqualColor.green : EqualColor.buttonDisabled)
                .frame(width: 44, height: 24)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle().fill(.white).frame(width: 20, height: 20).padding(2)
                        .shadow(color: .black.opacity(0.12), radius: 1.5, y: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityAddTraits(.isButton)
    }
}

/// Plan selector radio: a gold-grey ring, or filled green with a white check when selected.
public struct EqualPlanRadio: View {
    let isSelected: Bool
    public init(isSelected: Bool) { self.isSelected = isSelected }
    public var body: some View {
        ZStack {
            if isSelected {
                Circle().fill(EqualColor.green)
                Image(systemName: "checkmark").font(.system(size: 10, weight: .heavy)).foregroundStyle(.white)
            } else {
                Circle().stroke(EqualColor.goldRadio, lineWidth: 1.5)
            }
        }
        .frame(width: 20, height: 20)
        .accessibilityHidden(true)
    }
}

/// 18pt square checkbox with a caption label ("I want to receive updates on Whatsapp").
public struct EqualCheckbox: View {
    @Binding var isOn: Bool
    let label: String

    public init(_ label: String, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }

    public var body: some View {
        Button { isOn.toggle() } label: {
            HStack(spacing: 7) {
                RoundedRectangle(cornerRadius: EqualRadius.xs)
                    .fill(isOn ? EqualColor.green : .clear)
                    .overlay(RoundedRectangle(cornerRadius: EqualRadius.xs).stroke(isOn ? EqualColor.green : EqualColor.strokeDark, lineWidth: 1.5))
                    .overlay { if isOn { Image(systemName: "checkmark").font(.system(size: 10, weight: .heavy)).foregroundStyle(.white) } }
                    .frame(width: 18, height: 18)
                Text(label).equalTextStyle(.caption1).foregroundStyle(EqualColor.textPrimary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityValue(isOn ? "Checked" : "Unchecked")
    }
}

/// "Included" mark in the compare-plans table.
public struct EqualCompareCheck: View {
    public init() {}
    public var body: some View {
        Image(systemName: "checkmark").font(.system(size: 10, weight: .bold))
            .foregroundStyle(EqualColor.successText)
            .frame(width: 20, height: 20)
            .background(Circle().fill(EqualColor.successText.opacity(0.14)))
            .accessibilityLabel("Included")
    }
}

/// Uppercase section header. `.hairlines` centres it between fading rules ("COMPARE PLANS"),
/// `.gold` uses warm gold rules ("WHAT YOU GET"), `.group` is the left-aligned settings label.
public struct EqualSectionLabel: View {
    public enum Style: Sendable { case hairlines, gold, group }
    let text: String
    let style: Style

    public init(_ text: String, style: Style = .hairlines) {
        self.text = text
        self.style = style
    }

    public var body: some View {
        if style == .group {
            Text(text.uppercased()).font(.equal(size: 14, weight: .semibold)).tracking(0.84)
                .foregroundStyle(EqualColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            let line = style == .gold ? Color(equalHex: 0xA37135, alpha: 0.5) : Color.black.opacity(0.14)
            HStack(spacing: EqualSpacing.s8) {
                LinearGradient(colors: [line.opacity(0), line], startPoint: .leading, endPoint: .trailing).frame(height: 1)
                Text(text.uppercased())
                    .font(.equal(size: style == .gold ? 14 : 13, weight: .bold)).tracking(0.52)
                    .foregroundStyle(style == .gold ? EqualColor.textSecondary : EqualColor.legalText)
                    .fixedSize()
                LinearGradient(colors: [line, line.opacity(0)], startPoint: .leading, endPoint: .trailing).frame(height: 1)
            }
        }
    }
}

/// Carousel position: active dot 12pt green-30%, others 8pt grey-30%.
public struct EqualPageDots: View {
    let count: Int
    let active: Int
    public init(count: Int, active: Int) { self.count = count; self.active = active }
    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(i == active ? EqualColor.green.opacity(0.3) : Color(equalHex: 0xA1A1A1, alpha: 0.3))
                    .frame(width: i == active ? 12 : 8, height: i == active ? 12 : 8)
            }
        }
        .accessibilityLabel("Page \(active + 1) of \(count)")
    }
}

/// 3pt progress: green on light, gold on the dark value-recap story.
public struct EqualProgressBar: View {
    public enum Tone: Sendable { case green, gold }
    let value: Double
    let tone: Tone
    public init(value: Double, tone: Tone = .green) { self.value = value; self.tone = tone }
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(tone == .gold ? Color.white.opacity(0.18) : Color.black.opacity(0.08))
                Capsule().fill(tone == .gold ? EqualColor.goldLabel : EqualColor.green)
                    .frame(width: geo.size.width * min(max(value, 0), 1))
            }
        }
        .frame(height: 3)
        .accessibilityValue("\(Int(value * 100)) percent")
    }
}

/// The assistant's progress line with a shimmer ("Thinking...", "Putting it together...").
public struct EqualThinkingText: View {
    let text: String
    @State private var phase: CGFloat = -1
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ text: String = "Thinking...") { self.text = text }

    public var body: some View {
        HStack(spacing: EqualSpacing.s8) {
            ZStack { Circle().fill(EqualGradient.voice); EqualMark(size: 13, color: .white) }.frame(width: 24, height: 24)
            Text(text).equalTextStyle(.typing).foregroundStyle(EqualColor.textSecondary)
                .overlay {
                    if !reduceMotion {
                        LinearGradient(colors: [.clear, EqualColor.bgSurface.opacity(0.9), .clear], startPoint: .leading, endPoint: .trailing)
                            .offset(x: phase * 120)
                            .mask(Text(text).equalTextStyle(.typing))
                    }
                }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 1.6).repeatForever(autoreverses: false)) { phase = 1 }
        }
    }
}

/// Payment spinner: a gold arc turning around the 3D crown.
public struct EqualCrownLoader: View {
    let size: CGFloat
    @State private var spin = false
    public init(size: CGFloat = 80) { self.size = size }
    public var body: some View {
        ZStack {
            Circle().stroke(Color.black.opacity(0.08), lineWidth: 4)
            Circle().trim(from: 0, to: 0.25)
                .stroke(Color(equalHex: 0xA3712F), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(spin ? 360 : 0))
            EqualIllustration(.crown, size: size * 0.62)
        }
        .frame(width: size, height: size)
        .onAppear { withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) { spin = true } }
        .accessibilityLabel("Processing")
    }
}

struct EqualSmallAtoms_Previews: PreviewProvider {
    struct Demo: View {
        @State var on = true
        @State var checked = true
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack { EqualUnreadCount(1); EqualUnreadCount(12); EqualUnreadCount(140); EqualUnreadCount() }
                HStack { EqualToggle("AI Assistant", isOn: $on); EqualPlanRadio(isSelected: false); EqualPlanRadio(isSelected: true); EqualCompareCheck() }
                EqualCheckbox("I want to receive updates on Whatsapp", isOn: $checked)
                EqualSectionLabel("Compare plans")
                EqualSectionLabel("What you get", style: .gold)
                EqualSectionLabel("Your assistant", style: .group)
                EqualPageDots(count: 5, active: 0)
                EqualProgressBar(value: 0.4)
                EqualThinkingText()
                EqualCrownLoader()
            }
            .padding(24)
            .equalScreenBackground()
        }
    }
    static var previews: some View { Demo() }
}
