//
//  NewsListView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 04.10.2023.
//

import SwiftUI
import Combine

struct NewsListView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var searchText = ""
    @State private var isDataMissing = false
    
//    private var isDataMissingBinding: Binding<Bool> {
//        Binding(
//            get: { viewModel.isDataMissing },
//            set: { newValue in
//                viewModel.isDataMissing = newValue
//            }
//        )
//    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.news, id: \.id) {
                        NewsListRowView(pieceOfNews: $0)
                            .padding(15)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(Color(cgColor: UIColor.systemGray6.cgColor))
                            )
                    }
                    .padding(.horizontal, 20)
                    HStack {
                        Spacer()
                        ProgressView()
                            .foregroundStyle(.blue)
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 50, height: 50, alignment: .center)
                            .onAppear {
                                viewModel.loadMore()
                            }
                        Spacer()
                    }
                }
            }
            .frame(alignment: .center)
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
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
