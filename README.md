<p align="center">
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.8.1+-orange.svg" alt="Swift Version" /></a>
    <a href="https://swift.org/download/"><img src="https://img.shields.io/badge/Available-SPM-orange.svg" alt="Platform" /></a>
</p>

# ReadyPlayerSwift

ReadyPlayerSwift is a Swift package that is providing a wrapper for Ready Player Me [REST](https://docs.readyplayer.me/ready-player-me/api-reference/rest-api) [API](https://docs.readyplayer.me/ready-player-me/api-reference/rest-api). It simplifies the process of downloading 2D representations of 3D avatar models with various parameters. This package is compatible with any Swift-supported platform and is built using the Swift 5.8.1+ toolchain.

## Requirements

- iOS / iPadOS / macOS / tvOS / watchOS / Linux / Windows (Swift-compatible platforms)
- Swift 5.8.1+
- Xcode (latest AppStore version recommended)

## Installation

### Swift Package Manager

You can install ReadyPlayerSwift via [Swift](https://swift.org/package-manager/) [Package](https://swift.org/package-manager/) [Manager](https://swift.org/package-manager/) by adding it as a dependency to your `Package.swift` file:

```swift
// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "<Your Project Name>",
    dependencies: [
        .package(url: "https://github.com/LLabsGames/ReadyPlayerSwift-Avatars.git", from: "<version>")
    ],
    targets: [
        .target(
            name: "<Your Target Name>",
            dependencies: ["ReadyPlayerSwift"]),
        // other targets...
    ]
)
```
Replace `< ... >` with your project's specific details.

## Usage

Here's a quick example to get you started:
```
import ReadyPlayerSwift

// Set your API key and avatar URL
let apiKey = "<Your X-Api-Key>"
let avatarUrl = "<Your Avatar URL>"

// Configure avatar image parameters
let config = AvatarParameters(expression: .lol, camera: .fullbody, pose: .powerStance, apiKey: apiKey)

// Fetch and process the avatar
ReadyPlayerSwift.avatarFromUrl(avatarUrl, config: config) { imageData, error in
    if let data = imageData {
        // Handle the received image data
    } else if let err = error {
        // Handle the error
        print(err)
    }
}
```
Replace `< ... >` with your own API key and avatar URL.

## Contributing

Contributions are welcome. Please feel free to contribute by opening issues or submitting pull requests.

## License

ReadyPlayerSwift is available under [The](https://unlicense.org) [Unlicense](https://unlicense.org). See the LICENSE file for more info.
