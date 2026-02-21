import SwiftUI

struct PackagingSection: View {
    let requirements: [PackagingRequirement]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HazTheme.sectionHeader("Packaging Requirements", icon: "shippingbox.fill")

            ForEach(requirements) { req in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: req.iconName)
                        .font(.system(size: 13))
                        .foregroundStyle(req.isMandatory ? HazTheme.hazardOrange : HazTheme.textSecondary)
                        .frame(width: 20, alignment: .center)
                        .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(req.title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(HazTheme.textPrimary)
                        Text(req.detail)
                            .font(.system(size: 11))
                            .foregroundStyle(HazTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.vertical, 4)

                if req.id != requirements.last?.id {
                    Divider()
                        .background(Color.white.opacity(0.06))
                }
            }
        }
        .hazCard()
    }
}
