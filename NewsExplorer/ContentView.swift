//
//  ContentView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeScreenView(viewModel: NewsViewModel(newsRepository: NewsRepository(fetcher: DataFetcher())))
    }
}

#Preview {
    ContentView()
}
