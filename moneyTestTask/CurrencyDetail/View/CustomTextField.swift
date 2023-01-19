//
//  CustomTextField.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 17.01.2023.
//

import UIKit

final class CustomTextField: UITextField {
    init() {
        super.init(frame: .zero)
        placeholder = "0"
        borderStyle = .none
        keyboardType = .numbersAndPunctuation
        font = .boldSystemFont(ofSize: 36)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
