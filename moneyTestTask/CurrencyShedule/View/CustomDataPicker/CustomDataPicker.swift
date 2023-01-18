//
//  CustomDataPicker.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 16.01.2023.
//

import UIKit

final class CustomDataPicker: UIView {
    
    // MARK: - UI Elements
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.black
        label.font = .systemFont(ofSize: 18)
        label.text = currentDate
        
        return label
    }()
    
    private lazy var calendarImage: UIImageView = {
        let image = UIImage(named: "calendar")
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    // MARK: - Parameters
    private var currentDate: String
    
    // MARK: - Inits
    init(currentDate: String) {
        self.currentDate = currentDate
        super.init(frame: .zero)
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    private func setupView() {
        layer.borderColor = Constants.Color.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
    }
    
    private func setupHierarchy() {
        addSubview(dateLabel)
        addSubview(calendarImage)
    }
    
    private func setupLayout() {
        let smallOffset: CGFloat = 12
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(smallOffset)
            make.leading.equalToSuperview().offset(smallOffset)
            make.bottom.equalToSuperview().inset(smallOffset)
            make.trailing.equalTo(calendarImage.snp.leading).inset(-smallOffset)
        }
        
        calendarImage.snp.makeConstraints { make in
            make.height.width.equalTo(18)
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
    }
    
    // MARK: - Actions
    func setupDate(with date: String) {
        dateLabel.text = date
    }
}
