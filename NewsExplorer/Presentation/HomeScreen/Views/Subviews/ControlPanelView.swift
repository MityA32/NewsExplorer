//
//  ControlPanelView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "calendar")
            }
            Spacer()
            Menu {
                ForEach(SortByOption.allCases) { option in
                    Button {
                        viewModel.getNews(by: option)
                    } label: {
                        Text("\(option.title)")
                    }
                }
            } label: {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            
        }
        .padding()
    }
}
