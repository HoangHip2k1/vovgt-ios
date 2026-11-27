import SwiftUI

@main
struct VOVGiaoThongApp: App {
    @StateObject private var audioPlayer = RadioPlayer.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(audioPlayer)
                .preferredColorScheme(.dark)
        }
    }
}