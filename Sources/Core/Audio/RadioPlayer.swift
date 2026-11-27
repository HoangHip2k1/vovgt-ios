import Foundation
import AVFoundation

@MainActor
final class RadioPlayer: ObservableObject {
    static let shared = RadioPlayer()

    @Published private(set) var isPlaying = false
    @Published private(set) var currentStation: RadioStation?
    @Published private(set) var errorMessage: String?

    private var player: AVPlayer?

    private init() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            errorMessage = "Không thể cấu hình audio session: \(error.localizedDescription)"
        }
    }

    func play(_ station: RadioStation) {
        guard let url = station.streamURL else {
            errorMessage = "Chưa cấu hình URL stream chính thức cho \(station.city)."
            return
        }
        currentStation = station
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
        errorMessage = nil
    }

    func togglePlayback() {
        guard let player else { return }
        if isPlaying { player.pause() } else { player.play() }
        isPlaying.toggle()
    }

    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
    }
}