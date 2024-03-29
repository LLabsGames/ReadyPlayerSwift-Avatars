//
//  ReadyPlayerSwift.swift
//  ReadyPlayerSwift
//
//  Created by LLabs Games on 10.01.2024.
//

import ReadyPlayerSwift
#if canImport(Foundation)
import Foundation
#endif

// Paste your X-Api-Key from ReadyPlayerMe Studio here
let key = ""

// Set image type to .jpg
DefaultAvatarValues.kImageFormat = .jpg

// Link to your cool .glb avatar model
let randomUrl = "https://models.readyplayer.me/6361baf427dd6d429df5b5db.glb"

// Configure resulting image parameters
let sampleConfig = AvatarParameters(expression: .lol, camera: .fullbody, pose: .powerStance, apiKey: key)

// Not allowing sample process to finish earlier that completion is processed.
let semaphore = DispatchSemaphore(value: 0)

// Calling library function.
RPM.avatarFromUrl(randomUrl, config: sampleConfig) { imageData, error in
    if let safeData = imageData {
        print(safeData)
    } else if let safeError = error {
        print(safeError)
    }
    semaphore.signal()
}

// Waiting for results to arrive.
semaphore.wait()
