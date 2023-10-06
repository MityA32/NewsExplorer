//
//  TextFieldWithDebounce.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import SwiftUI

struct TextFieldWithDebounce: View {
    @ObservedObject var viewModel: NewsViewModel
    @Binding var debouncedText : String
    @StateObject private var textObserver = TextFieldObserver()
    
    var body: some View {
        VStack {
            TextField("Search..", text: $textObserver.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 35)
                .padding(5)
                .padding(.horizontal, 20)
                .background(
                    Rectangle()
                        .foregroundStyle(Color(UIColor.systemGray6))
                        .clipShape(.rect(bottomLeadingRadius: 10, bottomTrailingRadius: 10))
                )
                .onReceive(textObserver.$debouncedText) {
                    viewModel.changeNews(forNew: $0)
                }
            Spacer()
        }
    }
}
