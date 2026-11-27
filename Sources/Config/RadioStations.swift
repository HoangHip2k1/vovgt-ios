import Foundation

struct RadioStation: Identifiable, Hashable {
    let id: String
    let name: String
    let city: String
    let streamURL: URL?

    static let all: [RadioStation] = [
        .init(
            id: "hanoi",
            name: "VOV Giao thông Hà Nội",
            city: "Hà Nội",
            streamURL: URL(string: "https://play.vovgiaothong.vn/live/gthn/playlist.m3u8")
        ),
        .init(
            id: "hcm",
            name: "VOV Giao thông TP.HCM",
            city: "TP. Hồ Chí Minh",
            streamURL: URL(string: "https://play.vovgiaothong.vn/live/gthcm/playlist.m3u8")
        ),
        .init(
            id: "mekong",
            name: "VOV Mekong",
            city: "Đồng bằng sông Cửu Long",
            streamURL: URL(string: "https://play.vovgiaothong.vn/live/mekong/playlist.m3u8")
        ),
        .init(
            id: "duyenhai",
            name: "VOV Duyên Hải",
            city: "Duyên Hải",
            streamURL: URL(string: "https://play.vovgiaothong.vn/live/duyenhai2/playlist.m3u8")
        )
    ]
}
