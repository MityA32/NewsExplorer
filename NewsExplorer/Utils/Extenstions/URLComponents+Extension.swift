//
//  URLComponents+Extension.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import Foundation

extension URLComponents {
    init(scheme: String = "https", host: String, path: [String], queries: [URLQueryItem]?) {
        self = URLComponents.init()
        self.scheme = scheme
        self.host = host
        var p = path
        p.insert("/", at: 0)
        self.path = NSString.path(withComponents: p)
        self.queryItems = queries
    }
}
