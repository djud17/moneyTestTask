//
//  Currency.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import Foundation

// MARK: - Result
struct RequestResult: Decodable {
    let date: String
    let currencyRates: [String: Currency]
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case currencyRates = "Valute"
    }
}

// MARK: - Valute
struct Currency: Codable {
    let charCode: String
    let nominal: Int
    let name: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
    }
}
