//
//  ViewController.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit
import SnapKit

final class CurrencySheduleViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var ratesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 104, height: 110)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(nibModels: [CurrencyCollectionViewCellModel.self])
        
        return collectionView
    }()
    
    private lazy var datePickerView: CustomDataPicker = {
        let stringDate = dateFormatter.string(from: .now)
        let datePicker = CustomDataPicker(currentDate: stringDate)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(datePickerTapped))
        datePicker.addGestureRecognizer(gesture)
        
        return datePicker
    }()
    
    // MARK: - Parameters
    private var presenter: CurrencyShedulePresenterProtocol
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter
    }()
    
    // MARK: - Inits
    init(presenter: CurrencyShedulePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        presenter.loadData()
    }
    
    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = Constants.Color.white
        
        navigationItem.title = "Валюты"
    }
    
    private func setupHierarchy() {
        view.addSubview(ratesCollectionView)
        view.addSubview(datePickerView)
    }
    
    private func setupLayout() {
        let mediumOffset = Constants.Offset.mediumOffset
        
        datePickerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.height.equalTo(44)
        }
        
        ratesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(datePickerView.snp.bottom).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func datePickerTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let datePicker = setupDatePicker(in: alertController)
        
        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(343)
        }
        
        let saveButton = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            let stringDate = self?.dateFormatter.string(from: datePicker.date) ?? ""
            self?.datePickerView.setupDate(with: stringDate)
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertController.addAction(saveButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
    
    private func setupDatePicker(in contentView: UIAlertController) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = .now
        
        contentView.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        return datePicker
    }
}

protocol CurrencySheduleDelegate: AnyObject {
    func updateView()
}

extension CurrencySheduleViewController: CurrencySheduleDelegate {
    func updateView() {
        ratesCollectionView.reloadData()
    }
}

extension CurrencySheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNumberOfRecords()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = presenter.getRecord(by: indexPath.row) else { return UICollectionViewCell() }
        
        let model = CurrencyCollectionViewCellModel(currencyChar: data.charCode, currencyRate: data.value)
        
        return collectionView.dequeueReusableCell(withModel: model, for: indexPath)
    }
}
