//
//  NewsViewModel.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import Foundation
import Combine

final class NewsViewModel: ObservableObject {
    
    private enum NewsRequest {
        case initial
        case custom
    }
    
    typealias Repository = NewsRepository
    @Published var newsRepository: Repository
    @Published var news = [PieceOfNewsModel]()
    @Published var selectedSortOption: SortByOption = .publishedAt
    @Published var isDataMissing = false
    @Published var startDate: Date?
    @Published var endDate: Date?
    var formattedStartDate: String {
        startDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
    var formattedEndDate: String {
        endDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
    
    var formattedDate: String {
        "\(formattedStartDate) - \(formattedEndDate)"
    }
    
    private var newsRequest: NewsRequest = .initial
    private var currentTopic = "popular"
    private var currentPageNumber = 0
    
    let inCustomNewsConfig = PassthroughSubject<NewsRequestConfig, Never>()
    let outNewsList = PassthroughSubject<[PieceOfNewsModel], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(newsRepository: Repository) {
        self.newsRepository = newsRepository
        
        inCustomNewsConfig
            .subscribe(newsRepository.inCustomNewsConfig)
            .store(in: &cancellables)
        
        newsRepository
            .outNewsList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    if currentPageNumber == 0 {
                        self.news = data
                    } else {
                        self.news += data
                    }
                    
                    self.currentPageNumber += 1
                    
                case .failure(_):
                    self.isDataMissing = true
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    func loadMore() {
        let updatedConfig = NewsRequestConfig(
            topic: currentTopic,
            startDate: startDate,
            endDate: endDate,
            sortOption: selectedSortOption,
            pageNumber: currentPageNumber + 1)
        inCustomNewsConfig.send(updatedConfig)
    }
    
    func changeNews(forNew searchText: String) {
        guard searchText != currentTopic else { return }
        newsRequest = .custom
        currentPageNumber = 0
        currentTopic = searchText.isEmpty ? "popular" : searchText
        loadMore()
    }
    
    func selectSortBy(_ option: SortByOption) {
        if selectedSortOption == option {
            return
        }
        selectedSortOption = option
        currentPageNumber = 0
        loadMore()
    }
    
    func setDateLimits(startDate: Date, endDate: Date) {
        currentPageNumber = 0
        self.startDate = startDate
        self.endDate = endDate
        loadMore()
    }
    
    func discardDateLimits() {
        guard startDate != nil, endDate != nil else { return }
        currentPageNumber = 0
        startDate = nil
        endDate = nil
        loadMore()
    }
}
