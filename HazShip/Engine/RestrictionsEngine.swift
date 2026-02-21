import Foundation

// MARK: - Restrictions Engine

struct RestrictionsEngine {

    static func restrictions(for input: BatteryInput) -> [RestrictionItem] {
        var items: [RestrictionItem] = []

        // Determine section for restriction logic
        let section = ClassificationEngine.determinePackingSection(input.wattHours)
        let isStandalone = input.configuration == .standalone

        // USPS restrictions
        items.append(contentsOf: uspsRestrictions(input: input, section: section, isStandalone: isStandalone))

        // UPS restrictions
        items.append(contentsOf: upsRestrictions(input: input, section: section, isStandalone: isStandalone))

        // FedEx restrictions
        items.append(contentsOf: fedexRestrictions(input: input, section: section))

        // DHL restrictions
        items.append(contentsOf: dhlRestrictions(input: input, section: section))

        // Geographic restrictions
        items.append(contentsOf: geographicRestrictions(input: input))

        return items
    }

    // MARK: - USPS

    private static func uspsRestrictions(input: BatteryInput, section: PackingSection, isStandalone: Bool) -> [RestrictionItem] {
        var items: [RestrictionItem] = []

        switch input.shippingMethod {
        case .ground:
            if isStandalone {
                items.append(RestrictionItem(
                    carrier: "USPS",
                    restriction: "Standalone lithium-ion batteries accepted via surface/ground mail only. Must be ≤300 Wh per battery and marked 'SURFACE ONLY'.",
                    severity: .warning
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "USPS",
                    restriction: "Batteries packed with or contained in equipment accepted via ground. Section II only.",
                    severity: section == .sectionII ? .info : .prohibited
                ))
            }
        case .airCargo, .airPassenger:
            if isStandalone {
                items.append(RestrictionItem(
                    carrier: "USPS",
                    restriction: "Standalone lithium-ion batteries are PROHIBITED via USPS air mail.",
                    severity: .prohibited
                ))
            } else if section == .sectionII {
                items.append(RestrictionItem(
                    carrier: "USPS",
                    restriction: "Section II batteries packed with/in equipment accepted via domestic air. International air: prohibited.",
                    severity: .warning
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "USPS",
                    restriction: "Section I (fully regulated) lithium batteries not accepted by USPS.",
                    severity: .prohibited
                ))
            }
        case .ocean:
            items.append(RestrictionItem(
                carrier: "USPS",
                restriction: "USPS does not offer ocean freight service. Use a freight carrier.",
                severity: .warning
            ))
        }

        return items
    }

    // MARK: - UPS

    private static func upsRestrictions(input: BatteryInput, section: PackingSection, isStandalone: Bool) -> [RestrictionItem] {
        var items: [RestrictionItem] = []

        switch input.shippingMethod {
        case .ground:
            if section == .sectionII {
                items.append(RestrictionItem(
                    carrier: "UPS",
                    restriction: "Section II accepted via UPS Ground. Standard lithium battery mark and documentation required.",
                    severity: .info
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "UPS",
                    restriction: "Section I (fully regulated) accepted via UPS Ground with hazmat contract and proper documentation.",
                    severity: .warning
                ))
            }
        case .airCargo:
            if isStandalone && (section == .sectionIA || section == .sectionIB) {
                items.append(RestrictionItem(
                    carrier: "UPS",
                    restriction: "Section I standalone batteries accepted via UPS Air Freight (CAO) with hazmat service agreement. Contact UPS DG team.",
                    severity: .warning
                ))
            } else if section == .sectionII && !isStandalone {
                items.append(RestrictionItem(
                    carrier: "UPS",
                    restriction: "Section II batteries with/in equipment accepted via UPS Next Day Air / 2nd Day Air.",
                    severity: .info
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "UPS",
                    restriction: "Contact UPS Dangerous Goods team for specific acceptance criteria for this configuration.",
                    severity: .warning
                ))
            }
        case .airPassenger:
            items.append(RestrictionItem(
                carrier: "UPS",
                restriction: "UPS does not operate passenger aircraft. Shipments routed via UPS cargo network.",
                severity: .info
            ))
        case .ocean:
            items.append(RestrictionItem(
                carrier: "UPS",
                restriction: "UPS offers ocean freight for lithium batteries via UPS Supply Chain Solutions. Requires DG documentation.",
                severity: .info
            ))
        }

        return items
    }

    // MARK: - FedEx

    private static func fedexRestrictions(input: BatteryInput, section: PackingSection) -> [RestrictionItem] {
        var items: [RestrictionItem] = []

        switch input.shippingMethod {
        case .ground:
            if section == .sectionII {
                items.append(RestrictionItem(
                    carrier: "FedEx",
                    restriction: "Section II accepted via FedEx Ground with lithium battery mark. No DG contract required.",
                    severity: .info
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "FedEx",
                    restriction: "Section I accepted via FedEx Freight with FedEx Dangerous Goods service agreement.",
                    severity: .warning
                ))
            }
        case .airCargo:
            if section == .sectionII {
                items.append(RestrictionItem(
                    carrier: "FedEx",
                    restriction: "Section II accepted via FedEx Express. Standard lithium battery requirements apply.",
                    severity: .info
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "FedEx",
                    restriction: "Section I accepted via FedEx Express (CAO) with approved DG shipper account. Full IATA documentation required.",
                    severity: .warning
                ))
            }
        case .airPassenger:
            items.append(RestrictionItem(
                carrier: "FedEx",
                restriction: "FedEx operates cargo aircraft. Passenger aircraft rules apply only to codeshare/commercial routing — contact FedEx DG team.",
                severity: .info
            ))
        case .ocean:
            items.append(RestrictionItem(
                carrier: "FedEx",
                restriction: "FedEx Trade Networks offers ocean freight for lithium batteries with proper IMDG documentation.",
                severity: .info
            ))
        }

        return items
    }

    // MARK: - DHL

    private static func dhlRestrictions(input: BatteryInput, section: PackingSection) -> [RestrictionItem] {
        var items: [RestrictionItem] = []

        switch input.shippingMethod {
        case .ground:
            items.append(RestrictionItem(
                carrier: "DHL",
                restriction: "DHL Express/eCommerce ground services accept lithium batteries per DOT 49 CFR. Standard documentation required.",
                severity: .info
            ))
        case .airCargo, .airPassenger:
            if section == .sectionII {
                items.append(RestrictionItem(
                    carrier: "DHL",
                    restriction: "DHL Express accepts Section II lithium batteries per IATA. Additional SoC documentation may be required for large shipments.",
                    severity: .info
                ))
            } else {
                items.append(RestrictionItem(
                    carrier: "DHL",
                    restriction: "Section I accepted via DHL Express with DG shipper certification and IATA DGD. Must use approved DHL DG account.",
                    severity: .warning
                ))
            }
        case .ocean:
            items.append(RestrictionItem(
                carrier: "DHL",
                restriction: "DHL Global Forwarding offers ocean freight for lithium batteries with IMDG compliance.",
                severity: .info
            ))
        }

        return items
    }

    // MARK: - Geographic

    private static func geographicRestrictions(input: BatteryInput) -> [RestrictionItem] {
        var items: [RestrictionItem] = []

        if input.shippingMethod == .ground {
            items.append(RestrictionItem(
                carrier: "Alaska / Hawaii",
                restriction: "Ground shipping not available to Alaska or Hawaii. Air or ocean transport required, adding IATA DGR or IMDG requirements.",
                severity: .warning
            ))
        }

        if input.shippingMethod == .airCargo || input.shippingMethod == .airPassenger {
            items.append(RestrictionItem(
                carrier: "International",
                restriction: "International air shipments may be subject to additional country-specific variations of ICAO Technical Instructions. Verify destination country requirements.",
                severity: .warning
            ))
        }

        return items
    }
}
