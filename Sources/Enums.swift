//
//  Enums.swift
//  ReadyPlayerSwift
//
//  Created by LLabs Games on 10.01.2024.
//

public enum Expression: String, Codable, CaseIterable {
    case happy, lol, sad, scared, rage
}

public enum Pose: String, Codable, CaseIterable {
    case standing    = "standing"
    case powerStance = "power-stance"
    case relaxed     = "relaxed"
    case thumbsUp    = "thumbs-up"
}

public enum Camera: String, Codable, CaseIterable {
    case portrait, fullbody
}

public enum RGBColor: Codable, CaseIterable {
    public typealias RawValue = String
    
    case rgb(r: Int, g: Int, b: Int)
    case firm   //  43,  46,  57 - RPM Firm Color
    case violet // 148,   0, 211 - #9400D3
    case indigo //  75,   0, 130 - #4B0082
    case blue   //   0,   0, 255 - #0000FF
    case green  //   0, 255,   0 - #00FF00
    case yellow // 255, 255,   0 - #FFFF00
    case orange // 255, 127,   0 - #FF7F00
    case red    // 255,   0,   0 - #FF0000
    case white  // 255, 255, 255 - #FFFFFF
    case black  //   0,   0,   0 - #000000
    
    public var rawValue: RawValue {
        switch self {
        case .rgb(let r, let g, let b):
            return "\(  r),\(  g),\(  b)"
        case .firm:
            return "\( 43),\( 46),\( 57)"
        case .violet:
            return "\(148),\(  0),\(211)"
        case .indigo:
            return "\( 75),\(  0),\(130)"
        case .blue:
            return "\(  0),\(  0),\(255)"
        case .green:
            return "\(  0),\(255),\(  0)"
        case .yellow:
            return "\(255),\(255),\(  0)"
        case .orange:
            return "\(255),\(127),\(  0)"
        case .red:
            return "\(255),\(  0),\(  0)"
        case .white:
            return "\(255),\(255),\(255)"
        case .black:
            return "\(  0),\(  0),\(  0)"
        }
    }
    
    static public var allCases: [RGBColor] {
        return [.firm, .white, .black, .red, .orange, .yellow, .green, .blue, .indigo, .violet]
    }
}

public enum BlendShape: Codable {
    public typealias RawValue = String
    
    case shape(name: String, value: Float)
    
    public var rawValue: RawValue {
        switch self {
        case .shape(let name, let value):
            return "blendShapes[\(name)]=" + String(format: "%.1f", value)
        }
    }
}

public enum AvatarFormat: String, Codable, CaseIterable {
    case png, jpg
}

public enum RpmError: Error {
    case configEncodingError
    case urlBuildingError
    case failedJSONSerialization
    case percentEncodedQueryIsNil
    case requesHittedRetryAttemptsLimit
    case unknownApiResponse
}
