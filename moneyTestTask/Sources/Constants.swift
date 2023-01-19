//
//  Constants.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit

enum Constants {
    static var currentDate: String {
        Date.now.getStringDate()
    }
    
    enum Color {
        static let white: UIColor = .white
        static let black: UIColor = .black
        static let lightBlue = UIColor(red: 0.948, green: 0.963, blue: 0.986, alpha: 1)
        static let blue = UIColor(red: 0.247, green: 0.663, blue: 0.961, alpha: 1)
        static let lightGray = UIColor(red: 0.674, green: 0.681, blue: 0.742, alpha: 1)
        static let lightBackground = UIColor(red: 0.948, green: 0.963, blue: 0.986, alpha: 1)
        static let textFieldLine = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.18)
    }
    
    enum URL {
        static let dailyRates = "https://www.cbr-xml-daily.ru/daily_json.js"
    }
    
    enum SheduleOffset {
        static let smallOffset: CGFloat = 12
        static let mediumOffset: CGFloat = 24
    }
    
    enum DetailOffset {
        static let smallOffset: CGFloat = 16
        static let mediumOffset: CGFloat = 20
    }
}
