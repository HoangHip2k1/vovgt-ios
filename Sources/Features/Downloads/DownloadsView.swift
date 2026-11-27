import SwiftUI

@MainActor
final class DownloadQueue: ObservableObject {
    @Published var tasks: [DownloadTask] = []
}

struct DownloadsView: View {
    @StateObject private var queue = DownloadQueue()
    var body: some View {
        NavigationStack {
            Group {
                if queue.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.down.circle").font(.system(size: 44)).foregroundStyle(.orange)
                        Text("Chưa có nội dung tải").font(.title3.bold())
                        Text("Các chương trình được tải hợp lệ sẽ xuất hiện tại đây.")
                            .multilineTextAlignment(.center).foregroundStyle(.secondary)
                    }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(queue.tasks) { task in
                        VStack(alignment: .leading) {
                            Text(task.title).font(.headline)
                            Text(task.status.rawValue).font(.caption).foregroundStyle(.secondary)
                            ProgressView(value: task.progress)
                        }
                    }
                }
            }.navigationTitle("Tải xuống")
        }
    }
}