//
//  Structs.swift
//  ReadyPlayerSwift
//
//  Created by LLabs Games on 10.01.2024.
//

public struct DefaultAvatarValues {
    static public var kDefaultSize:     Int = 1024 // 256 / 512 / 1024 - Pixels;
    static public var kDefaultQuality:  Int = 100  // Zero to 100 - Quality value;
    static public var kTimeOutInterval: Int = 60   // Any value - Seconds.
    static public var kUrlBase: String = "models.readyplayer.me"
    static public var kGetMethodName: String = "GET"
    static public var kImageFormat: AvatarFormat = .png
    static public var kBackgroundColor: RGBColor? = .firm
    static public var kRetryLimit: Int = 1
}

public struct AvatarParameters: Codable {
    public let apiKey: String?            // X-API-Key from Studio;
    public let format: AvatarFormat?
    public let expression: Expression?    // Avatar facial expression;
    public let pose: Pose?                // Avatars pose
    public let blendShapes: [BlendShape]? // Map of 3D meshes to their blend shapes;
    public let camera: Camera?            // Camera preset;
    public let quality: Int               // Image compression quality;
    public let size: Int                  // Image width and height;
    public let background: String?        // Background color value;
    public let uat: String?               // User Avatar Timestamp;
    public let cacheControl: Bool?        // Uses custom Cache-Control header.
    
    public enum CodingKeys: String, CodingKey {
        case cacheControl, pose, camera, size, quality
        case background, expression, uat, blendShapes
    }
    
    public init(expression: Expression? = nil, camera: Camera? = nil,
            quality: Int = DefaultAvatarValues.kDefaultQuality,
               size: Int = DefaultAvatarValues.kDefaultSize,
               pose: Pose? = nil,  background: RGBColor? = nil,
        blendShapes: [BlendShape]? = nil, apiKey: String) {
        self.expression    = expression
        self.pose          = pose
        self.blendShapes   = blendShapes
        self.camera        = camera
        self.quality       = quality
        self.size          = size
        self.background    = background?.rawValue
        self.apiKey        = apiKey
        self.uat           = nil
        self.cacheControl  = nil
        self.format        = DefaultAvatarValues.kImageFormat
    }
    
    public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            apiKey = nil
            cacheControl = try values.decodeIfPresent(Bool.self, forKey: .cacheControl)
            pose = try values.decodeIfPresent(Pose.self, forKey: .pose)
            camera = try values.decodeIfPresent(Camera.self, forKey: .camera)
            size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DefaultAvatarValues.kDefaultSize
            quality = try values.decodeIfPresent(Int.self, forKey: .quality) ?? DefaultAvatarValues.kDefaultQuality
            background = try values.decodeIfPresent(String.self, forKey: .background)
            expression = try values.decodeIfPresent(Expression.self, forKey: .expression)
            uat = try values.decodeIfPresent(String.self, forKey: .uat)
            blendShapes = try values.decodeIfPresent([BlendShape].self, forKey: .blendShapes)
            format = DefaultAvatarValues.kImageFormat
        } catch {
            fatalError("🚨 AvatarParameters init from decoder error: \(error.localizedDescription)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(expression,   forKey: .expression)
        try container.encodeIfPresent(pose,         forKey: .pose)
        try container.encodeIfPresent(blendShapes,  forKey: .blendShapes)
        try container.encodeIfPresent(camera,       forKey: .camera)
        try container.encodeIfPresent(quality,      forKey: .quality)
        try container.encodeIfPresent(size,         forKey: .size)
        try container.encodeIfPresent(background,   forKey: .background)
        try container.encodeIfPresent(uat,          forKey: .uat)
        try container.encodeIfPresent(cacheControl, forKey: .cacheControl)
    }
}
