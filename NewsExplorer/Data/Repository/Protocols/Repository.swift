//
//  Repository.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation

protocol Repository: NSObject {
    associatedtype T
    func getPortion(topic: String, from startDate: Date?, to endDate: Date?, sortByOption: SortByOption, pageNumber: Int) async -> Result<[T], Error>
}
