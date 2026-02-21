import Foundation

// MARK: - Packaging Engine

struct PackagingEngine {

    static func requirements(
        for input: BatteryInput,
        section: PackingSection
    ) -> [PackagingRequirement] {
        var reqs: [PackagingRequirement] = []

        // Universal requirements for all lithium-ion shipments
        reqs.append(PackagingRequirement(
            title: "Short-Circuit Protection",
            detail: "Terminals must be insulated with non-conductive caps, tape, or placed in individual protective enclosures to prevent short circuits.",
            isMandatory: true
        ))

        reqs.append(PackagingRequirement(
            title: "Watt-Hour Marking",
            detail: "Each battery must be marked with its Wh rating on the outside case. Mandatory since May 10, 2024 (49 CFR §173.185).",
            isMandatory: true
        ))

        reqs.append(PackagingRequirement(
            title: "Prevent Movement",
            detail: "Batteries must be secured within the outer packaging to prevent shifting, using cushioning or dividers.",
            isMandatory: true
        ))

        // Configuration-specific
        if input.configuration == .installedInCTU {
            reqs.append(PackagingRequirement(
                title: "CTU Requirements",
                detail: "Battery must be securely fastened inside the closed cargo transport unit. CTU must be structurally sound and provide adequate ventilation.",
                isMandatory: true
            ))
            reqs.append(PackagingRequirement(
                title: "Pre-Trip Inspection",
                detail: "Visual inspection of connections, mounting hardware, and ventilation before each transport leg.",
                isMandatory: true
            ))
            return reqs
        }

        // Section-specific packaging
        switch section {
        case .sectionII:
            reqs.append(contentsOf: sectionIIPackaging(for: input))
        case .sectionIB:
            reqs.append(contentsOf: sectionIPackaging(for: input, tier: "IB"))
        case .sectionIA:
            reqs.append(contentsOf: sectionIPackaging(for: input, tier: "IA"))
        case .notApplicable:
            break
        }

        // Mode-specific additions
        switch input.shippingMethod {
        case .airCargo:
            reqs.append(PackagingRequirement(
                title: "State of Charge (SoC)",
                detail: "Standalone batteries (UN3480) must not exceed 30% SoC for air transport. Recommended ≤30% for all Li-ion air shipments effective 2026.",
                isMandatory: input.configuration == .standalone
            ))
            if section != .sectionII {
                reqs.append(PackagingRequirement(
                    title: "Cargo Aircraft Only",
                    detail: "Package must be loaded on cargo aircraft only. Not permitted on passenger aircraft.",
                    isMandatory: true
                ))
            }
        case .airPassenger:
            if section != .sectionII {
                reqs.append(PackagingRequirement(
                    title: "Passenger Aircraft Limit",
                    detail: "Only Section II batteries packed with or contained in equipment are permitted on passenger aircraft.",
                    isMandatory: true
                ))
            }
        case .ocean:
            reqs.append(PackagingRequirement(
                title: "IMDG Stowage",
                detail: "Stow away from sources of heat. Segregate from oxidizers and flammable materials per IMDG Code.",
                isMandatory: true
            ))
        case .ground:
            break
        }

        return reqs
    }

    // MARK: - Private Helpers

    private static func sectionIIPackaging(for input: BatteryInput) -> [PackagingRequirement] {
        var reqs: [PackagingRequirement] = []

        reqs.append(PackagingRequirement(
            title: "Strong Outer Packaging",
            detail: "A strong, rigid outer packaging is required. Does not need to meet UN performance testing standards.",
            isMandatory: true
        ))

        let weightLimit: String
        switch input.shippingMethod {
        case .airCargo, .airPassenger:
            switch input.configuration {
            case .standalone:
                weightLimit = "≤2.5 kg net weight per package (air)"
            case .packedWithEquipment, .containedInEquipment:
                weightLimit = "≤5 kg net weight of batteries per package (air)"
            case .installedInCTU:
                weightLimit = "N/A"
            }
        case .ground, .ocean:
            weightLimit = "≤30 kg gross weight per package"
        }

        reqs.append(PackagingRequirement(
            title: "Weight Limit",
            detail: weightLimit,
            isMandatory: true
        ))

        if input.configuration == .packedWithEquipment {
            reqs.append(PackagingRequirement(
                title: "Equipment Separation",
                detail: "Batteries must be packaged separately from equipment within the outer packaging, unless protected from short circuits by the equipment's design.",
                isMandatory: true
            ))
        }

        return reqs
    }

    private static func sectionIPackaging(for input: BatteryInput, tier: String) -> [PackagingRequirement] {
        var reqs: [PackagingRequirement] = []

        reqs.append(PackagingRequirement(
            title: "UN Performance-Tested Packaging",
            detail: "Outer packaging must meet UN Packing Group II performance standards (drop test, stack test, vibration). Marked with UN packaging symbol.",
            isMandatory: true
        ))

        let weightLimit: String
        switch input.shippingMethod {
        case .airCargo:
            weightLimit = "≤35 kg gross weight per package"
        case .airPassenger:
            weightLimit = "Not permitted for standalone (PI 965). ≤5 kg for PI 966/967."
        case .ground:
            weightLimit = "≤30 kg gross weight per package"
        case .ocean:
            weightLimit = "≤30 kg gross weight per package (IMDG)"
        }

        reqs.append(PackagingRequirement(
            title: "Weight Limit",
            detail: weightLimit,
            isMandatory: true
        ))

        if tier == "IA" {
            reqs.append(PackagingRequirement(
                title: "Individual Cell/Battery Protection",
                detail: "Section IA: Each battery must be individually packed in an inner packaging and surrounded by cushioning material within the outer packaging.",
                isMandatory: true
            ))
        }

        reqs.append(PackagingRequirement(
            title: "UN 38.3 Testing",
            detail: "All cells and batteries must have passed UN Manual of Tests and Criteria, Section 38.3 design type tests. Test summary must be available.",
            isMandatory: true
        ))

        return reqs
    }
}
