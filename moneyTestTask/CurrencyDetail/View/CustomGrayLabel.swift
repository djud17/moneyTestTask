//
//  CustomGrayLabel.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 17.01.2023.
//

import UIKit

final class CustomGrayLabel: UILabel {
    init(with size: CGFloat) {
        super.init(frame: .zero)
        font = .systemFont(ofSize: size)
        textColor = Constants.Color.lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
