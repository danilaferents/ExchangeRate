//
//  ExchangeRatePresenter.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 30.08.23.
//

import Foundation

protocol IExxchangeRatePresenter {
    func viewDidLoad()
    func refresh()
    func showPicker()
    
    var rates: [DailyRateModel] { get }
    var currency: String { get set }
}

final class ExchangeRatePresenter {
    
    // Dependencies
    weak var view: ExchangeRateView?
    private let service: IBitcoinRatesService
    
    var rates = [DailyRateModel]()
    var currency = "eur"
    
    init(service: IBitcoinRatesService) {
        self.service = service
    }
}

// MARK: - IExxchangeRatePresenter

extension ExchangeRatePresenter: IExxchangeRatePresenter {
    
    func viewDidLoad() {
        loadRatesFromCoreData()
        updateRates()
    }
    
    func refresh() {
        updateRates()
    }
    
    func showPicker() {
        let pickerVC = PickerVC(delegate: self, initialCurrency: currency)
        
        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        view?.present(pickerVC, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private func loadRatesFromCoreData() {
        do {
            rates = try CoreDataManager.shared.getRates().map({
                DailyRateModel.init(from: $0)
            })
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.view?.showPairButtonAlert(.init(title: "Error",
                                                      message: "Error in loading cached data",
                                                      buttonTitle: "Try again",
                                                      buttonAction: { _ in
                    self?.loadRatesFromCoreData()
                }))
            }
        }
      view?.reloadTableView()
    }
    
    private func updateRates() {
        Task {
            do {
                let loadedRates = try await service.fetchRates(currency: self.currency)
                rates = loadedRates.map({ DailyRateModel.init(from: $0)})
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: DefaultConstants.lastUpdateKey)
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadTableView()
                }
                try CoreDataManager.shared.saveRates(loadedRates)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.view?.endRefreshing()
                    self?.view?.showPairButtonAlert(.init(title: "Error",
                                                          message: error.localizedDescription,
                                                          buttonTitle: "Try again",
                                                          buttonAction: { _ in
                        self?.updateRates()
                    }))
                }
            }
        }
    }
    
}

// MARK: - PickerVCOutput

extension ExchangeRatePresenter: PickerVCOutput {
    
    func didPickCurrency(currency: String) {
        self.currency = currency
        updateRates()
    }
}
