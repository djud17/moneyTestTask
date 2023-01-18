//
//  CurrencyShedulePresenter.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit

protocol GetDataProtocol {
    func getNumberOfRecords() -> Int
    func getRecord(by id: Int) -> Currency?
    
    func presentData(date: Date?)
}

protocol CurrencyShedulePresenterProtocol: GetDataProtocol {
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
    private let currentDate: String = Constants.currentDate
    private var currencyRates: [String: Currency] = [:]
    
    // MARK: - Services
    private let apiClient: ApiClientProtocol
    private let persistance: PersistanceProtocol
    weak var navigationController: UINavigationController?
    
    // MARK: - Inits
    init(apiClient: ApiClientProtocol, persistance: PersistanceProtocol) {
        self.apiClient = apiClient
        self.persistance = persistance
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
    
    func presentData(date: Date?) {
        if let date = date {
            getData(for: date)
        } else {
            getDailyData()
        }
    }
    
    private func getDailyData() {
        if let storageData = persistance.readFrom(date: currentDate) {
            currencyRates = storageData.currencyRates
            currencies = storageData.currencyRates.keys.map { $0 }
            delegate?.updateView()
        } else {
            loadDailyData()
        }
    }
    
    private func loadDailyData() {
        DispatchQueue.global().async { [weak self] in
            self?.apiClient.getDailyRates { result in
                switch result {
                case .success(let success):
                    self?.currencyRates = success.currencyRates
                    self?.currencies = success.currencyRates.keys.map { $0 }
                    
                    do {
                        try self?.persistance.writeTo(object: success)
                    } catch {
                        let errorMessage = "Ошибка во время сохранения сегодняшних данных - \(error.localizedDescription)"
                        self?.errorAppeared(message: errorMessage)
                    }
                case .failure(let error):
                    let errorMessage = "Ошибка во время загрузки сегодняшних данных - \(error.localizedDescription)"
                    self?.errorAppeared(message: errorMessage)
                }
                
                DispatchQueue.main.async {
                    self?.delegate?.updateView()
                }
            }
        }
    }
    
    private func getData(for date: Date) {
        let stringDate = date.getStringDate()
        
        if let storageData = persistance.readFrom(date: stringDate) {
            currencyRates = storageData.currencyRates
            currencies = storageData.currencyRates.keys.map { $0 }
            delegate?.updateView()
        } else {
            loadData(for: date)
        }
    }
    
    private func loadData(for date: Date) {
        DispatchQueue.global().async { [weak self] in
            self?.apiClient.getDailyRates(for: date) { result in
                let stringDate = date.getStringDate()
                
                switch result {
                case .success(let success):
                    self?.currencyRates = success.currencyRates
                    self?.currencies = success.currencyRates.keys.map { $0 }
                    
                    do {
                        try self?.persistance.writeTo(object: success)
                    } catch {
                        let errorMessage = "Ошибка во время сохранения данных на \(stringDate) - \(error.localizedDescription)"
                        self?.errorAppeared(message: errorMessage)
                    }
                case .failure(let error):
                    let errorMessage = "Ошибка, данных на \(stringDate) нет - \(error.localizedDescription)"
                    self?.errorAppeared(message: errorMessage)
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
    
    private func errorAppeared(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        
        delegate?.showError(errorMessage: alertController)
    }
}
