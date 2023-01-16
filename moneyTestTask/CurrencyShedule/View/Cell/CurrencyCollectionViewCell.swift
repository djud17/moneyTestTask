//
//  CurrencyCollectionViewCell.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit

final class CurrencyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var currencyCharLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
}

struct CurrencyCollectionViewCellModel {
    let currencyChar: String
    let currencyRate: Double
}

extension CurrencyCollectionViewCellModel: CellViewModel {
    func setup(cell: CurrencyCollectionViewCell) {
        cell.backView.backgroundColor = Constants.Color.lightBlue
        cell.backView.layer.cornerRadius = 12
        
        cell.currencyCharLabel.text = currencyChar
        cell.currencyCharLabel.textColor = Constants.Color.blue
        
        let rate = String(format: "%.2f", currencyRate)
        cell.currencyRateLabel.text = "\(rate) ₽"
        cell.currencyRateLabel.textColor = Constants.Color.lightGray
    }
}
