//
//  CurrencyShedulePresenter.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import Foundation

protocol CurrencyShedulePresenterProtocol {
    var delegate: CurrencySheduleDelegate? { get set }
    
    func loadData()
    func getNumberOfRecords() -> Int
    func getRecord(by id: Int) -> Currency?
}

final class CurrencyShedulePresenter: CurrencyShedulePresenterProtocol {
    
    // MARK: - Parameters
    weak var delegate: CurrencySheduleDelegate?
    private var currencies: [String] = []
    private var currencyRates: [String: Currency] = [:]
    // MARK: - Services
    private var apiClient: ApiClientProtocol
    
    // MARK: - Inits
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getNumberOfRecords() -> Int {
        currencies.count
    }
    
    func getRecord(by id: Int) -> Currency? {
        if id < currencies.count {
            let currency = currencies[id]
            return currencyRates[currency]
        } else {
            return nil
        }
    }
    
    func loadData() {
        DispatchQueue.global().async { [weak self] in
            self?.apiClient.getDailyRates { result in
                switch result {
                case .success(let success):
                    self?.currencyRates = success.currencyRates
                    self?.currencies = success.currencyRates.keys.map { $0 }
                case .failure(let error):
                    print("Error - \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self?.delegate?.updateView()
                }
            }
        }
    }
}
