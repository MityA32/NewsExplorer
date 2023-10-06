//
//  Fetcher.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation

protocol Fetcher {
    func fetchData<T: Decodable>(of type: T.Type, with url: URL) async -> Result<T, Error>
}
