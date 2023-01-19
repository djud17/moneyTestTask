//
//  CurrencyDetailViewController.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 16.01.2023.
//

import UIKit
import SnapKit

final class CurrencyDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.black
        label.font = .systemFont(ofSize: 18)
        
        return label
    }()
    
    private lazy var rateTitleLabel: UILabel = {
        let label = CustomGrayLabel(with: 15)
        label.text = "Курс"
        
        return label
    }()
    
    private lazy var currencyRateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.black
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.white
        view.layer.cornerRadius = 17
        
        return view
    }()
    
    private lazy var currencyCharLabel: UILabel = {
        let label = CustomGrayLabel(with: 14)
        
        return label
    }()
    
    private lazy var currencyTextField: UITextField = {
        let textField = CustomTextField()
        let bottomLine = createLineLayer()
        
        textField.layer.addSublayer(bottomLine)
        textField.addTarget(self, action: #selector(currencyTextFieldEditing), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var rubCharLabel: UILabel = {
        let label = CustomGrayLabel(with: 14)
        label.text = "RUB"
        
        return label
    }()
    
    private lazy var rubTextField: UITextField = {
        let textField = CustomTextField()
        let bottomLine = createLineLayer()
        
        textField.layer.addSublayer(bottomLine)
        textField.addTarget(self, action: #selector(rubTextFieldEditing), for: .editingChanged)
        
        return textField
    }()
    
    // MARK: - Parameters
    
    private var presenter: CurrencyDetailPresenterProtocol
    
    private let smallOffset = Constants.DetailOffset.smallOffset
    private let mediumOffset = Constants.DetailOffset.mediumOffset
    
    // MARK: - Inits
    
    init(presenter: CurrencyDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        setupData()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = Constants.Color.lightBackground
        
        navigationItem.title = presenter.getCurrencyChar()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupHierarchy() {
        view.addSubview(currencyNameLabel)
        view.addSubview(rateTitleLabel)
        view.addSubview(currencyRateLabel)
        view.addSubview(backView)
        
        backView.addSubview(currencyCharLabel)
        backView.addSubview(currencyTextField)
        backView.addSubview(rubCharLabel)
        backView.addSubview(rubTextField)
    }
    
    private func setupLayout() {
        currencyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        rateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyNameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        currencyRateLabel.snp.makeConstraints { make in
            make.top.equalTo(rateTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(currencyRateLabel.snp.bottom).offset(mediumOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        setupBackViewLayout()
    }
    
    private func setupBackViewLayout() {
        currencyCharLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        currencyTextField.snp.makeConstraints { make in
            make.top.equalTo(currencyCharLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
            make.height.equalTo(47)
        }
        
        rubCharLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyTextField.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
        }
        
        rubTextField.snp.makeConstraints { make in
            make.top.equalTo(rubCharLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(smallOffset)
            make.trailing.equalToSuperview().inset(smallOffset)
            make.height.equalTo(47)
        }
    }
    
    private func setupData() {
        currencyNameLabel.text = presenter.getCurrencyName()
        currencyRateLabel.text = presenter.getCurrencyRate()
        currencyCharLabel.text = presenter.getCurrencyChar()
    }
    
    private func createLineLayer() -> CALayer {
        let layer = CALayer()
        let offset = Constants.DetailOffset.smallOffset * 2
        let width = view.frame.width - offset
        layer.frame = .init(x: 0, y: 46, width: width, height: 0.5)
        layer.backgroundColor = Constants.Color.textFieldLine.cgColor
        
        return layer
    }
    
    // MARK: - Actions
    
    @objc private func currencyTextFieldEditing() {
        guard let value = currencyTextField.text,
              let doubleValue = Double(value) else { return }
        
        presenter.convertCurrency(value: doubleValue, direction: .toRub)
    }
    
    @objc private func rubTextFieldEditing() {
        guard let value = rubTextField.text,
              let doubleValue = Double(value) else { return }
        
        presenter.convertCurrency(value: doubleValue, direction: .fromRub)
    }
}

protocol CurrencyDetailDelegate: AnyObject {
    func updateRubField(with value: String)
    func updateCurrencyField(with value: String)
}

extension CurrencyDetailViewController: CurrencyDetailDelegate {
    func updateRubField(with value: String) {
        rubTextField.text = value
    }
    
    func updateCurrencyField(with value: String) {
        currencyTextField.text = value
    }
}
