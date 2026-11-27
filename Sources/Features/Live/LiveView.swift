import SwiftUI

struct LiveView: View {
    @EnvironmentObject private var audio: RadioPlayer

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header

                    VStack(spacing: 12) {
                        ForEach(RadioStation.all) { station in
                            stationRow(station)
                        }
                    }

                    if let station = audio.currentStation {
                        playerCard(for: station)
                    }

                    if let message = audio.errorMessage {
                        Label(message, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(.yellow)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.yellow.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
                    }

                    Text("Chất lượng phát phụ thuộc vào kết nối mạng và máy chủ phát sóng.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .foregroundStyle(.orange)
                Text("VOV GIAO THÔNG+")
                    .font(.caption.weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(.orange)
            }
            Text("Radio trực tiếp")
                .font(.largeTitle.bold())
            Text("Lắng nghe thông tin giao thông trên các cung đường.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 12)
    }

    private func stationRow(_ station: RadioStation) -> some View {
        let selected = audio.currentStation?.id == station.id

        return Button {
            audio.play(station)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.orange.opacity(0.13))
                        .frame(width: 54, height: 54)
                    Image(systemName: selected && audio.isPlaying ? "dot.radiowaves.left.and.right" : "radio")
                        .font(.title2)
                        .foregroundStyle(.orange)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(station.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(station.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if selected {
                        Text(audio.isPlaying ? "ĐANG PHÁT" : (audio.isBuffering ? "ĐANG KẾT NỐI…" : "ĐANG CHỌN"))
                            .font(.caption2.bold())
                            .foregroundStyle(.orange)
                    }
                }

                Spacer()

                if selected && audio.isBuffering {
                    ProgressView().tint(.orange)
                } else {
                    Image(systemName: selected && audio.isPlaying ? "speaker.wave.2.fill" : "play.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
            }
            .padding(14)
            .background(selected ? Color.orange.opacity(0.12) : Color.white.opacity(0.055),
                        in: RoundedRectangle(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(selected ? Color.orange.opacity(0.55) : Color.white.opacity(0.06), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Phát \(station.name)")
    }

    private func playerCard(for station: RadioStation) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("ĐANG NGHE")
                        .font(.caption.bold())
                        .tracking(1.2)
                        .foregroundStyle(.orange)
                    Text(station.name)
                        .font(.headline)
                }
                Spacer()
                if audio.isBuffering {
                    ProgressView().tint(.orange)
                } else {
                    Circle()
                        .fill(audio.isPlaying ? Color.green : Color.gray)
                        .frame(width: 9, height: 9)
                }
            }

            HStack(spacing: 18) {
                Button {
                    audio.togglePlayback()
                } label: {
                    Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                        .frame(width: 58, height: 58)
                        .background(.orange, in: Circle())
                }
                .accessibilityLabel(audio.isPlaying ? "Tạm dừng" : "Tiếp tục phát")

                VStack(alignment: .leading, spacing: 4) {
                    Text(audio.isBuffering ? "Đang tải luồng…" : (audio.isPlaying ? "Đang phát trực tiếp" : "Đã tạm dừng"))
                        .font(.subheadline.weight(.semibold))
                    Text("Âm thanh trực tuyến")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    audio.stop()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .frame(width: 42, height: 42)
                }
                .accessibilityLabel("Dừng phát")
            }

            HStack(spacing: 12) {
                Button { audio.toggleMute() } label: {
                    Image(systemName: audio.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .foregroundStyle(.secondary)
                        .frame(width: 24)
                }
                .accessibilityLabel(audio.isMuted ? "Bật âm thanh" : "Tắt tiếng")

                Slider(
                    value: Binding(
                        get: { Double(audio.volume) },
                        set: { audio.setVolume(Float($0)) }
                    ),
                    in: 0...1
                )
                .tint(.orange)
                .disabled(audio.isMuted)

                Text("\(Int(audio.volume * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(width: 38, alignment: .trailing)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.orange.opacity(0.22), lineWidth: 1)
        }
    }
}
