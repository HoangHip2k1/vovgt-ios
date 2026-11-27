import SwiftUI

struct VOVBrowserView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Image(systemName: "dot.radiowaves.left.and.right").font(.system(size: 48)).foregroundStyle(.orange)
                Text("Nội dung VOV").font(.title2.bold())
                Text("Khu vực này sẽ kết nối nguồn VOV Nghe chính thức sau khi xác minh URL, API và quyền truy cập. Không sử dụng endpoint chưa được kiểm chứng.")
                    .multilineTextAlignment(.center).foregroundStyle(.secondary).padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationTitle("VOV")
        }
    }
}