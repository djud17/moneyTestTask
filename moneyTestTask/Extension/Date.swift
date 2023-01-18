//
//  Date.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 19.01.2023.
//

import Foundation

extension Date {
    func getStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    func formatDate() -> String? {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"

        return formatter.string(from: date)
    }
}
