//
//  API.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/8.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import Alamofire
import UIKit

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
    /// park
    var park: TokyoDisneyPark { get }
}

extension Requestable {
    func asURLRequest() throws -> URLRequest {
        let urlString = NetworkConstants.version + NetworkConstants.language + park.apiComponent + path
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
        RequestCounter.shared.add()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return Alamofire.SessionManager.default
            .request(self)
            .validate()
            .responseData(queue: .main,
                          completionHandler: { response in
                            RequestCounter.shared.minus()
                            if RequestCounter.shared.isEmpty {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
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

class RequestCounter {
    static let shared = RequestCounter()

    private var value = 0
    var isEmpty: Bool {
        return value == 0
    }

    private init() {
    }

    func add() {
        value += 1
    }

    func minus() {
        if value > 0 {
            value -= 1
        } else {
            value = 0
        }
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

        var park: TokyoDisneyPark {
            switch self {
            case .tags:
                return .land
            }
        }
    }
}

extension API {
    enum Attractions: Requestable {
        case list(park: TokyoDisneyPark)
        case detail(park: TokyoDisneyPark, id: String)
        case hot(park: TokyoDisneyPark)

        var path: String {
            switch self {
            case .list:
                return "attractions"
            case .detail(_, let id):
                return "attractions/\(id)"
            case .hot:
                return "attractions"
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
            case.hot:
                return ["sort": "hot"]
            default:
                return nil
            }
        }

        var park: TokyoDisneyPark {
            switch self {
            case .list(let _park):
                return _park
            case .detail(let _park, _):
                return _park
            case .hot(let _park):
                return _park
            }
        }
    }
}

extension API {
    enum Suggestion: Requestable {
        case list(park: TokyoDisneyPark)

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

        var park: TokyoDisneyPark {
            switch self {
            case .list(let _park):
                return _park
            }
        }
    }
}
