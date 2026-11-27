import Foundation

enum DownloadStatus: String, Codable {
    case queued, downloading, paused, completed, failed, cancelled
}

struct DownloadTask: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var sourceURL: URL
    var status: DownloadStatus = .queued
    var progress: Double = 0
    var localFileName: String?
}