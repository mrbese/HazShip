import SwiftUI

struct ChemistryNotesSection: View {
    let notes: String
    let chemistry: BatteryChemistry

    var riskColor: Color {
        switch chemistry {
        case .lfp: return HazTheme.safeGreen
        case .nmc: return HazTheme.warningYellow
        case .lco: return HazTheme.dangerRed
        }
    }

    var riskLevel: String {
        switch chemistry {
        case .lfp: return "LOW RISK"
        case .nmc: return "MODERATE RISK"
        case .lco: return "HIGH RISK"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HazTheme.sectionHeader("Chemistry Profile", icon: "atom")
                Spacer()
                Text(riskLevel)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(riskColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(riskColor.opacity(0.15))
                    )
            }

            // Risk indicator bar
            HStack(spacing: 4) {
                riskBar(filled: true, color: HazTheme.safeGreen)
                riskBar(filled: chemistry == .nmc || chemistry == .lco, color: HazTheme.warningYellow)
                riskBar(filled: chemistry == .lco, color: HazTheme.dangerRed)
            }

            Text(notes)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(HazTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .hazCard()
    }

    private func riskBar(filled: Bool, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(filled ? color : color.opacity(0.15))
            .frame(height: 6)
    }
}
