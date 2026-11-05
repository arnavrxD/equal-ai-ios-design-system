import SwiftUI

/// Top of the Equal chat sheet (98pt, white): 89×7 grab handle, the 28pt Equal dot, the current
/// task ("Make a call") and a 48pt close button, with a soft shadow onto the thread. The header
/// itself is square; the sheet around it supplies the 28pt top corners.
public struct EqualSheetHeader: View {
    let title: String
    let onClose: () -> Void
    public init(_ title: String = "Make a call", onClose: @escaping () -> Void = {}) { self.title = title; self.onClose = onClose }
    public var body: some View {
        HStack(spacing: EqualSpacing.s12) {
            EqualAvatar(.equal, size: 28)
                .shadow(color: .black.opacity(0.16), radius: 1.3)
            Text(title).equalTextStyle(.body).foregroundStyle(Color(equalHex: 0x111111))
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark").font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(equalHex: 0x555555))
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(Color.white).equalShadow(.close))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close")
        }
        .padding(.leading, EqualSpacing.s24)
        .padding(.trailing, 25)
        .frame(height: 98)
        .background(Color.white)
        .overlay(alignment: .top) { Capsule().fill(Color(equalHex: 0xADADAD)).frame(width: 89, height: 7).padding(.top, 12) }
        .shadow(color: Color(equalHex: 0x191919, alpha: 0.08), radius: 8, y: 4)
        .environment(\.colorScheme, .light)
    }
}

struct EqualSheetHeader_Previews: PreviewProvider {
    static var previews: some View {
        EqualSheetHeader().padding(.bottom, 24).background(Color(equalHex: 0xE8E8E8))
    }
}
