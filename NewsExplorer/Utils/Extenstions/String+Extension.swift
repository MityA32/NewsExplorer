//
//  String+Extension.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import Foundation

extension String {
    func formattedFromISO8601() -> String {
        let dateFormatterFromString = DateFormatter()
        let date = dateFormatterFromString.date(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy, h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date ?? Date())
    }
}
