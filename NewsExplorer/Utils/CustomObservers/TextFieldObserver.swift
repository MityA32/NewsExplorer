//
//  TextFieldObserver.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import Foundation
import Combine

final class TextFieldObserver: ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.debouncedText = $0
            })
            .store(in: &subscriptions)
    }
}
