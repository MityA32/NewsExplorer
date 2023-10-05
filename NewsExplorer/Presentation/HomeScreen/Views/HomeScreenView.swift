//
//  HomeScreenView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        VStack {
            ControlPanelView(viewModel: viewModel)
                .frame(height: 44)
            
            NewsListView(viewModel: viewModel)
            
            
        }
    }
}
