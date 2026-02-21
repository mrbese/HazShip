import Foundation

// MARK: - Documentation Engine

struct DocumentationEngine {

    static func checklist(
        for input: BatteryInput,
        pi: String,
        section: PackingSection
    ) -> [DocumentChecklistItem] {

        // CTU special case
        if input.configuration == .installedInCTU {
            return ctuDocuments()
        }

        switch input.shippingMethod {
        case .ground:
            return groundDocuments(section: section)
        case .airCargo, .airPassenger:
            return airDocuments(section: section, pi: pi, method: input.shippingMethod)
        case .ocean:
            return oceanDocuments(section: section)
        }
    }

    // MARK: - Ground (49 CFR)

    private static func groundDocuments(section: PackingSection) -> [DocumentChecklistItem] {
        var docs: [DocumentChecklistItem] = []

        if section == .sectionII {
            docs.append(DocumentChecklistItem(
                title: "Lithium Battery Mark Applied",
                description: "Confirm lithium battery handling mark is affixed to outer package. Shipping paper NOT required for Section II ground shipments."
            ))
            docs.append(DocumentChecklistItem(
                title: "Wh Rating Visible on Battery",
                description: "Verify Wh rating is marked on each battery's external case."
            ))
            docs.append(DocumentChecklistItem(
                title: "Battery Handling Instructions",
                description: "Include document inside package with handling procedures if batteries are damaged or leak."
            ))
        } else {
            docs.append(DocumentChecklistItem(
                title: "Shipping Paper (49 CFR §172.200)",
                description: "Prepare shipping paper with: proper shipping name, hazard class (9), UN number, packing group, quantity, and emergency contact."
            ))
            docs.append(DocumentChecklistItem(
                title: "Emergency Response Phone Number",
                description: "24-hour emergency response telephone number on shipping paper (CHEMTREC: 1-800-424-9300)."
            ))
            docs.append(DocumentChecklistItem(
                title: "UN 38.3 Test Summary",
                description: "Test summary per UN Manual of Tests and Criteria §38.3 available upon request. Must include test facility, date, and results."
            ))
            docs.append(DocumentChecklistItem(
                title: "Shipper's Certification",
                description: "Signed certification that the shipment is properly classified, described, packaged, marked, and labeled per 49 CFR."
            ))
            docs.append(DocumentChecklistItem(
                title: "Battery Handling Instructions",
                description: "Document inside package describing handling procedures if batteries are damaged or leak."
            ))
        }

        return docs
    }

    // MARK: - Air (IATA DGR)

    private static func airDocuments(section: PackingSection, pi: String, method: ShippingMethod) -> [DocumentChecklistItem] {
        var docs: [DocumentChecklistItem] = []

        if section == .sectionII {
            docs.append(DocumentChecklistItem(
                title: "Shipper's Declaration NOT Required",
                description: "Section II shipments are exempt from the Dangerous Goods Declaration (DGD). However, the Air Waybill must state: 'Lithium ion batteries in compliance with Section II of PI [966/967]'."
            ))
            docs.append(DocumentChecklistItem(
                title: "Air Waybill DG Notation",
                description: "AWB must include the required statement referencing the applicable packing instruction and section."
            ))
            docs.append(DocumentChecklistItem(
                title: "Wh Rating Visible on Battery",
                description: "Verify Wh rating is marked on each battery's external case."
            ))
            docs.append(DocumentChecklistItem(
                title: "Battery Handling Document",
                description: "Include handling instructions inside the package for actions if battery is damaged."
            ))
        } else {
            docs.append(DocumentChecklistItem(
                title: "Shipper's Declaration for Dangerous Goods (DGD)",
                description: "Complete IATA DGD form with: proper shipping name, UN number, class, packing instruction (\(pi)), quantity, net weight, and shipper certification."
            ))
            docs.append(DocumentChecklistItem(
                title: "Electronic DGD Submission",
                description: "Mandatory from January 2025: DGD must be submitted electronically (IATA e-DGD). Paper copies no longer accepted."
            ))
            docs.append(DocumentChecklistItem(
                title: "Air Waybill with DG Notation",
                description: "AWB must reference the dangerous goods shipment and include 'Cargo Aircraft Only' if applicable."
            ))
            docs.append(DocumentChecklistItem(
                title: "UN 38.3 Test Summary",
                description: "Test summary per UN Manual of Tests and Criteria §38.3. Must be available to airline and authority upon request."
            ))
            docs.append(DocumentChecklistItem(
                title: "Packing Compliance Certificate",
                description: "Declaration that packaging meets UN performance testing standards for the applicable packing group."
            ))
            if method == .airCargo {
                docs.append(DocumentChecklistItem(
                    title: "Cargo Aircraft Only Documentation",
                    description: "Ensure 'Cargo Aircraft Only' is indicated on the DGD and all outer packages bear the CAO label."
                ))
            }
            docs.append(DocumentChecklistItem(
                title: "Battery Handling Document",
                description: "Include handling instructions inside the package for actions if battery is damaged."
            ))
        }

        docs.append(DocumentChecklistItem(
            title: "Overpack Declaration (if applicable)",
            description: "If packages are placed inside an overpack, mark the overpack with 'OVERPACK' and ensure all required labels are visible or reproduced on the overpack."
        ))

        return docs
    }

    // MARK: - Ocean (IMDG)

    private static func oceanDocuments(section: PackingSection) -> [DocumentChecklistItem] {
        var docs: [DocumentChecklistItem] = []

        if section == .sectionII {
            docs.append(DocumentChecklistItem(
                title: "Dangerous Goods Declaration (Simplified)",
                description: "For Section II ocean shipments, a simplified DG transport document may be used per IMDG Special Provision 188."
            ))
            docs.append(DocumentChecklistItem(
                title: "Wh Rating Visible on Battery",
                description: "Verify Wh rating is marked on each battery's external case."
            ))
            docs.append(DocumentChecklistItem(
                title: "Battery Handling Document",
                description: "Include handling instructions inside the package."
            ))
        } else {
            docs.append(DocumentChecklistItem(
                title: "Dangerous Goods Declaration (Multimodal)",
                description: "IMO multimodal dangerous goods form with: proper shipping name, UN number, class, packing instruction (P903), and shipper certification."
            ))
            docs.append(DocumentChecklistItem(
                title: "Container/Vehicle Packing Certificate",
                description: "Certificate that the container/vehicle has been packed in accordance with IMDG Code requirements."
            ))
            docs.append(DocumentChecklistItem(
                title: "UN 38.3 Test Summary",
                description: "Test summary per UN Manual of Tests and Criteria §38.3. Must accompany shipment documentation."
            ))
            docs.append(DocumentChecklistItem(
                title: "Electronic Documentation (XML/EDI)",
                description: "As of January 2025, electronic documentation in XML or EDI format is mandatory for IMDG dangerous goods declarations."
            ))
        }

        docs.append(DocumentChecklistItem(
            title: "Marine Pollutant Declaration (if applicable)",
            description: "If battery electrolyte is classified as a marine pollutant, additional marine pollutant marking and documentation required."
        ))

        return docs
    }

    // MARK: - CTU

    private static func ctuDocuments() -> [DocumentChecklistItem] {
        return [
            DocumentChecklistItem(
                title: "UN3536 Transport Document",
                description: "Transport document identifying the lithium battery installation, including battery type, capacity (Wh), and UN3536 classification."
            ),
            DocumentChecklistItem(
                title: "Container/Vehicle Packing Certificate",
                description: "Certificate that the CTU meets structural and ventilation requirements for the installed battery system."
            ),
            DocumentChecklistItem(
                title: "UN 38.3 Test Summary",
                description: "Test summary for the installed battery system per UN Manual of Tests and Criteria §38.3."
            ),
            DocumentChecklistItem(
                title: "Emergency Response Information",
                description: "Emergency response guide specific to the battery chemistry and CTU configuration. Include 24-hour contact number."
            ),
            DocumentChecklistItem(
                title: "Pre-Trip Inspection Record",
                description: "Documented visual inspection of battery connections, mounting hardware, ventilation, and safety systems before transport."
            )
        ]
    }
}
