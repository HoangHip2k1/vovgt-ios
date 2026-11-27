# VOV Giao Thông+ for iOS

SwiftUI foundation for an iOS radio and traffic-information app.

## Status
Foundation scaffold only. Live streaming, schedules, authenticated VOV Media content and downloads require verified official endpoints and permissions before production use.

## Stack
- SwiftUI, AVFoundation, AVPlayer
- Background audio via AVAudioSession
- XcodeGen project generation
- GitHub Actions unsigned IPA build

## Build
Install Xcode and XcodeGen, then:
```sh
brew install xcodegen
xcodegen generate
open VOVGiaoThong.xcodeproj
```

## Configure official streams
Edit Sources/Config/RadioStations.swift. Replace nil stream URLs only with verified official stream URLs. Do not guess endpoints.

## IPA
GitHub Actions builds an unsigned IPA. It must be signed/installed with a supported sideloading workflow. Unsigned IPA cannot be installed directly on iPhone.
