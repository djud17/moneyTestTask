//
//  CurrencyShedulePresenter.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit

protocol GetSheduleDataProtocol {
    func getNumberOfRecords() -> Int
    func getRecord(by id: Int) -> Currency?
    func getData(date: Date?)
}

protocol CurrencyShedulePresenterProtocol: GetSheduleDataProtocol {
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
    
    func getData(date: Date?) {
        let dateKey = date?.getStringDate() ?? currentDate
        if let storageData = persistance.readFrom(date: dateKey) {
            currencyRates = storageData.currencyRates
            currencies = Array(storageData.currencyRates.keys)
            delegate?.updateView()
        } else {
            loadData(for: date)
        }
    }
    
    private func loadData(for date: Date?) {
        apiClient.getRates(for: date) { [weak self] result in
            switch result {
            case .success(let success):
                self?.currencyRates = success.currencyRates
                self?.currencies = Array(success.currencyRates.keys)
                
                self?.saveDataToStorage(data: success)
            case .failure(let error):
                let stringDate = date?.getStringDate() ?? "сегодня"
                let errorMessage: String
                switch error {
                case .noData:
                    errorMessage = "Ошибка, данных на \(stringDate) нет"
                case .serverError, .wrongData:
                    errorMessage = "Ошибка сервера, повторите запрос позже"
                }
                
                self?.errorAppeared(message: errorMessage)
            }
            
            DispatchQueue.main.async {
                self?.delegate?.updateView()
            }
        }
    }
    
    private func saveDataToStorage(data: RequestResult) {
        do {
            try persistance.writeTo(object: data)
        } catch {
            let errorMessage = "Ошибка во время сохранения данных"
            errorAppeared(message: errorMessage)
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
