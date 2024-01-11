//
//  ReadyPlayerSwift.swift
//  ReadyPlayerSwift
//
//  Created by LLabs Games on 10.01.2024.
//

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(Foundation)
import Foundation
#endif

//  REST API (https://docs.readyplayer.me/ready-player-me/api-reference/rest-api)
//
//  Access and authentication
//  All API access is sent over HTTPS and accessed from https://api.readyplayer.me.
//  To enable straightforward integration of Ready Player Me avatars, the GET avatar endpoints are publicly available and currently do not require authentication.
//  All other Endpoints require an API Key. See https://docs.readyplayer.me/ready-player-me/api-reference/rest-api/authentication.
//
//  Response codes
//  The Avatar API uses conventional HTTP response codes to indicate the success or failure of an API request.
//  Codes in the 2xx range indicate success.
//  Codes in the 4xx range indicate a failure given the information provided.
//  Codes in the 5xx range indicate an error with Ready Player Me services.
//  Timestamps return in UTC time.
//  Status Code
//  Description
//  200 - OK
//  Everything worked as expected.
//  400 - Bad Request
//  The request was unacceptable, often due to missing a required parameter.
//  401 - Unauthorized
//  Unauthorized request for a secured endpoint.
//  402 - Request Failed
//  The parameters were valid but the request failed.
//  403 - Forbidden
//  The authorized user doesn't have permission to perform the request.
//  404 - Not Found
//  The requested resource doesn't exist.
//  5xx - Server Errors
//  Something went wrong on Ready Player Me’s end.
//
//  Avatar file format
//  All 3D avatars are delivered in GLB format.
//  The API returns standardized .glb or .jpg/.png files for the 3D and 2D avatars, or JSON-encoded responses. Only default HTTP response codes are used.
//  GLB ​is a compressed binary version of a (JSON-based) GLTF file and includes all of the elements that comprise a 3D avatar model, such as materials, meshes, node hierarchy, and cameras. GLB files are compact, represent complete scenes, and load fast. You can read more about GLB and glTF https://docs.fileformat.com/3d/glb/.
//  Download a https://api.readyplayer.me/v1/avatars/6185a4acfb622cf1cdc49348.glb and open it in any 3D viewer or app to see the details.

public class RPM {
    public typealias RPMCompletion = (_ imageData: Data?, _ error: Error?) -> Void
    
    static private var dataTask: URLSessionDataTask?
    static private let session: URLSession = URLSession.shared
    static private var connectionLostRetryCount: Int = 0
    
    static public func avatarFromUrl(_ url: String, config: AvatarParameters, completion: @escaping RPMCompletion) {
        let pathComponents: [String] = url.components(separatedBy: "/")
        let lastComponent:   String  = pathComponents.last ?? url
        let nameComponents: [String] = lastComponent.components(separatedBy: ".")
        let nameComponent:   String  = nameComponents.first ?? lastComponent
        avatar(id: nameComponent, config: config, completion: completion)
    }
    
    static public func avatarFromId(_ avatarId: String, config: AvatarParameters, completion: @escaping RPMCompletion) {
        avatar(id: avatarId, config: config, completion: completion)
    }
    
    private static func avatar(id: String, config: AvatarParameters, completion: @escaping RPMCompletion) {
        let fileFormat = config.format?.rawValue ?? DefaultAvatarValues.kImageFormat.rawValue
        let apiUrlString: String = "https://\(DefaultAvatarValues.kUrlBase)/\(id).\(fileFormat)"
        do {
            let reqTimeout: TimeInterval = TimeInterval(DefaultAvatarValues.kTimeOutInterval)
            let policy: URLRequest.CachePolicy = .useProtocolCachePolicy
            let params: String = try RPM.queryString(from: config)
            let urlString: String = apiUrlString + params
            guard let URL: URL = URL(string: urlString) else { throw RpmError.urlBuildingError }
            #if DEBUG
            print(URL.absoluteString)
            #endif
            var request = URLRequest(url: URL, cachePolicy: policy, timeoutInterval: reqTimeout)
            request.httpMethod = DefaultAvatarValues.kGetMethodName
            if let key = config.apiKey {
                request.allHTTPHeaderFields = ["x-api-key": key]
            }
            RPM.dataTask = RPM.session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    if RPM.connectionLostRetryCount < DefaultAvatarValues.kRetryLimit {
                        RPM.connectionLostRetryCount += 1
                        RPM.avatar(id: id, config: config, completion: completion)
                    } else if RPM.connectionLostRetryCount >= DefaultAvatarValues.kRetryLimit {
                        RPM.connectionLostRetryCount = 0
                        completion(nil, RpmError.requesHittedRetryAttemptsLimit)
                    }
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                    completion(data, nil)
                } else {
                    completion(nil, RpmError.configEncodingError)
                }
            })
            if let task = RPM.dataTask {
                task.resume()
            }
        } catch {
            completion(nil, RpmError.configEncodingError)
        }
    }
    
    static private func queryString<T: Encodable>(from codableObject: T) throws -> String {
        // Encode the Codable object into Data
        let jsonData = try JSONEncoder().encode(codableObject)
        // Convert Data to a Dictionary
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let dictionary = jsonObject as? [String: Any] else { throw RpmError.failedJSONSerialization }
        // Convert Dictionary to URLQueryItem array
        let queryItems = dictionary.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        // Create a URLComponents object to use its queryItems property
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        // Return the percent-encoded query string
        if let query = urlComponents.percentEncodedQuery {
            return "?" + query
        } else {
            throw RpmError.percentEncodedQueryIsNil
        }
    }
}
