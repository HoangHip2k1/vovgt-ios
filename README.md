# VOV Giao Thông+ for iOS

SwiftUI iOS app foundation for VOV traffic radio and related content.

## Current implementation
- Six-tab SwiftUI shell: Live, Schedule, VOV, Downloads, Logs, Account.
- AVPlayer-based HLS radio playback.
- Four configurable VOV traffic stations.
- Audio playback session configured for background audio.
- Lock Screen / Control Center play, pause, toggle and stop commands.
- Now Playing metadata.
- Audio interruption handling and buffering/error states.
- Volume and mute controls in the Live screen.
- GitHub Actions workflow to build an unsigned IPA on macOS.

## Important status
This is an early development build, not a release-ready app. The radio URLs are sourced from publicly listed VOV stream references, but have **not yet been verified by playback on a physical iPhone**. Schedule data is sample content. VOV Media authentication, content search, downloads and offline playback are not yet integrated.

## Technology
- Swift 5.9, SwiftUI, AVFoundation, AVKit
- AVPlayer / HLS
- AVAudioSession and MediaPlayer remote commands
- XcodeGen
- GitHub Actions (macOS runner)

## Build locally
Install Xcode and XcodeGen:
```sh
brew install xcodegen
xcodegen generate
open VOVGiaoThong.xcodeproj
```
Choose a valid signing team in Xcode to install directly from Xcode.

## GitHub Actions IPA
The workflow `.github/workflows/ios-unsigned-ipa.yml` builds an unsigned IPA. An unsigned IPA cannot be installed directly on iPhone. It must be signed/installed with a supported sideloading workflow such as SideStore. A free Apple Personal Team signing profile has a 7-day validity limit.

## Stream configuration
Edit `Sources/Config/RadioStations.swift`. The current stream paths are:
- Hanoi: `https://play.vovgiaothong.vn/live/gthn/playlist.m3u8`
- Ho Chi Minh City: `https://play.vovgiaothong.vn/live/gthcm/playlist.m3u8`
- Mekong: `https://play.vovgiaothong.vn/live/mekong/playlist.m3u8`
- Duyen Hai: `https://play.vovgiaothong.vn/live/duyenhai2/playlist.m3u8`

These endpoints are public references and should be checked for availability, playback rights and stability before release.

## Next milestones
1. Verify all streams on iPhone and add robust reconnect behavior.
2. Replace sample schedule with an official data source.
3. Integrate VOV content browsing and authentication after API/terms verification.
4. Implement downloads, persistence and offline playback where permitted.
5. Add automated tests and validate signed IPA installation.
