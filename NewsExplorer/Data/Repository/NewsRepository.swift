//
//  NewsRepository.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation
import Combine

final class NewsRepository: NSObject, Repository {
    typealias T = PieceOfNewsModel
    let fetcher: Fetcher

    let inCustomNewsConfig = PassthroughSubject<NewsRequestConfig, Never>()
    let outNewsList = PassthroughSubject<Result<[PieceOfNewsModel], Error>, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(fetcher: Fetcher) {
        self.fetcher = fetcher
        super.init()
        
        inCustomNewsConfig
            .removeDuplicates()
            .sink(receiveValue: { [weak self] config in
                guard let self else { return }
                Task {
                    let result = await self.getPortion(
                        topic: config.topic,
                        from: config.startDate,
                        to: config.endDate,
                        sortByOption: config.sortOption,
                        pageNumber: config.pageNumber
                    )
                    self.outNewsList.send(result)
                }
            })
            .store(in: &cancellables)
    }
    
    func getPortion(topic: String, from startDate: Date?, to endDate: Date?, sortByOption: SortByOption, pageNumber: Int) async -> Result<[PieceOfNewsModel], Error> {
        let queryItems = [
            URLQueryItem(name: NewsApiQueryItems.q.rawValue, value: topic),
            URLQueryItem(name: NewsApiQueryItems.from.rawValue, value: startDate?.formatToISO8601()),
            URLQueryItem(name: NewsApiQueryItems.to.rawValue, value: endDate?.formatToISO8601()),
            URLQueryItem(name: NewsApiQueryItems.sortBy.rawValue, value: sortByOption.rawValue),
            URLQueryItem(name: NewsApiQueryItems.pageSize.rawValue, value: "15"),
            URLQueryItem(name: NewsApiQueryItems.page.rawValue, value: String(pageNumber)),
            URLQueryItem(name: NewsApiQueryItems.apiKey.rawValue, value: APIKeys.newsApi),
        ]

        let urlWithComponents = URLComponents(
            host: "newsapi.org",
            path: ["v2", "everything"],
            queries: queryItems)

        guard let url = urlWithComponents.url else { return .failure(NSError()) }
        
        switch await fetcher.fetchData(of: NewsModel.self, with: url) {
            case .success(let news):
                return .success(news.articles.filter { !($0.title?.contains("[Removed]") ?? false)})
            case .failure(let error):
                print(error.localizedDescription)
                return .failure(error)
        }
    }
}


