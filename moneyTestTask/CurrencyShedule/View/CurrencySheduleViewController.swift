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
    
    // MARK: - Parameters
    private var presenter: CurrencyShedulePresenterProtocol
    
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
    }
    
    private func setupLayout() {
        ratesCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview()
        }
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
