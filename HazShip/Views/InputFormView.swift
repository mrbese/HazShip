import SwiftUI

struct InputFormView: View {
    @State private var input = BatteryInput()
    @State private var showResults = false
    @State private var result: ClassificationResult?
    @State private var wattHourText: String = "50"
    @State private var animateTitle = false

    var body: some View {
        ZStack {
            HazTheme.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    formSection
                    classifyButton
                    disclaimerSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showResults) {
            if let result = result {
                ResultsView(result: result, input: input)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateTitle = true
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "bolt.shield.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(HazTheme.hazardOrange)
                    .scaleEffect(animateTitle ? 1.0 : 0.5)
                    .opacity(animateTitle ? 1.0 : 0.0)

                VStack(alignment: .leading, spacing: 2) {
                    Text("HazShip")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Lithium Battery Classifier")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(HazTheme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("HAZMAT shipping classification lookup for lithium-ion batteries per 49 CFR, IATA DGR, and IMDG Code.")
                .font(.system(size: 12))
                .foregroundStyle(HazTheme.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
        }
        .padding(.top, 12)
    }

    // MARK: - Form

    private var formSection: some View {
        VStack(spacing: 20) {
            // Chemistry
            VStack(alignment: .leading, spacing: 8) {
                label("Battery Chemistry")
                Picker("Chemistry", selection: $input.chemistry) {
                    ForEach(BatteryChemistry.allCases) { chem in
                        Text(chem.rawValue).tag(chem)
                    }
                }
                .pickerStyle(.segmented)
                Text(input.chemistry.fullName)
                    .font(.system(size: 11))
                    .foregroundStyle(HazTheme.textMuted)
            }

            // Configuration
            VStack(alignment: .leading, spacing: 8) {
                label("Battery Configuration")
                Picker("Configuration", selection: $input.configuration) {
                    ForEach(BatteryConfiguration.allCases) { config in
                        Text(config.shortLabel).tag(config)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(HazTheme.surfaceMid)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                Text(input.configuration.description)
                    .font(.system(size: 11))
                    .foregroundStyle(HazTheme.textMuted)
            }

            // Watt-hours
            VStack(alignment: .leading, spacing: 8) {
                label("Watt-Hour Rating (per battery)")
                HStack(spacing: 12) {
                    TextField("Wh", text: $wattHourText)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(HazTheme.surfaceMid)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .onChange(of: wattHourText) { _, newValue in
                            if let value = Double(newValue) {
                                input.wattHours = value
                            }
                        }

                    Text("Wh")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(HazTheme.textSecondary)
                }

                // Quick presets
                HStack(spacing: 8) {
                    ForEach([10, 20, 50, 100, 150, 300], id: \.self) { wh in
                        Button {
                            wattHourText = "\(wh)"
                            input.wattHours = Double(wh)
                        } label: {
                            Text("\(wh)")
                                .font(.system(size: 11, weight: .medium, design: .monospaced))
                                .foregroundStyle(input.wattHours == Double(wh) ? .white : HazTheme.textMuted)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(input.wattHours == Double(wh) ? HazTheme.hazardOrange.opacity(0.3) : HazTheme.surfaceMid)
                                )
                        }
                    }
                }
            }

            // Quantity
            VStack(alignment: .leading, spacing: 8) {
                label("Quantity")
                HStack(spacing: 16) {
                    Button {
                        if input.quantity > 1 { input.quantity -= 1 }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(HazTheme.textSecondary)
                    }

                    Text("\(input.quantity)")
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                        .frame(minWidth: 50)

                    Button {
                        input.quantity += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(HazTheme.hazardOrange)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
            }

            // Shipping Method
            VStack(alignment: .leading, spacing: 8) {
                label("Shipping Method")
                VStack(spacing: 8) {
                    ForEach(ShippingMethod.allCases) { method in
                        Button {
                            input.shippingMethod = method
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: method.iconName)
                                    .font(.system(size: 16))
                                    .frame(width: 24)
                                    .foregroundStyle(input.shippingMethod == method ? HazTheme.hazardOrange : HazTheme.textSecondary)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(method.rawValue)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(input.shippingMethod == method ? .white : HazTheme.textSecondary)
                                    Text(method.regulatoryBody)
                                        .font(.system(size: 11))
                                        .foregroundStyle(HazTheme.textMuted)
                                }

                                Spacer()

                                if input.shippingMethod == method {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(HazTheme.hazardOrange)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(input.shippingMethod == method ? HazTheme.hazardOrange.opacity(0.12) : HazTheme.surfaceMid)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                input.shippingMethod == method ? HazTheme.hazardOrange.opacity(0.4) : Color.white.opacity(0.06),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                    }
                }
            }
        }
        .hazCard()
    }

    // MARK: - Classify Button

    private var classifyButton: some View {
        Button {
            result = ClassificationEngine.classify(input)
            showResults = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 16, weight: .bold))
                Text("CLASSIFY")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .tracking(2)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                HazTheme.heroGradient
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: HazTheme.hazardOrange.opacity(0.3), radius: 12, y: 4)
        }
    }

    // MARK: - Disclaimer

    private var disclaimerSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 11))
            Text("Reference tool only. Always consult 49 CFR, IATA DGR, and IMDG Code for compliance. Not legal advice.")
                .font(.system(size: 10))
        }
        .foregroundStyle(HazTheme.textMuted)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
    }

    // MARK: - Helpers

    private func label(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundStyle(HazTheme.textSecondary)
            .tracking(1)
    }
}

#Preview {
    NavigationStack {
        InputFormView()
    }
    .preferredColorScheme(.dark)
}
