import SwiftUI

/// 159×100 selectable gender card: label on top, a faint ♂/♀ watermark, and the 3D avatar
/// overflowing the bottom edge. Selected: green → lime → green gradient stroke on the lime tint.
public struct EqualGenderCard: View {
    public enum Gender: Sendable { case male, female }

    let gender: Gender
    let isSelected: Bool
    let action: () -> Void

    public init(_ gender: Gender, isSelected: Bool, action: @escaping () -> Void = {}) {
        self.gender = gender
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: EqualRadius.m)
                    .fill(isSelected ? EqualColor.unreadFill : Color.white.opacity(0.3))
                GenderGlyph(gender: gender)
                    .stroke(isSelected ? EqualColor.green.opacity(0.04) : Color.black.opacity(0.02), style: StrokeStyle(lineWidth: gender == .male ? 14.25 : 16.4, lineCap: .square))
                    .frame(width: gender == .male ? 95 : 109, height: gender == .male ? 103 : 118)
                    .offset(x: gender == .male ? -64 : -59, y: gender == .male ? -3 : -14)
                Text(gender == .male ? "Male" : "Female")
                    .equalTextStyle(.headline).foregroundStyle(EqualColor.textPrimary)
                    .padding(.top, gender == .male ? 12 : 10)
                (gender == .male ? EqualImage.avatarMale : EqualImage.avatarFemale).image
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50.5, height: 68)
                    .offset(y: 40)
            }
            .frame(width: 159, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: EqualRadius.m))
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: EqualRadius.m + 1)
                        .stroke(LinearGradient(stops: [.init(color: EqualColor.brandGreen, location: 0), .init(color: EqualColor.brandLime, location: 0.51), .init(color: EqualColor.brandGreen, location: 1)], startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                        .padding(-1)
                } else {
                    RoundedRectangle(cornerRadius: EqualRadius.m + 0.5).stroke(EqualColor.strokeMedium, lineWidth: 1).padding(-0.5)
                }
            }
            .equalShadow(.card)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(gender == .male ? "Male" : "Female")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// The ♂ (ring + arrow) or ♀ (ring + cross) watermark.
struct GenderGlyph: Shape {
    let gender: EqualGenderCard.Gender
    func path(in r: CGRect) -> Path {
        var p = Path()
        if gender == .male {
            let ring = CGRect(x: r.minX, y: r.maxY - r.width * 0.82, width: r.width * 0.82, height: r.width * 0.82)
            p.addEllipse(in: ring)
            let from = CGPoint(x: ring.midX + ring.width * 0.35, y: ring.midY - ring.height * 0.35)
            let tip = CGPoint(x: r.maxX - 4, y: r.minY + 4)
            p.move(to: from); p.addLine(to: tip)
            p.move(to: CGPoint(x: tip.x - r.width * 0.3, y: tip.y)); p.addLine(to: tip); p.addLine(to: CGPoint(x: tip.x, y: tip.y + r.width * 0.3))
        } else {
            let d = r.width * 0.82
            let ring = CGRect(x: r.midX - d / 2, y: r.minY, width: d, height: d)
            p.addEllipse(in: ring)
            p.move(to: CGPoint(x: r.midX, y: ring.maxY)); p.addLine(to: CGPoint(x: r.midX, y: r.maxY))
            p.move(to: CGPoint(x: r.midX - r.width * 0.19, y: r.maxY - r.height * 0.14)); p.addLine(to: CGPoint(x: r.midX + r.width * 0.19, y: r.maxY - r.height * 0.14))
        }
        return p
    }
}

struct EqualGenderCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 23) { EqualGenderCard(.male, isSelected: true); EqualGenderCard(.female, isSelected: false) }
            .padding(24).equalScreenBackground()
    }
}
