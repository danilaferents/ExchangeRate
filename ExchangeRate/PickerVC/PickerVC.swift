//
//  PickerVC.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 06.09.23.
//

import UIKit

protocol PickerVCOutput {
    func didPickCurrency(currency: String)
}

final class PickerVC: UIViewController {
    
    // Dependencies
    var delegate: PickerVCOutput
    
    // UI
    private lazy var currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.center = self.view.center
        return picker
    }()
    
    // Properties
    let initialCurrency: String
    
    // MARK: - Init
    
    init(delegate: PickerVCOutput,
         initialCurrency: String) {
        self.delegate = delegate
        self.initialCurrency = initialCurrency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        view.backgroundColor = .white
        if let indexPosition = DefaultConstants.currencies.firstIndex(of: initialCurrency) {
            currencyPicker.selectRow(indexPosition, inComponent: 0, animated: true)
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.addSubview(currencyPicker)
        currencyPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            currencyPicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            currencyPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UIPickerViewDelegate

extension PickerVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.didPickCurrency(currency: DefaultConstants.currencies[row])
        self.dismiss(animated: true)
    }
}

// MARK: - UIPickerViewDataSource

extension PickerVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DefaultConstants.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DefaultConstants.currencies[row]
    }
}

