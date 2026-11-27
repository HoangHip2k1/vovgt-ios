import SwiftUI

enum AppTab: String, CaseIterable {
    case live = "Trực tiếp"
    case schedule = "Lịch phát"
    case vov = "VOV"
    case downloads = "Tải xuống"
    case logs = "Nhật ký"
    case account = "Tài khoản"

    var symbol: String {
        switch self {
        case .live: return "dot.radiowaves.left.and.right"
        case .schedule: return "calendar"
        case .vov: return "play.rectangle"
        case .downloads: return "arrow.down.circle"
        case .logs: return "list.bullet.rectangle"
        case .account: return "person.crop.circle"
        }
    }
}

struct MainTabView: View {
    @State private var selection: AppTab = .live

    var body: some View {
        TabView(selection: $selection) {
            LiveView().tabItem { Label(AppTab.live.rawValue, systemImage: AppTab.live.symbol) }.tag(AppTab.live)
            ScheduleView().tabItem { Label(AppTab.schedule.rawValue, systemImage: AppTab.schedule.symbol) }.tag(AppTab.schedule)
            VOVBrowserView().tabItem { Label(AppTab.vov.rawValue, systemImage: AppTab.vov.symbol) }.tag(AppTab.vov)
            DownloadsView().tabItem { Label(AppTab.downloads.rawValue, systemImage: AppTab.downloads.symbol) }.tag(AppTab.downloads)
            LogsView().tabItem { Label(AppTab.logs.rawValue, systemImage: AppTab.logs.symbol) }.tag(AppTab.logs)
            AccountView().tabItem { Label(AppTab.account.rawValue, systemImage: AppTab.account.symbol) }.tag(AppTab.account)
        }
        .tint(.orange)
    }
}