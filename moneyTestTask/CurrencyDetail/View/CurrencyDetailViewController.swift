//
//  CurrencyDetailViewController.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 16.01.2023.
//

import UIKit

final class CurrencyDetailViewController: UIViewController {
    
    // MARK: - Parameters
    private let currency: Currency
    
    // MARK: - Inits
    init(currency: Currency) {
        self.currency = currency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
