//
//  NewsRequestConfig.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import Foundation

struct NewsRequestConfig {
    let topic: String
    let startDate: Date?
    let endDate: Date?
    let sortOption: SortByOption
    var pageNumber: Int
    
}
