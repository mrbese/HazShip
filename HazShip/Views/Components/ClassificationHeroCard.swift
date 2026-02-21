import SwiftUI

struct ClassificationHeroCard: View {
    let result: ClassificationResult
    let input: BatteryInput
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 14) {
            // UN Number — large hero display
            HStack(spacing: 12) {
                Image(systemName: result.isProhibited ? "xmark.octagon.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white.opacity(0.9))

                VStack(alignment: .leading, spacing: 2) {
                    Text(result.unNumber)
                        .font(.system(size: 36, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                    Text("Hazard Class \(result.hazardClass) — Miscellaneous Dangerous Goods")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()
            }

            Divider()
                .background(.white.opacity(0.2))

            // Classification details grid
            VStack(spacing: 8) {
                detailRow(label: "Proper Shipping Name", value: result.properShippingName)
                detailRow(label: "Packing Instruction", value: result.packingInstruction)
                detailRow(label: "Packing Section", value: result.packingSection.rawValue)
                detailRow(label: "Chemistry", value: "\(input.chemistry.rawValue) (\(input.chemistry.fullName))")
                detailRow(label: "Watt-Hours", value: "\(formatWh(input.wattHours)) Wh × \(input.quantity)")
                detailRow(label: "Shipping Method", value: input.shippingMethod.rawValue)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(result.isProhibited ? HazTheme.prohibitedGradient : HazTheme.heroGradient)
                .shadow(color: (result.isProhibited ? HazTheme.dangerRed : HazTheme.hazardOrange).opacity(0.3), radius: 16, y: 8)
        )
        .scaleEffect(appeared ? 1.0 : 0.95)
        .opacity(appeared ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 110, alignment: .leading)
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func formatWh(_ wh: Double) -> String {
        if wh == wh.rounded() {
            return String(format: "%.0f", wh)
        }
        return String(format: "%.1f", wh)
    }
}
