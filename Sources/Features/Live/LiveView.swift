import SwiftUI

struct LiveView: View {
    @EnvironmentObject private var audio: RadioPlayer

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("VOV GIAO THÔNG+").font(.caption.weight(.bold)).foregroundStyle(.orange)
                        Text("Radio trực tiếp").font(.largeTitle.bold())
                        Text("Cập nhật giao thông và thông tin trên các cung đường.")
                            .foregroundStyle(.secondary)
                    }.padding(.top, 12)

                    ForEach(RadioStation.all) { station in
                        Button { audio.play(station) } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "dot.radiowaves.left.and.right")
                                    .font(.title2).foregroundStyle(.orange)
                                    .frame(width: 52, height: 52)
                                    .background(.orange.opacity(0.13), in: RoundedRectangle(cornerRadius: 14))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(station.name).font(.headline).foregroundStyle(.primary)
                                    Text(station.city).font(.subheadline).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: audio.currentStation?.id == station.id && audio.isPlaying ? "speaker.wave.2.fill" : "play.fill")
                                    .foregroundStyle(.orange)
                            }
                            .padding(14)
                            .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18))
                        }.buttonStyle(.plain)
                    }

                    if let message = audio.errorMessage {
                        Text(message).font(.footnote).foregroundStyle(.yellow)
                    }
                    if let station = audio.currentStation {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("ĐANG PHÁT").font(.caption.bold()).foregroundStyle(.orange)
                                Text(station.name).font(.headline)
                            }
                            Spacer()
                            Button { audio.togglePlayback() } label: {
                                Image(systemName: audio.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.title2).frame(width: 48, height: 48)
                                    .background(.orange, in: Circle()).foregroundStyle(.black)
                            }
                        }.padding().background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
                    }
                }.padding()
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
    }
}