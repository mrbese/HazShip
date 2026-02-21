import SwiftUI

// MARK: - HazShip Design System

struct HazTheme {
    // MARK: Colors
    static let navy = Color(red: 0.04, green: 0.09, blue: 0.16)         // #0A1628
    static let darkNavy = Color(red: 0.02, green: 0.05, blue: 0.10)     // #050D1A
    static let hazardOrange = Color(red: 1.0, green: 0.42, blue: 0.21)  // #FF6B35
    static let warningYellow = Color(red: 1.0, green: 0.80, blue: 0.0)  // #FFCC00
    static let dangerRed = Color(red: 0.95, green: 0.23, blue: 0.23)    // #F23B3B
    static let safeGreen = Color(red: 0.20, green: 0.78, blue: 0.35)    // #34C759
    static let surfaceLight = Color(red: 0.11, green: 0.16, blue: 0.25) // #1C2940
    static let surfaceMid = Color(red: 0.08, green: 0.12, blue: 0.20)   // #141F33
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let textMuted = Color(white: 0.45)

    // MARK: Gradients
    static let heroGradient = LinearGradient(
        colors: [hazardOrange, Color(red: 0.85, green: 0.30, blue: 0.15)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let prohibitedGradient = LinearGradient(
        colors: [dangerRed, Color(red: 0.70, green: 0.10, blue: 0.10)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        colors: [darkNavy, navy],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: Card Style
    static func cardBackground() -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(surfaceLight.opacity(0.6))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }

    // MARK: Section Header
    static func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(hazardOrange)
            Text(title.uppercased())
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(textSecondary)
                .tracking(1.5)
            Spacer()
        }
    }
}

// MARK: - View Modifiers

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(HazTheme.surfaceLight.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
    }
}

extension View {
    func hazCard() -> some View {
        modifier(CardModifier())
    }
}

// MARK: - Severity Color Helper

extension RestrictionSeverity {
    var color: Color {
        switch self {
        case .info: return HazTheme.safeGreen
        case .warning: return HazTheme.warningYellow
        case .prohibited: return HazTheme.dangerRed
        }
    }
}
