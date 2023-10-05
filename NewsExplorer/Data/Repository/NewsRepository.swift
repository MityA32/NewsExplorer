//
//  NewsRepository.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation

final class NewsRepository: NSObject, Repository {
    
    typealias T = PieceOfNewsModel
    let fetcher: Fetcher
    private(set) var data = [PieceOfNewsModel]()
    
    init(fetcher: Fetcher) {
        self.fetcher = fetcher
    }
    
    func getPortion(topic: String = "popular", number: Int = 1, sortByOption: SortByOption = .publishedAt) async -> Result<[PieceOfNewsModel], Error> {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(topic)&sortBy=\(sortByOption.rawValue)&pageSize=15&page=\(number)&apiKey=5c87c4f6c51d4fd288664884ecbd3fd6") else { return .failure(NSError()) }
        switch await fetcher.fetchData(of: NewsModel.self, with: url) {
            case .success(let news):
                if number < 2 {
                    data = []
                }
                data += news.articles
                return .success(news.articles)
            case .failure(let error):
                return .failure(error)
        }
    }

}


