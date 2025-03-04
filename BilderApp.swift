import SwiftUI
import Firebase

@main
struct BilderApp: App {
    // Attach the AppDelegate to handle URL callbacks
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }
        
    var body: some Scene {
        WindowGroup {
            // Embed in a NavigationView so our NavigationLinks work
            NavigationView {
                ContentView()
            }
        }
    }
}

