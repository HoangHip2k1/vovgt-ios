import Foundation
import AVFoundation
import MediaPlayer
import Combine

@MainActor
final class RadioPlayer: ObservableObject {
    static let shared = RadioPlayer()

    @Published private(set) var isPlaying = false
    @Published private(set) var isBuffering = false
    @Published private(set) var currentStation: RadioStation?
    @Published private(set) var errorMessage: String?
    @Published private(set) var volume: Float = 1.0
    @Published private(set) var isMuted = false

    private var player: AVPlayer?
    private var playerObservation: NSKeyValueObservation?
    private var itemObservation: NSKeyValueObservation?
    private var interruptionObserver: NSObjectProtocol?
    private var failedItemObserver: NSObjectProtocol?
    private var remoteCommandsConfigured = false

    private init() {
        configureAudioSession()
        configureAudioNotifications()
        configureRemoteCommands()
    }

    deinit {
        if let interruptionObserver {
            NotificationCenter.default.removeObserver(interruptionObserver)
        }
        if let failedItemObserver {
            NotificationCenter.default.removeObserver(failedItemObserver)
        }
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            errorMessage = "Không thể cấu hình âm thanh: \(error.localizedDescription)"
        }
    }

    private func configureAudioNotifications() {
        interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] notification in
            Task { @MainActor in
                self?.handleAudioInterruption(notification)
            }
        }

        failedItemObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            let message = (notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error)?.localizedDescription
            Task { @MainActor in
                self?.isPlaying = false
                self?.isBuffering = false
                self?.errorMessage = message ?? "Luồng phát đã bị gián đoạn."
                self?.updateNowPlayingInfo()
            }
        }
    }

    private func configureRemoteCommands() {
        guard !remoteCommandsConfigured else { return }
        remoteCommandsConfigured = true

        let center = MPRemoteCommandCenter.shared()
        center.playCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.resume() }
            return .success
        }
        center.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.pause() }
            return .success
        }
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.togglePlayback() }
            return .success
        }
        center.stopCommand.addTarget { [weak self] _ in
            Task { @MainActor in self?.stop() }
            return .success
        }
    }

    func play(_ station: RadioStation) {
        guard let url = station.streamURL,
              let scheme = url.scheme?.lowercased(),
              scheme == "https" || scheme == "http" else {
            errorMessage = "Kênh \(station.city) chưa có URL phát hợp lệ."
            return
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            errorMessage = "Không thể kích hoạt âm thanh: \(error.localizedDescription)"
            return
        }

        playerObservation = nil
        itemObservation = nil
        player?.pause()

        currentStation = station
        errorMessage = nil
        isPlaying = false
        isBuffering = true

        let item = AVPlayerItem(url: url)
        item.preferredForwardBufferDuration = 5
        let newPlayer = AVPlayer(playerItem: item)
        newPlayer.volume = isMuted ? 0 : volume
        newPlayer.automaticallyWaitsToMinimizeStalling = true
        player = newPlayer

        itemObservation = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard item.status == .failed else { return }
            let message = item.error?.localizedDescription ?? "Không thể tải luồng radio."
            Task { @MainActor in
                self?.isPlaying = false
                self?.isBuffering = false
                self?.errorMessage = message
                self?.updateNowPlayingInfo()
            }
        }

        playerObservation = newPlayer.observe(\.timeControlStatus, options: [.initial, .new]) { [weak self] player, _ in
            let status = player.timeControlStatus
            Task { @MainActor in
                self?.isPlaying = status == .playing
                self?.isBuffering = status == .waitingToPlayAtSpecifiedRate
                self?.updateNowPlayingInfo()
            }
        }

        updateNowPlayingInfo()
        newPlayer.play()
    }

    func togglePlayback() {
        isPlaying ? pause() : resume()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        isBuffering = false
        updateNowPlayingInfo()
    }

    func resume() {
        guard let player else { return }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            player.play()
            isBuffering = true
            errorMessage = nil
        } catch {
            errorMessage = "Không thể tiếp tục phát: \(error.localizedDescription)"
        }
    }

    func stop() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerObservation = nil
        itemObservation = nil
        isPlaying = false
        isBuffering = false
        currentStation = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    func setVolume(_ newValue: Float) {
        volume = min(max(newValue, 0), 1)
        isMuted = volume == 0
        player?.volume = isMuted ? 0 : volume
    }

    func toggleMute() {
        isMuted.toggle()
        player?.volume = isMuted ? 0 : volume
    }

    private func handleAudioInterruption(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let rawType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: rawType)
        else { return }

        switch type {
        case .began:
            player?.pause()
            isPlaying = false
            isBuffering = false
            updateNowPlayingInfo()
        case .ended:
            let rawOptions = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt ?? 0
            let options = AVAudioSession.InterruptionOptions(rawValue: rawOptions)
            if options.contains(.shouldResume) {
                resume()
            }
        @unknown default:
            break
        }
    }

    private func updateNowPlayingInfo() {
        guard let station = currentStation else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: station.name,
            MPMediaItemPropertyArtist: "VOV Giao thông",
            MPNowPlayingInfoPropertyIsLiveStream: true,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
    }
}
