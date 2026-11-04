import SwiftUI

/// iOS notification banner used in the trial-ending flow: black-70% glass, app icon, title, "now", body.
public struct EqualPushBanner: View {
    let title: String
    let message: String
    let time: String

    public init(_ title: String, message: String, time: String = "now") {
        self.title = title
        self.message = message
        self.time = time
    }

    public var body: some View {
        HStack(spacing: EqualSpacing.s10) {
            ZStack { RoundedRectangle(cornerRadius: 9).fill(EqualColor.green); EqualMark(size: 22, color: .white) }
                .frame(width: 38, height: 38)
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title).font(.system(size: 15, weight: .semibold))
                    Spacer()
                    Text(time).font(.system(size: 15)).foregroundStyle(Color(equalHex: 0xA0A0A0))
                }
                Text(message).font(.system(size: 14)).foregroundStyle(EqualColor.grey13).lineLimit(2)
            }
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, EqualSpacing.s12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: EqualRadius.sheet))
        .background(Color.black.opacity(0.7), in: RoundedRectangle(cornerRadius: EqualRadius.sheet))
        .equalShadow(.push)
        .environment(\.colorScheme, .dark)
    }
}

/// 159×100 selectable gender card: label on top, 3D avatar at the bottom.
public struct EqualGenderCard: View {
    let label: String
    let image: EqualImage
    let isSelected: Bool
    let action: () -> Void

    public init(_ label: String, image: EqualImage, isSelected: Bool, action: @escaping () -> Void = {}) {
        self.label = label
        self.image = image
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(label).equalTextStyle(.headline).foregroundStyle(EqualColor.textPrimary).padding(.top, 12)
                Spacer(minLength: 0)
                image.image.aspectRatio(contentMode: .fit).frame(height: 62)
            }
            .frame(width: 159, height: 100)
            .background(RoundedRectangle(cornerRadius: EqualRadius.m).fill(isSelected ? EqualColor.unreadFill : Color.white.opacity(0.3)))
            .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
            .overlay(RoundedRectangle(cornerRadius: EqualRadius.m).stroke(isSelected ? EqualColor.green : EqualColor.strokeMedium, lineWidth: isSelected ? 2 : 1))
            .equalShadow(.card)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// Header pill showing whether the assistant is answering: glass, green dot + "Available", caret.
public struct EqualAvailabilityPill: View {
    let isAvailable: Bool
    let action: () -> Void
    public init(isAvailable: Bool = true, action: @escaping () -> Void = {}) { self.isAvailable = isAvailable; self.action = action }
    public var body: some View {
        Button(action: action) {
            HStack(spacing: EqualSpacing.s8) {
                Circle().frame(width: 7, height: 7)
                Text(isAvailable ? "Available" : "Busy").font(.equal(size: 15))
                EqualIconView(.chevronDown, size: 11, weight: .bold)
            }
            .foregroundStyle(isAvailable ? EqualColor.green : EqualColor.textSecondary)
            .padding(.horizontal, EqualSpacing.s16).frame(height: 36)
            .equalGlass(Capsule())
        }
        .buttonStyle(.plain)
    }
}

/// Header pill during the last trial days: cream-to-yellow, gold border and text, small crown.
public struct EqualTrialPill: View {
    let text: String
    public init(_ text: String = "1 Day Left") { self.text = text }
    public var body: some View {
        HStack(spacing: EqualSpacing.s4) {
            EqualIllustration(.crown, size: 18)
            Text(text).font(.equal(size: 14, weight: .medium))
        }
        .foregroundStyle(EqualColor.goldInk)
        .padding(.horizontal, EqualSpacing.s12).frame(height: 34)
        .background(Capsule().fill(LinearGradient(colors: [Color(equalHex: 0xFFFDF2), Color(equalHex: 0xFEEC83)], startPoint: .top, endPoint: .bottom)))
        .overlay(Capsule().stroke(EqualColor.goldInk, lineWidth: 1))
        .equalShadow(.card)
    }
}

/// Top of the Equal action sheet: grab handle, Equal dot, current task and a close button.
public struct EqualSheetHeader: View {
    let title: String
    let onClose: () -> Void
    public init(_ title: String = "Make a call", onClose: @escaping () -> Void = {}) { self.title = title; self.onClose = onClose }
    public var body: some View {
        HStack(spacing: EqualSpacing.s12) {
            EqualAvatar(.equal, size: 28)
            Text(title).equalTextStyle(.body).foregroundStyle(EqualColor.textPrimary)
            Spacer()
            EqualIconButton(.close, label: "Close", action: onClose)
        }
        .padding(EqualSpacing.s24)
        .background(EqualColor.bgSurface)
        .overlay(alignment: .top) { Capsule().fill(Color(equalHex: 0xADADAD)).frame(width: 89, height: 7).padding(.top, 8) }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: EqualRadius.xl, topTrailingRadius: EqualRadius.xl))
        .shadow(color: Color(equalHex: 0x191919, alpha: 0.08), radius: 8, y: 4)
    }
}

/// Numbered instruction on the payment screen: a black number disc above centred text.
public struct EqualUpiStep: View {
    let number: Int
    let text: String
    public init(_ number: Int, _ text: String) { self.number = number; self.text = text }
    public var body: some View {
        VStack(spacing: EqualSpacing.s10) {
            Text("\(number)").font(.equal(size: 14, weight: .bold)).foregroundStyle(.white)
                .frame(width: 24, height: 24).background(Circle().fill(Color.black))
            Text(text).font(.equal(size: 16)).foregroundStyle(Color.black).multilineTextAlignment(.center).frame(maxWidth: 237)
        }
    }
}

/// Label–value line in the App Store confirmation card (SF Pro, grey label, hairline).
public struct EqualKeyValueRow: View {
    let label: String
    let value: String
    public init(_ label: String, _ value: String) { self.label = label; self.value = value }
    public var body: some View {
        HStack {
            Text(label).foregroundStyle(EqualColor.iosGray)
            Spacer()
            Text(value).foregroundStyle(EqualColor.grey01)
        }
        .font(.system(size: 15))
        .padding(.vertical, 12)
    }
}

struct EqualPillsAndBanners_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            EqualPushBanner("Only 1 day left", message: "Your trial ends tomorrow. Subscribe to Gold before your assistant goes off duty.")
            HStack { EqualGenderCard("Male", image: .avatarMale, isSelected: true); EqualGenderCard("Female", image: .avatarFemale, isSelected: false) }
            HStack { EqualAvailabilityPill(); EqualTrialPill() }
            EqualSheetHeader()
            HStack { EqualUpiStep(1, "Open your UPI app, via notifications or directly"); EqualUpiStep(2, "Review and approve the autopay request") }
            VStack(spacing: 0) { EqualKeyValueRow("Price", "₹499.00 per month"); Divider(); EqualKeyValueRow("Starts", "Today") }
                .padding(.horizontal).background(Color.white, in: RoundedRectangle(cornerRadius: 14))
        }
        .padding(24)
        .equalScreenBackground()
    }
}
