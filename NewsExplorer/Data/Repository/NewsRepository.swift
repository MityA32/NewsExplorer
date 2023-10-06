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
                    print("incustom")
                    print(config)
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
        
        guard let url = URL(
            string: "https://newsapi.org/v2/everything?q=\(topic)&from=\(startDate?.formatToISO8601() ?? "")&to=\(endDate?.formatToISO8601() ?? "")&sortBy=\(sortByOption.rawValue)&pageSize=15&page=\(pageNumber)&apiKey=\(APIKeys.newsApi)")
        else { return .failure(NSError()) }
        
        switch await fetcher.fetchData(of: NewsModel.self, with: url) {
            case .success(let news):
                return .success(news.articles.filter { !($0.title?.contains("[Removed]") ?? false)})
            case .failure(let error):
                print(error.localizedDescription)
                return .failure(error)
        }
    }
}


