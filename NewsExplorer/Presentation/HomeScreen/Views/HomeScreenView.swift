//
//  HomeScreenView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var isDateSelectionShown = false
    @State private var searchText = ""
    @State private var isDataMissing = false
    
    var body: some View {
        VStack {
            NavigationStack {
                NewsListView(viewModel: viewModel)
                    .navigationTitle("News")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        topBarLeading
                        topBarTrailing
                    }
            }
            
            .alert(isPresented: $viewModel.isDataMissing) {
                Alert(title: Text("Data is missing"),
                      message: Text("Probably free calls from API are over :("))
            }
            .searchable(text: $searchText)
            .onChange(of: searchText, {
                viewModel.changeNews(forNew: searchText)
            })
        }
    }
    
    var topBarLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                isDateSelectionShown.toggle()
            } label: {
                Image(systemName: "calendar")
            }
            .sheet(isPresented: $isDateSelectionShown, content: {
                SetDateOfNewsView(viewModel: viewModel)
                    .presentationDetents([.medium])
            })
       }
    }
    
    var topBarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                ForEach(SortByOption.allCases, id: \.self) { option in
                    Button {
                        viewModel.selectSortBy(option)
                    } label: {
                        if viewModel.selectedSortOption == option {
                            Label("\(option.title)", systemImage: "checkmark")
                        } else {
                            Text("\(option.title)")
                        }
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
    }
}
