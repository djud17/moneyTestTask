//
//  Date.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 19.01.2023.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    
    return dateFormatter
}()

extension Date {
    func getStringDate() -> String {
        return dateFormatter.string(from: self)
    }
}

extension String {
    func formatDate() -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
        guard let date = isoDateFormatter.date(from: self) else { return nil }

        return dateFormatter.string(from: date)
    }
    
    func getDate() -> Date? {
        return dateFormatter.date(from: self)
    }
}
