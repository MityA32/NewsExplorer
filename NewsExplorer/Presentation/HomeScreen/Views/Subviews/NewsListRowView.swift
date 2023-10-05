//
//  NewsListRowView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import SwiftUI

struct NewsListRowView: View {
    let pieceOfNews: PieceOfNewsModel
    
    var body: some View {
        VStack {
            Group {
                Text(pieceOfNews.title ?? "Untitled")
                    .font(.title3)
                Text(pieceOfNews.description ?? "No description")
                    .font(.subheadline)
            }
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
