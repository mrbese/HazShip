import Foundation

// MARK: - Labeling Engine

struct LabelingEngine {

    static func requirements(
        for input: BatteryInput,
        pi: String,
        section: PackingSection
    ) -> [LabelRequirement] {
        var labels: [LabelRequirement] = []

        // CTU special case
        if input.configuration == .installedInCTU {
            labels.append(LabelRequirement(
                name: "UN3536 Placard",
                symbolName: "exclamationmark.triangle.fill",
                description: "Orange UN3536 placard on all four sides of the cargo transport unit."
            ))
            labels.append(LabelRequirement(
                name: "Class 9 Hazard Label",
                symbolName: "diamond.fill",
                description: "Class 9 miscellaneous dangerous goods label on the CTU."
            ))
            return labels
        }

        // Section II — reduced labeling
        if section == .sectionII {
            labels.append(LabelRequirement(
                name: "Lithium Battery Mark",
                symbolName: "battery.100.bolt",
                description: "Lithium battery handling mark with UN number, telephone number (optional after Dec 2026). Minimum 120×110 mm for packages ≥30 kg, 105×74 mm otherwise."
            ))

            labels.append(LabelRequirement(
                name: "UN Number on Package",
                symbolName: "number",
                description: "UN number prominently displayed on the outer package (e.g., UN3480 or UN3481)."
            ))
        }

        // Section I — full labeling
        if section == .sectionIA || section == .sectionIB {
            labels.append(LabelRequirement(
                name: "Class 9 Hazard Label",
                symbolName: "diamond.fill",
                description: "Class 9 (Miscellaneous Dangerous Goods) diamond label, minimum 100×100 mm."
            ))

            labels.append(LabelRequirement(
                name: "Lithium Battery Mark",
                symbolName: "battery.100.bolt",
                description: "Lithium battery handling mark with UN number. Required on all packages."
            ))

            labels.append(LabelRequirement(
                name: "Proper Shipping Name & UN Number",
                symbolName: "doc.text.fill",
                description: "Proper shipping name and UN identification number on the outer packaging."
            ))

            labels.append(LabelRequirement(
                name: "Shipper Name & Address",
                symbolName: "person.text.rectangle",
                description: "Name and address of shipper and consignee on the outer packaging."
            ))
        }

        // Air-specific labels
        switch input.shippingMethod {
        case .airCargo:
            if section == .sectionIA || section == .sectionIB {
                labels.append(LabelRequirement(
                    name: "Cargo Aircraft Only Label",
                    symbolName: "airplane",
                    description: "\"Cargo Aircraft Only\" label required for all Section I lithium battery shipments by air."
                ))
            }
            labels.append(LabelRequirement(
                name: "Handling Label (CAO)",
                symbolName: "hand.raised.fill",
                description: "Handling label indicating the package contains lithium batteries and special procedures apply if damaged."
            ))
        case .airPassenger:
            labels.append(LabelRequirement(
                name: "Handling Label",
                symbolName: "hand.raised.fill",
                description: "Handling label indicating the package contains lithium batteries."
            ))
        case .ocean:
            if section == .sectionIA || section == .sectionIB {
                labels.append(LabelRequirement(
                    name: "IMDG Marine Placard",
                    symbolName: "ferry.fill",
                    description: "Class 9 placard on freight container or transport unit for ocean transport (IMDG Code)."
                ))
            }
        case .ground:
            break
        }

        // Wh marking — always required
        labels.append(LabelRequirement(
            name: "Watt-Hour Rating Mark",
            symbolName: "bolt.circle",
            description: "Wh rating marked on the outside case of each battery. Mandatory for all lithium-ion batteries (49 CFR, May 2024)."
        ))

        // Orientation arrows if applicable
        if input.configuration == .containedInEquipment || input.configuration == .packedWithEquipment {
            labels.append(LabelRequirement(
                name: "Orientation Arrows",
                symbolName: "arrow.up",
                description: "\"This Way Up\" orientation arrows if the package contains liquid electrolyte or must remain upright."
            ))
        }

        return labels
    }
}
