import Foundation

// MARK: - Battery Chemistry

enum BatteryChemistry: String, CaseIterable, Identifiable {
    case lfp = "LFP"
    case nmc = "NMC"
    case lco = "LCO"

    var id: String { rawValue }

    var fullName: String {
        switch self {
        case .lfp: return "Lithium Iron Phosphate"
        case .nmc: return "Nickel Manganese Cobalt"
        case .lco: return "Lithium Cobalt Oxide"
        }
    }

    var safetyProfile: String {
        switch self {
        case .lfp:
            return "Lowest thermal runaway risk among common Li-ion chemistries. Excellent thermal stability up to ~270°C. Preferred for large-format and stationary storage."
        case .nmc:
            return "Moderate thermal runaway risk. Higher energy density than LFP but lower thermal stability (~210°C onset). Most common in EVs and consumer electronics."
        case .lco:
            return "Highest energy density but also highest thermal runaway risk (~150°C onset). Common in smartphones and laptops. Requires careful thermal management."
        }
    }

    var nominalVoltage: String {
        switch self {
        case .lfp: return "3.2V"
        case .nmc: return "3.6–3.7V"
        case .lco: return "3.6–3.7V"
        }
    }
}

// MARK: - Battery Configuration

enum BatteryConfiguration: String, CaseIterable, Identifiable {
    case standalone = "Standalone"
    case packedWithEquipment = "Packed with Equipment"
    case containedInEquipment = "Contained in Equipment"
    case installedInCTU = "Installed in CTU"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .standalone:
            return "Batteries shipped by themselves, not in or with equipment"
        case .packedWithEquipment:
            return "Batteries packaged alongside the equipment they power"
        case .containedInEquipment:
            return "Batteries installed inside the equipment they power"
        case .installedInCTU:
            return "Batteries installed in a cargo transport unit for external power"
        }
    }

    var shortLabel: String {
        switch self {
        case .standalone: return "Standalone"
        case .packedWithEquipment: return "Packed w/ Equip."
        case .containedInEquipment: return "In Equipment"
        case .installedInCTU: return "In CTU"
        }
    }
}

// MARK: - Shipping Method

enum ShippingMethod: String, CaseIterable, Identifiable {
    case ground = "Ground"
    case airCargo = "Air — Cargo"
    case airPassenger = "Air — Passenger"
    case ocean = "Ocean"

    var id: String { rawValue }

    var regulatoryBody: String {
        switch self {
        case .ground: return "DOT 49 CFR"
        case .airCargo, .airPassenger: return "IATA DGR"
        case .ocean: return "IMDG Code"
        }
    }

    var iconName: String {
        switch self {
        case .ground: return "truck.box.fill"
        case .airCargo: return "airplane"
        case .airPassenger: return "airplane.circle"
        case .ocean: return "ferry.fill"
        }
    }
}

// MARK: - Battery Input

struct BatteryInput {
    var chemistry: BatteryChemistry = .lfp
    var configuration: BatteryConfiguration = .standalone
    var wattHours: Double = 50.0
    var quantity: Int = 1
    var shippingMethod: ShippingMethod = .ground
}
