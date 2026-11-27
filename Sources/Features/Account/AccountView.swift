import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Tài khoản VOV Media") {
                    Label("Đăng nhập sẽ được tích hợp bằng WKWebView sau khi xác minh luồng xác thực chính thức.", systemImage: "person.crop.circle")
                }
                Section("Ứng dụng") {
                    LabeledContent("Phiên bản", value: "0.1.0 – Foundation")
                    LabeledContent("Nền tảng", value: "iOS 16 trở lên")
                }
            }.navigationTitle("Tài khoản")
        }
    }
}