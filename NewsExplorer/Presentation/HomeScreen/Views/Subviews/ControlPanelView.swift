//
//  ControlPanelView.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 05.10.2023.
//

import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var isDateSelectionShown = false
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                isDateSelectionShown.toggle()
            } label: {
                Image(systemName: "calendar")
            }
            .sheet(isPresented: $isDateSelectionShown, content: {
                SetDateOfNewsView(viewModel: viewModel)
                    .presentationDetents([.medium])
            })
            Spacer()
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
        .padding()
    }
}


struct CustomMenu<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .frame(width: 234)
        .background(
            Color(UIColor.systemBackground)
                .opacity(0.8)
                .blur(radius: 50)
        )
        .cornerRadius(14)
    }
}

struct CustomMenuButtonStyle: ButtonStyle {
    let symbol: String
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: symbol)
        }
        .padding(.horizontal, 16)
        .foregroundColor(color)
        .background(configuration.isPressed ? Color(UIColor.secondarySystemBackground) : Color.clear)
        .frame(height: 44)
    }
}
