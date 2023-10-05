//
//  NewsListView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(searchResults, id: \.title) {
                NewsListRowView(pieceOfNews: $0)
            }
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [PieceOfNewsModel] {
        guard !searchText.isEmpty else { return viewModel.getAllNews() }
        return viewModel.getAllNews().filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
    }
}
