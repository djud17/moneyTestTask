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
        let label = UILabel()
        label.textColor = Constants.Color.lightGray
        label.font = .systemFont(ofSize: 15)
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
        let label = UILabel()
        label.textColor = Constants.Color.lightGray
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var currencyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.borderStyle = .none
        textField.keyboardType = .numbersAndPunctuation
        textField.font = .boldSystemFont(ofSize: 36)
        
        var bottomLine = CALayer()
        let width = view.frame.width - 32
        bottomLine.frame = .init(x: 0, y: 46, width: width, height: 0.5)
        bottomLine.backgroundColor = Constants.Color.textFieldLine
        textField.layer.addSublayer(bottomLine)
        
        textField.addTarget(self, action: #selector(currencyTextFieldEditing), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var rubCharLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "RUB"
        
        return label
    }()
    
    private lazy var rubTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.borderStyle = .none
        textField.keyboardType = .numbersAndPunctuation
        textField.font = .boldSystemFont(ofSize: 36)
        
        var bottomLine = CALayer()
        let width = view.frame.width - 32
        bottomLine.frame = .init(x: 0, y: 46, width: width, height: 0.5)
        bottomLine.backgroundColor = Constants.Color.textFieldLine
        textField.layer.addSublayer(bottomLine)
        
        textField.addTarget(self, action: #selector(rubTextFieldEditing), for: .editingChanged)
        
        return textField
    }()
    
    // MARK: - Parameters
    private var presenter: CurrencyDetailPresenterProtocol
    
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        rateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyNameLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        currencyRateLabel.snp.makeConstraints { make in
            make.top.equalTo(rateTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(currencyRateLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        currencyCharLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        currencyTextField.snp.makeConstraints { make in
            make.top.equalTo(currencyCharLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(47)
        }
        
        rubCharLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        rubTextField.snp.makeConstraints { make in
            make.top.equalTo(rubCharLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(47)
        }
    }
    
    private func setupData() {
        currencyNameLabel.text = presenter.getCurrencyName()
        currencyRateLabel.text = presenter.getCurrencyRate()
        currencyCharLabel.text = presenter.getCurrencyChar()
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
