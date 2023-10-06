//
//  Date+Extenstion.swift
//  NewsExplorer
//
//  Created by Dmytro Hetman on 06.10.2023.
//

import Foundation

extension Date {
    var monthBefore: Date {
        Calendar.current.date(byAdding: .day, value: -30, to: self) ?? self
    }
    
    func formatToISO8601() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
