//
//  NewsApiQueryItems.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import Foundation

enum NewsApiQueryItems: String, CaseIterable {
    case q
    case from
    case to
    case sortBy
    case pageSize
    case page
    case apiKey
}
