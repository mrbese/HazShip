import SwiftUI

struct LabelingSection: View {
    let labels: [LabelRequirement]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HazTheme.sectionHeader("Required Labels & Marks", icon: "tag.fill")

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 10) {
                ForEach(labels) { label in
                    labelCard(label)
                }
            }
        }
        .hazCard()
    }

    private func labelCard(_ label: LabelRequirement) -> some View {
        VStack(spacing: 8) {
            Image(systemName: label.symbolName)
                .font(.system(size: 22))
                .foregroundStyle(HazTheme.hazardOrange)
                .frame(height: 28)

            Text(label.name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(HazTheme.textPrimary)
                .multilineTextAlignment(.center)

            Text(label.description)
                .font(.system(size: 9))
                .foregroundStyle(HazTheme.textMuted)
                .multilineTextAlignment(.center)
                .lineLimit(4)
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(HazTheme.surfaceMid)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
}
