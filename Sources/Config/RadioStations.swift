import Foundation

struct RadioStation: Identifiable, Hashable {
    let id: String
    let name: String
    let city: String
    let streamURL: URL?

    static let all: [RadioStation] = [
        .init(id: "hanoi", name: "VOV Giao thông Hà Nội", city: "Hà Nội", streamURL: nil),
        .init(id: "hcm", name: "VOV Giao thông TP.HCM", city: "TP. Hồ Chí Minh", streamURL: nil),
        .init(id: "mekong", name: "VOV Mekong", city: "Đồng bằng sông Cửu Long", streamURL: nil),
        .init(id: "duyenhai", name: "VOV Duyên Hải", city: "Duyên Hải", streamURL: nil)
    ]
}