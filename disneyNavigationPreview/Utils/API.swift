//
//  API.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/8.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Alamofire

struct NetworkConstants {

    static let hostString = "https://api.dev.genbatomo.com/"
    static let hostURL = URL(string: hostString)

    static let rawVersion = "v1"
    static let version = rawVersion + "/"

    static var language: String = {

        guard let syslang = NSLocale.preferredLanguages.first else {
            return "en/"
        }

        if syslang.hasPrefix("ja") {
            return "ja/"
        } else if syslang.hasPrefix("zh-Hant") {
            return "tw/"
        } else if syslang.hasPrefix("zh-Hans") {
            return "cn/"
        } else {
            return "en/"
        }

    }()

    static let park = "land/"
}

/**
 HTTP method definitions.

 See https://tools.ietf.org/html/rfc7231#section-4.3
 */
enum RequestMethod: String {
    case OPTIONS
    case GET
    case HEAD
    case POST
    case PUT
    case PATCH
    case DELETE
    case TRACE
    case CONNECT
}

enum APIError: Error {
    case objectSerialization(reason: String)
}

protocol Requestable: URLRequestConvertible {
    /// url path
    var path: String { get }
    /// Method
    var method: RequestMethod { get }
    /// Parameters
    var parameters: [String: Any]? { get }
}

extension Requestable {
    func asURLRequest() throws -> URLRequest {
        let urlString = NetworkConstants.version + NetworkConstants.language + NetworkConstants.park + path
        guard let url = URL(string: urlString, relativeTo: NetworkConstants.hostURL) else {
            throw URLError(URLError.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 30
        switch method {
        case .GET:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }

    @discardableResult
    func request<T>(_ type: T.Type, completionHandler: @escaping (T?, Error?) -> Void) -> Request where T: Decodable {
        return Alamofire.SessionManager.default
            .request(self)
            .validate()
            .responseData(completionHandler: { response in
                guard let data = response.data else {
                    let error = APIError.objectSerialization(reason: "No data in response")
                    completionHandler(nil, error)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, error)
                }
            })
    }
}

struct API {
}

extension API {
    enum Visitor: Requestable {
        case tags

        var path: String {
            switch self {
            case .tags:
                return "visitor/tags"
            }
        }

        var method: RequestMethod {
            switch self {
            case .tags:
                return .GET
            }
        }

        var parameters: [String : Any]? {
            switch self {
            case .tags:
                return nil
            }
        }
    }
}

extension API {
    enum Attractions: Requestable {
        case list
        case detail(id: String)

        var path: String {
            switch self {
            case .list:
                return "attractions"
            case .detail(let id):
                return "attractions/\(id)"
            }
        }

        var method: RequestMethod {
            switch self {
            default:
                return .GET
            }
        }

        var parameters: [String : Any]? {
            switch self {
            default:
                return nil
            }
        }
    }
}

extension API {
    enum Suggestion: Requestable {
        case list

        var path: String {
            switch self {
            case .list:
                return "plans"
            }
        }

        var method: RequestMethod {
            switch self {
            default:
                return .GET
            }
        }

        var parameters: [String : Any]? {
            switch self {
            default:
                return nil
            }
        }
    }
}
