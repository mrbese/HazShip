import SwiftUI

@main
struct HazShipApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                InputFormView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
