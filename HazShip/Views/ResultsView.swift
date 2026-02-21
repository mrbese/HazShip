import SwiftUI

struct ResultsView: View {
    let result: ClassificationResult
    let input: BatteryInput
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            HazTheme.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    ClassificationHeroCard(result: result, input: input)

                    if result.isProhibited {
                        prohibitedBanner
                    }

                    if !result.isProhibited {
                        PackagingSection(requirements: result.packaging)
                        LabelingSection(labels: result.labels)
                        DocumentChecklistSection(documents: result.documents)
                    }

                    RestrictionsSection(restrictions: result.restrictions)
                    ChemistryNotesSection(notes: result.chemistryNotes, chemistry: input.chemistry)

                    disclaimerFooter
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 15))
                    }
                    .foregroundStyle(HazTheme.hazardOrange)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Prohibited Banner

    private var prohibitedBanner: some View {
        VStack(spacing: 12) {
            Image(systemName: "xmark.octagon.fill")
                .font(.system(size: 40))
                .foregroundStyle(HazTheme.dangerRed)

            Text("SHIPMENT PROHIBITED")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(HazTheme.dangerRed)
                .tracking(1.5)

            if let reason = result.prohibitedReason {
                Text(reason)
                    .font(.system(size: 13))
                    .foregroundStyle(HazTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(HazTheme.dangerRed.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(HazTheme.dangerRed.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Disclaimer Footer

    private var disclaimerFooter: some View {
        HStack(spacing: 6) {
            Image(systemName: "scale.3d")
                .font(.system(size: 10))
            Text("Reference tool only. Regulations current as of IATA DGR 66th Ed. / 49 CFR 2024 / IMDG 42-24. Not a substitute for regulatory compliance review.")
                .font(.system(size: 10))
        }
        .foregroundStyle(HazTheme.textMuted)
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }
}
