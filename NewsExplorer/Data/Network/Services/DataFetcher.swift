//
//  DataFetcher.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation

final class DataFetcher: Fetcher {

    func fetchData<T: Decodable>(of type: T.Type, with url: URL) async -> Result<T, Error> {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(error)
        }
    }

}

