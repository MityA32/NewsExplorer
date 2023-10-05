//
//  Repository.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation

protocol Repository: NSObject {
    associatedtype T
    func getPortion(topic: String, number: Int, sortByOption: SortByOption) async -> Result<[T], Error>
}
