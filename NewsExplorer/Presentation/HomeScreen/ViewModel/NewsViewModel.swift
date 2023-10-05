//
//  NewsViewModel.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import Foundation

final class NewsViewModel: ObservableObject {
    typealias Repository = NewsRepository
    @Published var newsRepository: Repository
    
    var sortByOption: SortByOption = .publishedAt
    
    init(newsRepository: Repository) {
        self.newsRepository = newsRepository
        Task {
            _ = await newsRepository.getPortion()
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
            }
        }
    }
    
    func getAllNews() -> [PieceOfNewsModel] {
        newsRepository.data
    }
    
    func getNews(by sortOption: SortByOption) {
        Task {
            _ = await newsRepository.getPortion(sortByOption: sortOption)
            DispatchQueue.main.async { [weak self] in
                self?.objectWillChange.send()
            }
        }
    }
}
