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

    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.startDate != nil, viewModel.endDate != nil {
                    Text(viewModel.formattedDate)
                        .frame(alignment: .center)
                        .padding()
                }
                ForEach(viewModel.news, id: \.id) { pieceOfNews in
                    NavigationLink {
                        PieceOfNewsDetailsView(pieceOfNews: pieceOfNews)
                            .navigationTitle(pieceOfNews.source?.name ?? "")
                    } label: {
                        NewsListRowView(pieceOfNews: pieceOfNews)
                            .accentColor(.accentColor)
                            .tint(Color.black)
                            .padding(15)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(Color(cgColor: UIColor.systemGray6.cgColor))
                            )
                        
                    }
                }
                .padding(.horizontal, 20)
                progressView
            }
        }
        .frame(alignment: .center)
    }
    
    var progressView: some View {
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
