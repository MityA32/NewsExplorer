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
    
    private var newsRequest: NewsRequest = .initial
    private var currentTopic = "popular"
    private var currentPageNumber = 0
    
    let inInitialNewsConfig = PassthroughSubject<NewsRequestConfig, Never>()
    let inCustomNewsConfig = PassthroughSubject<NewsRequestConfig, Never>()
    let outNewsList = PassthroughSubject<[PieceOfNewsModel], Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(newsRepository: Repository) {
        self.newsRepository = newsRepository
        
        inInitialNewsConfig
            .sink(
                receiveValue: { [weak self] config in
                    self?.newsRepository.inInitialNewsConfig.send(config)
            })
            .store(in: &cancellables)
        
        inCustomNewsConfig
            .sink(
                receiveValue: { [weak self] config in
                    self?.newsRepository.inCustomNewsConfig.send(config)
            })
            .store(in: &cancellables)
        
        newsRepository
            .outNewsList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.currentPageNumber += 1
                    self?.news += data
                case .failure(_):
                    self?.isDataMissing = true
                    break
                }
            })
            .store(in: &cancellables)
    }
    
    func changeNews(forNew searchText: String) {
        news = []
        newsRequest = .custom
        currentPageNumber = 0
        currentTopic = searchText.isEmpty ? "popular" : searchText
        let config = NewsRequestConfig(topic: currentTopic, startDate: startDate, endDate: endDate, sortOption: selectedSortOption, pageNumber: currentPageNumber)
        inCustomNewsConfig.send(config)
    }
    
    func loadMore() {
        let updatedConfig = NewsRequestConfig(
            topic: currentTopic,
            startDate: startDate,
            endDate: endDate,
            sortOption: selectedSortOption,
            pageNumber: currentPageNumber + 1)
        switch newsRequest {
            case .initial:
                inInitialNewsConfig.send(updatedConfig)
            case .custom:
                inCustomNewsConfig.send(updatedConfig)
        }
    }
    
    func selectSortBy(_ option: SortByOption) {
        if selectedSortOption == option {
            return
        }
        news = []
        selectedSortOption = option
        currentPageNumber = 0
        let updatedConfig = NewsRequestConfig(
            topic: currentTopic,
            startDate: startDate,
            endDate: endDate,
            sortOption: selectedSortOption,
            pageNumber: currentPageNumber)
        switch newsRequest {
            case .initial:
                inInitialNewsConfig.send(updatedConfig)
            case .custom:
                inCustomNewsConfig.send(updatedConfig)
        }
    }
    
    func setDateLimits(startDate: Date, endDate: Date) {
        news = []
        currentPageNumber = 0
        self.startDate = startDate
        self.endDate = endDate
        let updatedConfig = NewsRequestConfig(
            topic: currentTopic,
            startDate: startDate,
            endDate: endDate,
            sortOption: selectedSortOption,
            pageNumber: currentPageNumber)
        switch newsRequest {
            case .initial:
                inInitialNewsConfig.send(updatedConfig)
            case .custom:
                inCustomNewsConfig.send(updatedConfig)
        }
    }
    
    func discardDateLimits() {
        news = []
        currentPageNumber = 0
        self.startDate = nil
        self.endDate = nil
        let updatedConfig = NewsRequestConfig(
            topic: currentTopic,
            startDate: startDate,
            endDate: endDate,
            sortOption: selectedSortOption,
            pageNumber: currentPageNumber)
        switch newsRequest {
            case .initial:
                inInitialNewsConfig.send(updatedConfig)
            case .custom:
                inCustomNewsConfig.send(updatedConfig)
        }
    }
}
