//
//  PieceOfNewsDetailsView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import SwiftUI

struct PieceOfNewsDetailsView: View {
    let pieceOfNews: PieceOfNewsModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Group {
                    Text(pieceOfNews.title ?? "Untiled")
                        .bold()
                        .font(.title2)
                    Divider()
                    Text(pieceOfNews.author ?? "Unknown author")
                        .font(.headline)
                    Text(pieceOfNews.publishedAt?.formattedFromISO8601() ?? "Unknown date")
                        .font(.caption)
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: pieceOfNews.urlToImage ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                
                        } placeholder: {
                            ProgressView()
                        }
                        Text("Source: \(pieceOfNews.source?.name ?? "unknown")")
                            .font(.caption)
                    }
                    .padding()
                    Text(pieceOfNews.description ?? "No description")
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
        }
    }
}
