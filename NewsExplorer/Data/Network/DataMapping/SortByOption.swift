//
//  SortByOption.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import Foundation

enum SortByOption: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case relevancy
    case popularity
    case publishedAt
}

extension SortByOption {
    var title: String {
        switch self {
        case .relevancy:
            "Relevancy"
        case .popularity:
            "Popularity"
        case .publishedAt:
            "Published At"
        }
    }
}
