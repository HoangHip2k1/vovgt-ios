import SwiftUI

struct ScheduleItem: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let channel: String
    let detail: String
}

struct ScheduleView: View {
    @State private var searchText = ""
    @State private var selectedDate = Date()
    private let samples = [
        ScheduleItem(time: "06:00", title: "Tin tức giao thông buổi sáng", channel: "Hà Nội", detail: "Dữ liệu minh họa — cần đồng bộ lịch chính thức."),
        ScheduleItem(time: "07:00", title: "Giao thông giờ cao điểm", channel: "TP.HCM", detail: "Dữ liệu minh họa — cần đồng bộ lịch chính thức."),
        ScheduleItem(time: "17:00", title: "Kết nối hành trình", channel: "Mekong", detail: "Dữ liệu minh họa — cần đồng bộ lịch chính thức.")
    ]

    var body: some View {
        NavigationStack {
            List {
                DatePicker("Ngày phát", selection: $selectedDate, displayedComponents: .date)
                ForEach(samples.filter { searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText) }) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.time).font(.headline.monospacedDigit()).foregroundStyle(.orange)
                            Text(item.title).font(.headline)
                        }
                        Text(item.channel).font(.caption).foregroundStyle(.secondary)
                        Text(item.detail).font(.caption2).foregroundStyle(.secondary)
                    }.padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Tìm chương trình")
            .navigationTitle("Lịch phát")
        }
    }
}