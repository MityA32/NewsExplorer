//
//  News+Decodable.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import Foundation

struct NewsModel: Decodable {
    let articles: [PieceOfNewsModel]
}

struct PieceOfNewsModel: Decodable {
    let source: SourceModel
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct SourceModel: Decodable {
    let name: String
}
