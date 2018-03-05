//
//  ImageAccess.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/19.
//  Copyright © 2018 ebuser. All rights reserved.
//

import Alamofire

struct ImageAccessUrl: URLRequestConvertible {

    let urlRequest: URLRequest

    init?(url: URL) {
        let headers = [
            "Host": url.host ?? "media1.tokyodisneyresort.jp",
            "Connection": "keep-alive",
            "Pragma": "no-cache",
            "Cache-Control": "no-cache",
            "Upgrade-Insecure-Requests": "1",
            "Accept": "text/html,image/jpeg",
            "Accept-Encoding": "gzip, deflate",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36"
        ]
        do {
            try urlRequest = URLRequest(url: url,
                                        method: .get,
                                        headers: headers)
        } catch {
            return nil
        }
    }

    init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }

    func asURLRequest() throws -> URLRequest {
        return urlRequest
    }

}
