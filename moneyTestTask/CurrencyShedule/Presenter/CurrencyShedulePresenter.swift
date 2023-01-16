//
//  CurrencyShedulePresenter.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit

protocol LoadDataProtocol {
    func loadData()
    func loadData(for date: Date)
}

protocol GetDataProtocol {
    func getNumberOfRecords() -> Int
    func getRecord(by id: Int) -> Currency?
}

protocol CurrencyShedulePresenterProtocol: LoadDataProtocol, GetDataProtocol {
    var delegate: CurrencySheduleDelegate? { get set }
    
    func itemPressed(by id: Int, with navigationController: UINavigationController?)
}

final class CurrencyShedulePresenter: CurrencyShedulePresenterProtocol {
    
    // MARK: - Parameters
    weak var delegate: CurrencySheduleDelegate?
    private var currencies: [String] = [] {
        didSet {
            currencies = currencies.sorted(by: <)
        }
    }
    private var currencyRates: [String: Currency] = [:]
    
    // MARK: - Services
    private var apiClient: ApiClientProtocol
    weak var navigationController: UINavigationController?
    
    // MARK: - Inits
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Functions
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
    
    func loadData(for date: Date) {
        DispatchQueue.global().async { [weak self] in
            self?.apiClient.getDailyRates(for: date) { result in
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
    
    func itemPressed(by id: Int, with navigationController: UINavigationController?) {
        if id < currencies.count {
            let currency = currencies[id]
            guard let model = currencyRates[currency] else { return }
            
            let presenter: CurrencyDetailPresenterProtocol = CurrencyDetailPresenter(currency: model)
            let detailController = CurrencyDetailViewController(presenter: presenter)
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
