//
//  Structs.swift
//  ReadyPlayerSwift
//
//  Created by LLabs Games on 10.01.2024.
//

public struct DefaultAvatarValues {
    static public let kDefaultSize:     Int = 1024 // 256 / 512 / 1024 - Pixels;
    static public let kDefaultQuality:  Int = 100  // Zero to 100 - Quality value;
    static public let kTimeOutInterval: Int = 60   // Any value - Seconds.
    static public let kUrlBase: String = "models.readyplayer.me"
    static public let kGetMethodName: String = "GET"
    static public let kRetryLimit: Int = 1
}

public struct AvatarParameters: Codable {
    let apiKey: String?            // X-API-Key from Studio;
    let expression: Expression?    // Avatar facial expression;
    let pose: Pose?                // Avatars pose
    let blendShapes: [BlendShape]? // Map of 3D meshes to their blend shapes;
    let camera: Camera?            // Camera preset;
    let quality: Int               // Image compression quality;
    let size: Int                  // Image width and height;
    let background: RGBColor?      // Background color value;
    let uat: String?               // User Avatar Timestamp;
    let cacheControl: Bool?        // Uses custom Cache-Control header.
    
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
        self.background    = background
        self.apiKey        = apiKey
        self.uat           = nil
        self.cacheControl  = nil
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
            background = try values.decodeIfPresent(RGBColor.self, forKey: .background)
            expression = try values.decodeIfPresent(Expression.self, forKey: .expression)
            uat = try values.decodeIfPresent(String.self, forKey: .uat)
            blendShapes = try values.decodeIfPresent([BlendShape].self, forKey: .blendShapes)
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
