//
//  CurrencyDetailPresenter.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 16.01.2023.
//

import Foundation

enum ConvertDirection {
    case fromRub
    case toRub
}

protocol CurrencyDetailPresenterProtocol {
    var delegate: CurrencyDetailDelegate? { get set }
    
    func getCurrencyChar() -> String
    func getCurrencyName() -> String
    func getCurrencyRate() -> String
    func convertCurrency(value: Double, direction: ConvertDirection)
}

final class CurrencyDetailPresenter: CurrencyDetailPresenterProtocol {
    weak var delegate: CurrencyDetailDelegate?
    
    // MARK: - Parameters
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func getCurrencyChar() -> String {
        currency.charCode
    }
    
    func getCurrencyName() -> String {
        currency.name
    }
    
    func getCurrencyRate() -> String {
        let rate = String(format: "%.2f", currency.value)
        
        return "\(rate) ₽"
    }
    
    func convertCurrency(value: Double, direction: ConvertDirection) {
        switch direction {
        case .fromRub:
            convertFromRub(value)
        case .toRub:
            convertToRub(value)
        }
    }
    
    private func convertFromRub(_ value: Double) {
        let result = value / (Double(currency.nominal) * currency.value)
        let stringResult = String(format: "%.2f", result)
        delegate?.updateCurrencyField(with: stringResult)
    }
    
    private func convertToRub(_ value: Double) {
        let result = (value / Double(currency.nominal)) * currency.value
        let stringResult = String(format: "%.2f", result)
        delegate?.updateRubField(with: stringResult)
    }
}
