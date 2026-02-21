import SwiftUI

struct DocumentChecklistSection: View {
    @State var documents: [DocumentChecklistItem]

    init(documents: [DocumentChecklistItem]) {
        _documents = State(initialValue: documents)
    }

    var completedCount: Int {
        documents.filter(\.isCompleted).count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HazTheme.sectionHeader("Documentation Checklist", icon: "checklist")
                Spacer()
                Text("\(completedCount)/\(documents.count)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(completedCount == documents.count ? HazTheme.safeGreen : HazTheme.textSecondary)
            }

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(HazTheme.surfaceMid)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(completedCount == documents.count ? HazTheme.safeGreen : HazTheme.hazardOrange)
                        .frame(width: geo.size.width * (documents.isEmpty ? 0 : CGFloat(completedCount) / CGFloat(documents.count)), height: 6)
                        .animation(.spring(response: 0.3), value: completedCount)
                }
            }
            .frame(height: 6)

            ForEach(Array(documents.enumerated()), id: \.element.id) { index, doc in
                Button {
                    withAnimation(.spring(response: 0.2)) {
                        documents[index].isCompleted.toggle()
                    }
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: doc.isCompleted ? "checkmark.square.fill" : "square")
                            .font(.system(size: 18))
                            .foregroundStyle(doc.isCompleted ? HazTheme.safeGreen : HazTheme.textSecondary)
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(doc.title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(doc.isCompleted ? HazTheme.textMuted : HazTheme.textPrimary)
                                .strikethrough(doc.isCompleted, color: HazTheme.textMuted)
                            Text(doc.description)
                                .font(.system(size: 11))
                                .foregroundStyle(HazTheme.textMuted)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.vertical, 4)
                }

                if index < documents.count - 1 {
                    Divider()
                        .background(Color.white.opacity(0.06))
                }
            }
        }
        .hazCard()
    }
}
