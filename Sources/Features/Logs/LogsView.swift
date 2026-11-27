import SwiftUI

struct LogsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "list.bullet.rectangle").font(.system(size: 44)).foregroundStyle(.orange)
                Text("Chưa có nhật ký").font(.title3.bold())
                Text("Nhật ký tải và phát sẽ được ghi tại đây trong giai đoạn tiếp theo.")
                    .multilineTextAlignment(.center).foregroundStyle(.secondary)
            }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Nhật ký")
        }
    }
}