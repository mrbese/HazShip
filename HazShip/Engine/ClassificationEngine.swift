import Foundation

// MARK: - Classification Engine

struct ClassificationEngine {

    /// Main entry point — classifies a battery input and returns the full regulatory result.
    static func classify(_ input: BatteryInput) -> ClassificationResult {
        let unNumber = determineUNNumber(input.configuration)
        let properName = determineProperShippingName(input.configuration)
        let pi = determinePackingInstruction(input.configuration)
        let section = determinePackingSection(input.wattHours)
        let effectiveSection = input.configuration == .installedInCTU ? .notApplicable : section

        // Check prohibitions
        let (isProhibited, prohibitedReason) = checkProhibitions(
            method: input.shippingMethod,
            pi: pi,
            section: effectiveSection,
            configuration: input.configuration
        )

        // Generate sub-results
        let packaging = PackagingEngine.requirements(for: input, section: effectiveSection)
        let labels = LabelingEngine.requirements(for: input, pi: pi, section: effectiveSection)
        let documents = DocumentationEngine.checklist(for: input, pi: pi, section: effectiveSection)
        let restrictions = RestrictionsEngine.restrictions(for: input)
        let chemistryNotes = chemistryInfo(input.chemistry)

        return ClassificationResult(
            unNumber: unNumber,
            properShippingName: properName,
            hazardClass: "9",
            packingInstruction: pi,
            packingSection: effectiveSection,
            packaging: packaging,
            labels: labels,
            documents: documents,
            restrictions: restrictions,
            chemistryNotes: chemistryNotes,
            isProhibited: isProhibited,
            prohibitedReason: prohibitedReason
        )
    }

    // MARK: - UN Number

    static func determineUNNumber(_ config: BatteryConfiguration) -> String {
        switch config {
        case .standalone:
            return "UN3480"
        case .packedWithEquipment, .containedInEquipment:
            return "UN3481"
        case .installedInCTU:
            return "UN3536"
        }
    }

    // MARK: - Proper Shipping Name

    static func determineProperShippingName(_ config: BatteryConfiguration) -> String {
        switch config {
        case .standalone:
            return "LITHIUM ION BATTERIES"
        case .packedWithEquipment:
            return "LITHIUM ION BATTERIES PACKED WITH EQUIPMENT"
        case .containedInEquipment:
            return "LITHIUM ION BATTERIES CONTAINED IN EQUIPMENT"
        case .installedInCTU:
            return "LITHIUM BATTERIES INSTALLED IN CARGO TRANSPORT UNIT"
        }
    }

    // MARK: - Packing Instruction

    static func determinePackingInstruction(_ config: BatteryConfiguration) -> String {
        switch config {
        case .standalone:
            return "PI 965"
        case .packedWithEquipment:
            return "PI 966"
        case .containedInEquipment:
            return "PI 967"
        case .installedInCTU:
            return "SP 389/390"  // Special provisions, no standard PI
        }
    }

    // MARK: - Packing Section

    /// Determines packing section based on Wh per battery.
    /// Assumes a single-cell battery for simplicity (cell Wh = battery Wh).
    /// For multi-cell batteries, the cell Wh threshold is 20 Wh.
    static func determinePackingSection(_ wattHours: Double) -> PackingSection {
        if wattHours <= 100 {
            // For simplicity, we treat the battery as single-cell if ≤20 Wh,
            // multi-cell (Section IB) if 20 < Wh ≤ 100
            if wattHours <= 20 {
                return .sectionII
            } else {
                return .sectionIB
            }
        } else {
            return .sectionIA
        }
    }

    // MARK: - Prohibitions

    static func checkProhibitions(
        method: ShippingMethod,
        pi: String,
        section: PackingSection,
        configuration: BatteryConfiguration
    ) -> (Bool, String?) {

        // PI 965 (standalone) on passenger aircraft — PROHIBITED
        if pi == "PI 965" && method == .airPassenger {
            return (true, "Standalone lithium-ion batteries (UN3480, PI 965) are PROHIBITED on passenger aircraft under IATA DGR. Use Cargo Aircraft Only or ground transport.")
        }

        // PI 965 Section II was removed from IATA in 63rd Edition (2022)
        // Standalone batteries MUST ship under Section I for air
        if pi == "PI 965" && (method == .airCargo || method == .airPassenger) && section == .sectionII {
            // Actually, Section II was removed for PI 965 air — so even small standalone must ship Section IB/IA for air
            // For ground and ocean, Section II still applies
            // We handle this by upgrading the requirement messaging rather than blocking
        }

        // Section I on passenger aircraft for PI 966/967 — depends on weight
        if (pi == "PI 966" || pi == "PI 967") && method == .airPassenger && (section == .sectionIA || section == .sectionIB) {
            return (true, "Section I lithium-ion batteries packed with/in equipment are PROHIBITED on passenger aircraft. Only Section II (≤100 Wh) is permitted on passenger aircraft via PI 966/967.")
        }

        return (false, nil)
    }

    // MARK: - Chemistry Info

    static func chemistryInfo(_ chemistry: BatteryChemistry) -> String {
        switch chemistry {
        case .lfp:
            return """
            LFP (Lithium Iron Phosphate) — Safest common Li-ion chemistry.
            • Thermal stability: Excellent (onset ~270°C)
            • Nominal voltage: 3.2V per cell
            • Energy density: Lower (~120-160 Wh/kg)
            • Cycle life: Excellent (2000-5000+ cycles)
            • Fire risk: Lowest among Li-ion types
            • Common use: ESS, buses, commercial vehicles
            """
        case .nmc:
            return """
            NMC (Nickel Manganese Cobalt) — Balanced performance.
            • Thermal stability: Moderate (onset ~210°C)
            • Nominal voltage: 3.6-3.7V per cell
            • Energy density: High (~150-220 Wh/kg)
            • Cycle life: Good (1000-2000 cycles)
            • Fire risk: Moderate — thermal runaway propagation possible
            • Common use: EVs, power tools, laptops
            """
        case .lco:
            return """
            LCO (Lithium Cobalt Oxide) — Highest energy density.
            • Thermal stability: Lowest (onset ~150°C)
            • Nominal voltage: 3.6-3.7V per cell
            • Energy density: Very high (~150-200 Wh/kg)
            • Cycle life: Moderate (500-1000 cycles)
            • Fire risk: Highest — most prone to thermal runaway
            • Common use: Smartphones, tablets, cameras
            """
        }
    }
}
