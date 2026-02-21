import SwiftUI

struct RestrictionsSection: View {
    let restrictions: [RestrictionItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HazTheme.sectionHeader("Carrier & Geographic Restrictions", icon: "exclamationmark.triangle.fill")

            ForEach(restrictions) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: item.severity.iconName)
                        .font(.system(size: 14))
                        .foregroundStyle(item.severity.color)
                        .frame(width: 20, alignment: .center)
                        .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 8) {
                            Text(item.carrier)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(HazTheme.textPrimary)

                            Text(item.severity.rawValue)
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .foregroundStyle(item.severity.color)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(item.severity.color.opacity(0.15))
                                )
                        }

                        Text(item.restriction)
                            .font(.system(size: 11))
                            .foregroundStyle(HazTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.vertical, 4)

                if item.id != restrictions.last?.id {
                    Divider()
                        .background(Color.white.opacity(0.06))
                }
            }
        }
        .hazCard()
    }
}
