//
//  ExchangeRateAssembly.swift
//  ExchangeRate
//
//  Created by Danila Ferentz on 30.08.23.
//

import UIKit

final class ExchangeRateAssembly {
    
    let bitcoinService = BitcoinRatesService()
    
    func assembly() -> UIViewController {
        let presenter = ExchangeRatePresenter(service: bitcoinService)
        let vc = ExchangeRateViewController(presenter: presenter)
        presenter.view = vc
        
        return UINavigationController(rootViewController: vc)
    }
}
