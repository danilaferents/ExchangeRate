//
//  ExchangeRateViewController.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 30.08.23.
//

import UIKit

private enum Constants {
    static let dateVerticalOffset: CGFloat = 10
    static let tableViewHorisontalOffset: CGFloat = 10
}

protocol ExchangeRateView: UIViewController {
    func reloadTableView()
    func endRefreshing()
}

final class ExchangeRateViewController: UIViewController {
    
    // Dependencies
    private var presenter: IExxchangeRatePresenter
    
    // UI
    private lazy var lastUpdateView = LastUpdateView()
    
    private lazy var ratesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RateDailyCell.self, forCellReuseIdentifier: String(describing: RateDailyCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let controll = UIRefreshControl()
        controll.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        return controll
    }()
    
    private lazy var currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.center = self.view.center
        return picker
    }()
    
    // MARK: - Init
    
    init(presenter: IExxchangeRatePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        presenter.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Currency",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showPicker(_:)))
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.addSubview(lastUpdateView)
        lastUpdateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastUpdateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.dateVerticalOffset),
            lastUpdateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(ratesTableView)
        NSLayoutConstraint.activate([
            ratesTableView.topAnchor.constraint(equalTo: lastUpdateView.bottomAnchor, constant: Constants.dateVerticalOffset),
            ratesTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.tableViewHorisontalOffset),
            ratesTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor , constant: -Constants.tableViewHorisontalOffset),
            ratesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        ratesTableView.refreshControl = refreshControl
    }
    
    @objc private func refreshControl(_ sender: Any) {
        presenter.refresh()
    }
    
    @objc private func showPicker(_ sender: Any) {
        presenter.showPicker()
    }
}

// MARK: - UITableViewDelegate

extension ExchangeRateViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - UITableViewDataSource

extension ExchangeRateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RateDailyCell.self), for: indexPath) as? RateDailyCell else { return UITableViewCell() }
        cell.configure(model: .init(from: presenter.rates[indexPath.row]))
        return cell
    }
}

// MARK: - ExchangeRateView

extension ExchangeRateViewController: ExchangeRateView {
    
    func reloadTableView() {
        ratesTableView.reloadData()
        refreshControl.endRefreshing()
        lastUpdateView.configure(model: Date(timeIntervalSince1970: lastUpdated()))
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    private func lastUpdated() -> Double {
        return UserDefaults.standard.value(forKey: DefaultConstants.lastUpdateKey) as? Double ?? Date().timeIntervalSince1970
    }
}

// MARK: - UIPickerViewDelegate

extension ExchangeRateViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.currency = DefaultConstants.currencies[row]
    }
}

// MARK: - UIPickerViewDataSource

extension ExchangeRateViewController: UIPickerViewDataSource {
    
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
