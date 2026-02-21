import Foundation

// MARK: - Classification Result

struct ClassificationResult {
    let unNumber: String
    let properShippingName: String
    let hazardClass: String
    let packingInstruction: String
    let packingSection: PackingSection
    let packaging: [PackagingRequirement]
    let labels: [LabelRequirement]
    let documents: [DocumentChecklistItem]
    let restrictions: [RestrictionItem]
    let chemistryNotes: String
    let isProhibited: Bool
    let prohibitedReason: String?

    var summaryLine: String {
        if isProhibited {
            return "PROHIBITED"
        }
        return "\(unNumber) · \(packingInstruction) · \(packingSection.rawValue)"
    }
}

// MARK: - Packing Section

enum PackingSection: String {
    case sectionIA = "Section IA"
    case sectionIB = "Section IB"
    case sectionII = "Section II"
    case notApplicable = "Special Provisions"

    var description: String {
        switch self {
        case .sectionIA:
            return "Fully regulated. Cells >20 Wh or batteries >100 Wh. Full testing, UN packaging, and documentation required."
        case .sectionIB:
            return "Fully regulated. Cells ≤20 Wh and batteries ≤100 Wh but above Section II limits. Full UN packaging required."
        case .sectionII:
            return "Reduced requirements. Cells ≤20 Wh and batteries ≤100 Wh. Simplified packaging and documentation."
        case .notApplicable:
            return "Special provisions apply for this configuration. Consult 49 CFR and applicable modal regulations."
        }
    }
}

// MARK: - Packaging Requirement

struct PackagingRequirement: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let isMandatory: Bool

    var iconName: String {
        isMandatory ? "exclamationmark.circle.fill" : "info.circle.fill"
    }
}

// MARK: - Label Requirement

struct LabelRequirement: Identifiable {
    let id = UUID()
    let name: String
    let symbolName: String
    let description: String
}

// MARK: - Document Checklist Item

struct DocumentChecklistItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted: Bool = false
}

// MARK: - Restriction Item

struct RestrictionItem: Identifiable {
    let id = UUID()
    let carrier: String
    let restriction: String
    let severity: RestrictionSeverity
}

enum RestrictionSeverity: String {
    case info = "Accepted"
    case warning = "Restrictions Apply"
    case prohibited = "Prohibited"

    var iconName: String {
        switch self {
        case .info: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .prohibited: return "xmark.octagon.fill"
        }
    }

    var colorName: String {
        switch self {
        case .info: return "green"
        case .warning: return "yellow"
        case .prohibited: return "red"
        }
    }
}
